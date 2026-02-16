package main

import (
	"fmt"
	"log"
	"net"
	"time"

	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
	"github.com/google/gopacket/pcap"
)

func main() {
	// Your network interface (change this!)
	iface := "wlp2s0"
	
	// Get interface info
	netInterface, err := net.InterfaceByName(iface)
	if err != nil {
		log.Fatal(err)
	}

	// Get IP and MAC of this interface
	addrs, _ := netInterface.Addrs()
	var localIP net.IP
	for _, addr := range addrs {
		if ipnet, ok := addr.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				localIP = ipnet.IP
				break
			}
		}
	}

	localMAC := netInterface.HardwareAddr

	fmt.Printf("Local IP: %s\n", localIP)
	fmt.Printf("Local MAC: %s\n", localMAC)
	fmt.Println("\nScanning network for devices...")

	// Open the device for capturing
	handle, err := pcap.OpenLive(iface, 65536, true, pcap.BlockForever)
	if err != nil {
		log.Fatal(err)
	}
	defer handle.Close()

	// Send ARP requests to discover devices
	go sendARPRequests(handle, localIP, localMAC)

	// Listen for ARP replies
	packetSource := gopacket.NewPacketSource(handle, handle.LinkType())
	for packet := range packetSource.Packets() {
		arpLayer := packet.Layer(layers.LayerTypeARP)
		if arpLayer != nil {
			arp := arpLayer.(*layers.ARP)
			
			// Only show ARP replies
			if arp.Operation == layers.ARPReply {
				fmt.Printf("Found device: IP=%s MAC=%s\n", 
					net.IP(arp.SourceProtAddress), 
					net.HardwareAddr(arp.SourceHwAddress))
			}
		}
	}
}

func sendARPRequests(handle *pcap.Handle, localIP net.IP, localMAC net.HardwareAddr) {
	// Get network prefix (e.g., 192.168.1.0/24)
	// We'll scan all IPs in the subnet
	baseIP := localIP.Mask(localIP.DefaultMask())
	
	// Scan the subnet (e.g., 192.168.1.1 to 192.168.1.254)
	for i := 1; i < 255; i++ {
		targetIP := make(net.IP, len(baseIP))
		copy(targetIP, baseIP)
		targetIP[3] = byte(i)
		
		// Build ARP request
		eth := layers.Ethernet{
			SrcMAC:       localMAC,
			DstMAC:       net.HardwareAddr{0xff, 0xff, 0xff, 0xff, 0xff, 0xff}, // Broadcast
			EthernetType: layers.EthernetTypeARP,
		}
		
		arp := layers.ARP{
			AddrType:          layers.LinkTypeEthernet,
			Protocol:          layers.EthernetTypeIPv4,
			HwAddressSize:     6,
			ProtAddressSize:   4,
			Operation:         layers.ARPRequest,
			SourceHwAddress:   []byte(localMAC),
			SourceProtAddress: []byte(localIP),
			DstHwAddress:      []byte{0, 0, 0, 0, 0, 0},
			DstProtAddress:    []byte(targetIP),
		}
		
		// Serialize and send
		buf := gopacket.NewSerializeBuffer()
		opts := gopacket.SerializeOptions{FixLengths: true, ComputeChecksums: true}
		gopacket.SerializeLayers(buf, opts, &eth, &arp)
		
		handle.WritePacketData(buf.Bytes())
		time.Sleep(10 * time.Millisecond) // Don't flood the network
	}
}

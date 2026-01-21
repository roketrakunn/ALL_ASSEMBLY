#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>

int main(int argc, char *argv[]) {
    //Validate arguments
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <hex_value>\n", argv[0]);
        return 1;
    }
    
    // Parse hex string to integer
    uint16_t value = (uint16_t)strtol(argv[1], NULL, 16);
    
    // Convert to network byte order
    uint16_t network_value = htons(value);
    
    // Print as decimal (converting back to host order)
    printf("%u\n", ntohs(network_value));
    
    return 0;
}

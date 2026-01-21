#include <arpa/inet.h>
#include <errno.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <dec_value>\n", argv[0]);
        return 1;
    }

    errno = 0;
    char *end = NULL;
    unsigned long x = strtoul(argv[1], &end, 10);   // decimal input

    if (errno != 0 || end == argv[1] || *end != '\0' || x > UINT16_MAX) {
        fprintf(stderr, "Invalid 16-bit decimal value: %s\n", argv[1]);
        return 1;
    }

    uint16_t host = (uint16_t)x;
    uint16_t net  = htons(host);

    printf("0x%" PRIx16 "\n", net);
    return 0;
}


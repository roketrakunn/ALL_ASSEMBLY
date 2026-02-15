#include <stdio.h>
#include <string.h>

void secret_function() {
    printf("YOU DID IT! You hijacked execution!\n");
    printf("This function was never supposed to be called!\n\n");
}

void vulnerable_function(char *input) {
    char buffer[64];
    
    printf("Copying your input to buffer...\n");
    strcpy(buffer, input);  // No bounds checking!
    
    printf("You entered: %s\n", buffer);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <input>\n", argv[0]);
        return 1;
    }
    
    printf("=== Buffer Overflow Demo ===\n");
    printf("Try to call secret_function() without modifying the code!\n\n");
    
    vulnerable_function(argv[1]);
    
    printf("Program finished normally.\n");
    return 0;
}

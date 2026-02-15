#include <stdio.h>
#include <string.h>
int check_password(char *password) { 
    //This is the fake secret password
    char correct[] = "hackplanet" ; 

    if (strcmp(password, correct) == 0){ 
        return 1 ;
    }
    return 0;
}

int main() { 
    char input[100] ;
    printf("Enter password: ");
    scanf("%99s", input);

    if (check_password(input)) { 
        printf("Acess granted! I now baptise you with the holy water of hacker spirit!\n");
    } else { 
        printf("Acess Denied: You are still a normie Booouyy\n"); 
    }
    return 0;
}


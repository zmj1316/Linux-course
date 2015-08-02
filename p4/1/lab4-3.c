#include <stdio.h>
main()
{
    int i;
    i = 0;
    sleep(10);
    while (i < 5) {
        system("date");
        sleep(5);
        i++;
    }
    while (1) {
        system("date");
        sleep(10);
    }
}

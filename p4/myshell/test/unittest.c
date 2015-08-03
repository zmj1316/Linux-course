#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#define MAXLEN 100 /* The maximum length */

static int parser(char *CMD, char arg[][MAXLEN + 1])
{
	int i = 0;
	int b = 0;
	char c;
	/*skip leading spaces*/
	while ((c = *CMD++) == ' ') ;
	while (c != 0)
	{
		if (c == ' ')
		{
			arg[i][b++] = 0;
			b = 0;
			i++;
			while (*CMD == ' ') CMD++;
		}
		else
		{
			arg[i][b++] = c;
		}
		c = *CMD++;
	}
	arg[i][b++] = 0;
	return i;
}

int main()
{
	char	CMD[MAXLEN + 1];
	char	arg[MAXLEN + 1][MAXLEN + 1];
	int arc;
	printf("Input CMD>");
	gets(CMD);
	arc = parser(CMD,arg);
	for (int i = 0; i <= arc; ++i)
	{
		printf("%s\n",arg[i]);
	}
	getchar();
}

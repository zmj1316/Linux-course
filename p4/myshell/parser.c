#include "global.h"
#include "parser.h"
/*Parse the commands*/
int parser(
	const char *CMD, /* The command to parse*/
	char arg[][MAXLEN + 1]) /* Arguments */
{
	int i = 0;
	int b = 0;
	char c;
	while ((c = *CMD++) == ' ') ; /*Skip leading spaces*/
	while (c != 0 || c == '\n') /*Stop while reach NULL or Enter*/
	{
		if (c == ' ')
		{
			arg[i][b++] = 0; /*End of string*/
			b = 0;
			i++;
			while (*CMD == ' ') CMD++; /*Skip multi spaces*/
		}
		else
		{
			arg[i][b++] = c;
		}
		c = *CMD++;
	}
	arg[i][b++] = 0; /*End of string*/
	return i;
}


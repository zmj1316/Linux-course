/*
 * (C) 2015 Key Zhang
 * @parser.c
 * @Feature: To turn a string of arguments into a array.
 */
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
	while (c != 0 && c != '\n') /*Stop while reach NULL or Enter*/
	{
	    if (c == '\\')
	    {
	        c = *CMD++;
	        arg[i][b++] = c;
	        c = *CMD++;
	        continue;
	    }
		if (c == ' ' || c =='\t')
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


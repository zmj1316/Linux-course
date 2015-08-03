#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include "global.h"
#include "myshell.h"
#include "parser.h"
#include "buildin.h"



char 	pwd[MAXLEN + 1];
char	cmd[MAXLEN + 1];
char	arg[MAXLEN + 1][MAXLEN + 1];
int 	INPUT;
FILE 	*IN;
int err;


int main(int argc, char *argv[]) 
{
    const char *ptr=cmd;
	while(1){
		getcwd(pwd, MAXLEN + 1); 
		fprintf(stdout,"%s>", pwd);
		fflush(stdin);
		/* wait for user input from stdin */
		if (argc == 1)
		{
			INPUT = STD;
			IN = stdin; 
		}
		/* else from script file */
		else
		{
			INPUT = FIL;
			IN = fopen(argv[1], "r");
			if (IN == NULL)
			{
				fprintf(stderr, "File %s not found\n", argv[1]);
				exit(1);
			}
		}
		fgets(cmd, MAXLEN, IN);
		int arg_c = parser(cmd, arg);
		if (buildin(arg))
		{
			continue;
		}
		

		getchar();	
	}
	
}

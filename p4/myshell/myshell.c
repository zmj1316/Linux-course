#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include "global.h"
#include "myshell.h"
#include "parser.h"
#include "buildin.h"
#include "exec.h"


char 	pwd[MAXLEN + 1];	/*PWD var*/
char	cmd[MAXLEN + 1];	/*cmd buffer*/
char	arg[MAXLEN + 1][MAXLEN + 1];/*arguments buffer*/
int 	INPUT;/*Input type*/
FILE 	*IN;  /*Input stream*/
int err;	  /*Error code*/


int main(int argc, char *argv[]) 
{
	while(1){
		getcwd(pwd, MAXLEN + 1);	/*get PWD*/
		fprintf(stdout,"%s>", pwd);	/*Print promote*/
		fflush(stdin);
		/* Wait for user to input from stdin */
		if (argc == 1)
		{
			INPUT = STD;
			IN = stdin; 
		}
		/* Else from the script file */
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
		fgets(cmd, MAXLEN, IN);	/*Read CMD*/
		int arg_c = parser(cmd, arg);/*Parse arguments*/
		/*Check for buildin cmds*/
		if (buildin(arg_c,arg))
		{
			continue;
		}
		excute(arg_c,arg);
	}
	
}

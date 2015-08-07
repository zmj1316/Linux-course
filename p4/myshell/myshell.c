#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include "global.h"
#include "myshell.h"
#include "parser.h"
#include "buildin.h"
#include "exec.h"


char 	*pwd;	/*PWD var*/
char	cmd[MAXLEN + 1];	/*cmd buffer*/
char	arg[MAXLEN + 1][MAXLEN + 1];/*arguments buffer*/
int 	INPUT;/*Input type*/
FILE 	*IN;  /*Input stream*/
int err;	  /*Error code*/

void getpwd()
{
    for (int i = 0; environ[i]; ++i)
    {
        char temp[5];
        memcpy(temp,environ[i],4);
        temp[4]=0;
        if (!strcmp(temp,"PWD="))
        {
            pwd = environ[i] + 4;
            return;
        }
            
    }
}

int main(int argc, char *argv[]) 
{
	while(1){
        getpwd();
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

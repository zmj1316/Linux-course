/*
 * (C) 2015 Key Zhang
 * @myshell.c
 * @Feature: The entrance of this program, deal with the
 * 	I/O including redirect. And environ setup.
 */
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
		/*Add environ*/
		char shell[MAXLEN]="shell=";	/*Parent environ var */
	    strcat(shell,pwd);				
	    strcat(shell,"/myshell");
	    putenv(shell);
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
		/* I/O redirect */
		for (int i = 1; i <= arg_c; i++) {
		    if (!strcmp(arg[i],"<"))
			{
			    ++i;
				if ( freopen(arg[i],"r",stdin) == NULL )
					fprintf(stderr, "%s Not Exist!", arg[i]);
			}
			if (!strcmp(arg[i],">"))
			{
			    ++i;
				if( freopen(arg[i],"w",stdout) == NULL )
					fprintf(stderr, "%s Access Denied!", arg[i]);
			}
			if (!strcmp(arg[i],">>"))
			{
			    ++i;
				if( freopen(arg[i],"a",stdout) == NULL )
					fprintf(stderr, "%s Access Denied!", arg[i]);
			}
		}
		/* Try to run buildin cmds */
		if (!buildin(arg_c,arg))
		{
			/* Run external cmds*/
			excute(arg_c,arg);
		}
		fflush(stdout);
		/* Recover the stdio from redirect */
		freopen("/dev/tty","r",stdin);
		freopen("/dev/tty","w",stdout);
	}
}

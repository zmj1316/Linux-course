#include "exec.h"
#include "global.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>

void excute(int arg_c, char arg[][MAXLEN + 1])
{
	pid_t pid;	
	char *arg_temp[MAXLEN + 1]; 	/*Array of arguments*/
	char parent[MAXLEN]="parent=";	/*Parent environ var */
	strcat(parent,pwd);				
	strcat(parent,"/myshell");
	/*Append parent to environ*/
	putenv(parent);

	/*Fork new process*/
	if ((pid = fork()) < 0)		/*Fork error*/
		fprintf(stderr, "Fork error.");
	else if (pid == 0){			/*Child process*/
		/* Have parameter */
		if (arg_c != 0){
		    int i;
			for (i = 0; i <= arg_c ; ++i)
			{
				arg_temp[i] = arg[i];
				if (!(strcmp(arg[i],"<") && strcmp(arg[i],">") && strcmp(arg[i],">>")))
				    break;
			}
			if (!strcmp(arg[arg_c],"&")) arg_temp[arg_c]=NULL;
			arg_temp[i] = NULL;
			execvp(arg[0], arg_temp);	/*execute*/
		}
		else{
			execlp(arg[0],arg[0],(char*)0);
		}
		exit(0);
	}
	else{
			/* parent process */
		    int status;
		    /* Remove parent env*/
		    unsetenv("parent");
		    /* Background process */
		    if (!strcmp(arg[arg_c],"&"))
		        return;
		    /* Wait for the child process */
			if ((pid == waitpid(pid, &status, 0)) < 0) 
				fprintf(stderr, "waitpid error...");
			return;
	}
}
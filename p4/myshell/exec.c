#include "exec.h"
#include "global.h"
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>

void excute(int arg_c, char arg[][MAXLEN + 1])
{
	pid_t pid;	
	char *arg_temp[MAXLEN + 1]; 	/*Array of arguments*/
	char parent[MAXLEN]="parent=";	/*Parent environ var */
	strcat(parent,pwd);				
	strcat(parent,"myshell");
	/*Append parent to environ*/
	int i;
	for (i = 0; environ[i]; ++i);
	environ[i] = (char*)malloc(strlen(parent));

	/*Fork new process*/
	if ((pid = fork()) < 0)		/*Fork error*/
		fprintf(stderr, "Fork error.");
	else if (pid == 0){			/*Child process*/
		/* Have parameter */
		if (arg_c != 0){
		    int i;
			for (i = 0; i <= arg_c && strcmp(arg[i],"&"); ++i)
				arg_temp[i] = arg[i];
			arg_temp[i] = NULL;
			execvp(arg[0], arg_temp);	/*execute*/
		}
		else{
			execlp(arg[0],arg[0],(char*)0);
		}
	}
	/* parent process */
    int status;
    /* Remove parent env*/
    free(environ[i]);
    environ[i] = NULL;

    /* Background process */
    if (!strcmp(arg[arg_c],"&"))
        return;
    /* Wait for the child process */
	if ((pid == waitpid(pid, &status, 0)) < 0) 
		fprintf(stderr, "waitpid error...");
	return ;
}
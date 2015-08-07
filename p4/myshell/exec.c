#include "exec.h"
#include "global.h"
#include <stdio.h>
#include <unistd.h>

void excute(int arg_c, char arg[][MAXLEN + 1])
{
	pid_t pid;
	char *arg_temp[MAXLEN + 1]; 
	char parent[MAXLEN]="parent=";
	strcat(parent,PWD);
	strcat(parent,"myshell");
	char *envp[]={parent,NULL};
	if ((pid = fork()) < 0)
		fprintf(stderr, "Fork error.");
	else if (pid == 0){
		/* have parameter */
		if (arg_c != 0){
			for (i = 0; i <= arg_c; ++i)
				arg_temp[i] = arg[i];
			arg_temp[i] = NULL;
			execvp(arg[0], arg_temp, envp);
		}
		else{
			execlp(arg[0],NULL, envp);
		}
	}

	if ((pid == waitpid(pid, &status, 0)) < 0)
		fprintf(stderr, "waitpid error...");
	return ;
}
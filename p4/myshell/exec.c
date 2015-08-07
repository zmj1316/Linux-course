#include "exec.h"
#include "global.h"
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
void excute(int arg_c, char arg[][MAXLEN + 1])
{
	pid_t pid;
	char *arg_temp[MAXLEN + 1]; 
	char parent[MAXLEN]="parent=";
	strcat(parent,pwd);
	strcat(parent,"myshell");
	char *envp[]={parent,NULL};
	if ((pid = fork()) < 0)
		fprintf(stderr, "Fork error.");
	else if (pid == 0){
		/* have parameter */
		if (arg_c != 0){
		    int i;
			for (i = 0; i <= arg_c && strcmp(arg[i],"&"); ++i)
				arg_temp[i] = arg[i];
			arg_temp[i] = NULL;
			execvp(arg[0], arg_temp);
		}
		else{
			execlp(arg[0],arg[0],(char*)0);
		}
	}
    int status;
    if (!strcmp(arg[arg_c],"&"))
        return;
	if ((pid == waitpid(pid, &status, 0)) < 0)
		fprintf(stderr, "waitpid error...");
	return ;
}
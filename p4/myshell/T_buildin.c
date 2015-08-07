#include "buildin.c"
#include "parser.c"
#include "exec.c"
char 	pwd[MAXLEN + 1];
char	cmd[MAXLEN + 1];
char	arg[MAXLEN + 1][MAXLEN + 1];
int main()
{
	while(1)
	{
		getcwd(pwd, MAXLEN + 1); 
		printf("%s>", pwd);
		fgets(cmd,MAXLEN,stdin);
		int arg_c=parser(cmd, arg);
		excute(arg_c,arg);
	}
}

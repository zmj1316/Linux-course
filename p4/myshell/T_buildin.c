#include "buildin.c"
#include "parser.c"
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
		parser(cmd, arg);
		buildin(arg);
	}
}
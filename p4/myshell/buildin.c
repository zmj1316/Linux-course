#include "buildin.h"
#include <string.h>
#include <errno.h>
int buildin(char arg[][MAXLEN + 1] )
{
	if (!strcmp(arg[0],"cd"))
	{
		b_cd(arg[1]);
		return 1;
	}
	if (!strcmp(arg[0],"pwd"))
	{
		b_pwd();
	}
	return 0;
}
static void b_cd(const char *dst)
{
	fprintf(stdout, "cd::%s\n",dst);
	if (dst[0] != 0){
		if (!chdir(dst))
			strcpy(pwd, dst); /* update the current work director */
		else{
			/* error process */
			if (errno == ENOENT){
				fprintf(stdout, "ddsh: cd: %s: No such file or directory\n", dst);
				errno = 0; /* resume */
			}
			else if (errno == ENOTDIR){
				fprintf(stdout, "ddsh: cd: %s: Not a directory\n", dst);
				errno = 0;
			}
		}
	}
}
static void b_pwd()
{
	fprintf(stdout, "%s\n", pwd);
}
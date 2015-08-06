#include "buildin.h"
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <errno.h>
#include <time.h>

int stat(const char *path, struct stat *buf);

int buildin(int arg_c, char arg[][MAXLEN + 1])
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
	if (!strcmp(arg[0],"clr"))
	{
		b_clr();
	}
	if (!strcmp(arg[0],"dir"))
	{
        b_dir();
	}
    if (!strcmp(arg[0],"echo"))
    {
        b_echo(arg_c,arg);
    }
    if (!strcmp(arg[0],"help"))
    {
        b_help();
    }
    if (!strcmp(arg[0],"quit"))
    {
        b_quit();
    }
    if (!strcmp(arg[0],"env"))
    {
        b_env();
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

static void b_clr()
{
	printf("%c%c%c%c%c%c",27,'[','H',27,'[','J' );
}

static void b_dir()
{
	b_ls(".");
}

static void b_echo(int arg_c, char arg[][MAXLEN + 1])
{
    for (int i = 1; i < arg_c; ++i)
    {
        fflush(stdout);
        fprintf(stdout, "%s ", arg[i]);
    }
    fprintf(stdout, "%s\n", arg[arg_c]);
}

static void b_help()
{
    FILE *fp = fopen("help.txt","r");
    if (fp==NULL)
    {
        fprintf(stderr,"Manual not exist!\n");
        exit(1);
    }
    b_more(fp);
}

static void b_quit()
{
    exit(0);
}

static void b_env()
{
    char cpath[MAXLEN];
    readlink ("/proc/self/exe", cpath, MAXLEN);
    fprintf(stdout,"%-10s\t%-20s\n","PWD",pwd);
    fprintf(stdout,"%-10s\t%-20s\n","SHELL",cpath);
}
#define PAGELEN 24
#define LINELEN 512

void b_more(FILE * fp)
{
	char line[LINELEN];
	int  num_of_lines = 0;
	int see_more(), reply;
	while (fgets(line, LINELEN, fp))
	{
		if (num_of_lines == PAGELEN)
		{
			reply = see_more();
			if (reply == 0)
				break;
			num_of_lines -= reply;
		}
		if (fputs(line, stdout) == EOF)
			return;
		num_of_lines++;
	}
}

int see_more()
{
	int c;
	printf("\033[7m more?\033[m");
	while ((c = getchar()) != EOF)
	{
		if (c == 'q')
			return 0;
		if (c == ' ')
			return PAGELEN;
		if (c == '\n')
			return 1;
	}
	return 0;
}






static void b_ls(char dirname[])
{
/*
 *定义一个目录流,和目录流结构体保存读到的结果。
 */
        DIR *dir_ptr;
        struct dirent *direntp;
        if((dir_ptr = opendir(dirname)) == NULL)
                fprintf(stderr,"ls1:cannot open %s\n",dirname);
        else
        {
                while((direntp = readdir(dir_ptr)) != NULL)
                        dostat(direntp->d_name);
 
//printf("%s\n",direntp->d_name);
        //关闭目录流
                closedir(dir_ptr);
        }
}
 
//获取文件信息stat结构体
void dostat(char *filename)
{
        struct stat info;
        if(stat(filename,&info) == -1)
                perror(filename);
        else
                show_file_info(filename,&info);
}
 
#include <pwd.h>
char *uid_to_name(uid_t uid)
{
        struct passwd *getpwuid(),*pw_ptr;
        static char numstr[10];
        if((pw_ptr = getpwuid(uid)) == NULL){
                sprintf(numstr,"%d",uid);
                return numstr;
        }
        else
                return pw_ptr->pw_name;
}
 
#include <grp.h>
char *gid_to_name(gid_t gid)
{
         struct group *getgrgid(),*grp_ptr;
        static char numstr[10];
        if((grp_ptr = getgrgid(gid)) == NULL){
                sprintf(numstr,"%d",gid);
                return numstr;
        }
        else
                return grp_ptr->gr_name;
}
void show_file_info(char *filename,struct stat *info_p)
{
        // char *uid_to_name(),*ctime(),*gid_to_name(),*filemode();
//      void mode_to_letters();
        char modestr[11];
        mode_to_letters(info_p->st_mode,modestr);
        printf("%s",modestr);
        printf("%4d ",(int)info_p->st_nlink);
        printf("%-8s",uid_to_name(info_p->st_uid));
        printf("%-8s",gid_to_name(info_p->st_gid));
        printf("%8ld",(long)info_p->st_size);
        printf(" %.12s",4+ctime(&(info_p->st_mtime)));
        printf(" %s\n",filename);
}
 
//分析mode权限
void mode_to_letters(int mode,char str[])
{
//S_IS***测试宏
        strcpy(str,"----------");
        if(S_ISDIR(mode))str[0] = 'd';
        if(S_ISCHR(mode))str[0] = 'c';
        if(S_ISBLK(mode))str[0] = 'b';
 
//与 掩码
        if(mode&S_IRUSR)str[1] = 'r';
        if(mode&S_IWUSR)str[2] = 'w';
        if(mode&S_IXUSR)str[3] = 'x';
 
        if(mode&S_IRGRP)str[4] = 'r';
        if(mode&S_IWGRP)str[5] = 'w';
        if(mode&S_IXGRP)str[6] = 'x';
 
        if(mode&S_IROTH)str[7] = 'r';
        if(mode&S_IWOTH)str[8] = 'w';
        if(mode&S_IXOTH)str[9] = 'x';
}

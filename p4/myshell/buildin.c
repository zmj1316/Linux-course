#include "buildin.h"
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
int stat(const char *path, struct stat *buf);

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
	if (!strcmp(arg[0],"clr"))
	{
		b_clr();
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
        //打印结果
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
 
//分析stat结构体
                show_file_info(filename,&info);
}
 
void show_file_info(char *filename,struct stat *info_p)
{
        char *uid_to_name(),*ctime(),*gid_to_name(),*filemode();
//      void mode_to_letters();
        char modestr[11];
        mode_to_letters(info_p->st_mode,modestr);
        printf("%s",modestr);
        printf("%4d",(int)info_p->st_nlink);
        printf("%-8s",uid_to_name(info_p->st_uid));
        printf("%-8s",gid_to_name(info_p->st_gid));
        printf("%8ld",(long)info_p->st_size);
        printf("%.12s",4+ctime(&info_p->st_mtime));
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
// uid gid to name group
/*#include<pwd.h>
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
 
#include<grp.h>
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
}*/
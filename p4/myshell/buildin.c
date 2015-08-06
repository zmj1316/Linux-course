#include "buildin.h"
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <errno.h>
#include <time.h>
/*get file stat*/
int stat(const char *path, struct stat *buf);

/*run buildin cmds*/
int buildin(/*0: Is not a buildin cmd */
            /*1: Is a buildin cmd*/ 
    int arg_c, /*argument count*/
    char arg[][MAXLEN + 1] /*arguments*/
    ) 
{
    /*compare cmds*/
	if (!strcmp(arg[0],"cd"))
	{
		b_cd(arg[1]);
		return 1;
	}
	if (!strcmp(arg[0],"pwd"))
	{
		b_pwd();
        return 1;
	}
	if (!strcmp(arg[0],"clr"))
	{
		b_clr();
        return 1;
	}
	if (!strcmp(arg[0],"dir"))
	{
        b_dir();
        return 1;
	}
    if (!strcmp(arg[0],"echo"))
    {
        b_echo(arg_c,arg);
        return 1;
    }
    if (!strcmp(arg[0],"help"))
    {
        b_help();
        return 1;
    }
    if (!strcmp(arg[0],"quit"))
    {
        b_quit();
        return 1;
    }
    if (!strcmp(arg[0],"env"))
    {
        b_env();
        return 1;
    }
	return 0;
}

static void b_cd ( /*run cd cmd*/
            const char *dst /*dst directory*/
            )
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

/*print pwd*/
static void b_pwd()
{
	fprintf(stdout, "%s\n", pwd);
}

/*clean the screen*/
static void b_clr()
{
	printf("%c%c%c%c%c%c",27,'[','H',27,'[','J' );
}

/*show files in the directory*/
static void b_dir()
{
	b_ls(".");
}

/*echo messages on screen*/
static void b_echo(
            int arg_c, /*arguments count*/
            char arg[][MAXLEN + 1] /*arguments*/
            )
{
    for (int i = 1; i < arg_c; ++i)
    {
        fflush(stdout);
        fprintf(stdout, "%s ", arg[i]);
    }
    fprintf(stdout, "%s\n", arg[arg_c]);
}

/*print help message with more*/
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

/*quit the shell*/
static void b_quit()
{
    exit(0);
}

/*show env vars*/
static void b_env()
{
    char cpath[MAXLEN];
    readlink ("/proc/self/exe", cpath, MAXLEN);
    fprintf(stdout,"%-10s\t%-20s\n","PWD",pwd);
    fprintf(stdout,"%-10s\t%-20s\n","SHELL",cpath);
}

/*******************************/
/*  Private Functions          */
/*******************************/

/*more function */
/*      To print a long message in parts*/
#define PAGELEN 24
#define LINELEN 512

void b_more(
     FILE * fp /*The file to print*/
     )
{
	char line[LINELEN];    /* Text Buffer */
	int  num_of_lines = 0; /* Count of the lines printed*/
	int  reply;            /* The reply of user*/
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

/* Show files unsder the dir*/
static void b_ls(char dirname[])
{
    DIR *dir_ptr;   /*The directory to read*/
    struct dirent *direntp; /*The dir info struct*/
    if((dir_ptr = opendir(dirname)) == NULL)    /* Try to open the dir*/
        fprintf(stderr,"ls1:cannot open %s\n",dirname);
    else
    {
        while((direntp = readdir(dir_ptr)) != NULL) /* Read the dir info */
                dostat(direntp->d_name); /* */
        closedir(dir_ptr);  /* Close the dir */
    }
}
 
/* Analyse the file/dir */
void dostat(char *filename)
{
    struct stat info;
    if(stat(filename,&info) == -1)
        perror(filename);
    else
        show_file_info(filename,&info);
}
 
/* Get username from uid */
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
 
/* Get groupname from gid */
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

/* Print the file info */
void show_file_info(char *filename,struct stat *info_p)
{
    char modestr[11]; /* String of the mode */
    mode_to_letters(info_p->st_mode,modestr);
    printf("%s",modestr);
    printf("%4d ",(int)info_p->st_nlink);
    printf("%-8s",uid_to_name(info_p->st_uid));
    printf("%-8s",gid_to_name(info_p->st_gid));
    printf("%8ld",(long)info_p->st_size);
    printf(" %.12s",4+ctime(&(info_p->st_mtime)));
    printf(" %s\n",filename);
}
 
/* Turn authority to str */
void mode_to_letters(int mode,char str[])
{
    strcpy(str,"----------");   /*Initial string*/
    /*Type*/
    if(S_ISDIR(mode))str[0] = 'd';
    if(S_ISCHR(mode))str[0] = 'c';
    if(S_ISBLK(mode))str[0] = 'b';
    /*user authority*/
    if(mode&S_IRUSR)str[1] = 'r';
    if(mode&S_IWUSR)str[2] = 'w';
    if(mode&S_IXUSR)str[3] = 'x';
    /*group authority*/
    if(mode&S_IRGRP)str[4] = 'r';
    if(mode&S_IWGRP)str[5] = 'w';
    if(mode&S_IXGRP)str[6] = 'x';
    /*other authority*/
    if(mode&S_IROTH)str[7] = 'r';
    if(mode&S_IWOTH)str[8] = 'w';
    if(mode&S_IXOTH)str[9] = 'x';
}

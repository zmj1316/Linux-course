#ifndef BUILDIN_H
#define BUILDIN_H 
#include "global.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <pwd.h>
#include <grp.h>
int buildin(int, char [][MAXLEN + 1]);	
static void b_cd(const char *);
static void b_pwd();
static void b_clr();
static void b_dir();
static void b_ls(char *);
static void b_echo(int, char [][MAXLEN + 1]);
void dostat(char *);
void show_file_info(char *,struct stat *);
void mode_to_letters(int mode,char str[]);
// uid gid to name group

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
#endif
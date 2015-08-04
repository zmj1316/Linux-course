#ifndef BUILDIN_H
#define BUILDIN_H 
#include "global.h"


int buildin(char [][MAXLEN + 1]);	
static void b_cd(const char *);
static void b_pwd();
static void b_clr();
static void b_dir();
static void b_ls(char *);
void dostat(char *);
void show_file_info(char *,struct stat *);
void mode_to_letters(int mode,char str[]);

#endif
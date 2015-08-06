#ifndef BUILDIN_H
#define BUILDIN_H 
#include "global.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>


int buildin(int, char [][MAXLEN + 1]);	
static void b_cd(const char *);
static void b_pwd();
static void b_clr();
static void b_dir();
static void b_ls(char *);
static void b_echo(int, char [][MAXLEN + 1]);
static void b_help();
static void b_more();
static void b_quit();
static void b_env();
static int see_more();
void dostat(char *);
void show_file_info(char *,struct stat *);
void mode_to_letters(int mode,char str[]);
// uid gid to name group
#endif
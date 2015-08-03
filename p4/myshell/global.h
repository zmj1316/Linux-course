#ifndef GLOBAL_H
#define GLOBAL_H

#include <stdio.h>
#include <unistd.h>

#define MAXLEN 100 /*Max length*/

extern char 	pwd[MAXLEN + 1];
extern char		cmd[MAXLEN + 1];
extern char		arg[MAXLEN + 1][MAXLEN + 1];

// typedef enum {
// 	CD,PWD,CLR,DIR,ENV,ECHO,HELP,QUIT
//   }BuildinType;

#endif
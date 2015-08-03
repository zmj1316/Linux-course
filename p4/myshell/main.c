#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define MAXLEN 100 /* The maximum length */

#define STD 0
#define FIL 1


char 	PWD[MAXLEN+1];
char	CMD[MAXLEN+1];
int 	INPUT;
FILE 	*IN;

int main(int argc, char *argv[]) {
	while(1){
			getcwd(PWD, MAXLEN + 1); 
		printf("%s>", PWD);
		fflush(stdout);
		/* wait for user input from stdin */
		if (argc == 1){
			INPUT  = STD;
			IN = stdin; 
		}
		/* else from script file */
		else{
			INPUT  = FIL;
			IN = fopen(argv[1], "r");
			if (IN == NULL){
				fprintf(stderr, "File %s not found\n", argv[1]);
				exit(1);
			}
		}
		fgets(CMD,MAXLEN,IN);
		if (chdir(CMD)<0)
		{
			printf("chdir failed!\n");
			getchar();	
			continue;
		}
		getcwd(PWD, MAXLEN + 1); 
		printf("%s>", PWD);
		getchar();	
	}
	
}

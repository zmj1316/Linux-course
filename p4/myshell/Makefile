CC = gcc -std=c99 -w
main: myshell.o parser.o buildin.o
	$(CC) myshell.o parser.o buildin.o -o main 
myshell.o: myshell.c parser.o buildin.o 
	$(CC) -c myshell.c
parser.o: parser.c 
	$(CC) -c parser.c
buildin.o :buildin.c 
	$(CC) -c buildin.c
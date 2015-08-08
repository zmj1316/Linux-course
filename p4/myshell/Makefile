CC = gcc -std=c99 -w
main: myshell.o parser.o buildin.o exec.o
	$(CC) myshell.o parser.o buildin.o exec.o -o main 
	./main
myshell.o: myshell.c parser.o buildin.o myshell.h
	$(CC) -c myshell.c
parser.o: parser.c parser.h
	$(CC) -c parser.c
buildin.o :buildin.c buildin.h
	$(CC) -c buildin.c
exec.o :exec.c exec.h
	$(CC) -c exec.c
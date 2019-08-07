# Linux-course
自己的作业自己做

# project3 shell programming
# project4

## Myshell

### I/O Redirect 

#### Intro
There are always three default files open, `stdin` (the keyboard), `stdout` (the screen), and `stderr` (error messages output to the screen). These, and any other open files, can be redirected. Redirection simply means capturing output from a file, command, program, script, or even code block within a script and sending it as input to another file, command, program, or script.

#### Usage

-  '<  [Filename]' : redirect the `stdin` to a file.
-  '>  [Filename]' : redirect the `stdout` to cover a file.
-  '>> [Filename]' : redirect the `stdout` to append to a file.

### Environ
The variable environ points to an array of strings called the 'environment', which can be inherited from parent process. In `myshell` program, there's a environ var called shell that stores the full path of this `myshell` program. And for all processes created by `myshell`, there's a var called `parent` that points out the path of the parent process.

### Background process
Background processes run behind the scenes and without user intervention. Append a '&' at the end of a command can turn it to a backgound process.


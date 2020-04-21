//
//  dog.c
//  Assignment1
//
//  Created by Arturo Molina on 4/11/20.
//  argmolin @ucsc.edu
//


#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#define MAX_ALLOC 32768u


// int stdIn(): prints lines from stdIn to stdOut
//  params:
//  returns: 0 on success, 1 on exit and failure
int stdIn(){
    char *next;
    ssize_t sz, wsz;
    
    next = malloc(MAX_ALLOC);
    sz = read(STDIN_FILENO, next, MAX_ALLOC);
    
    while(sz != 0){
        wsz = write(STDOUT_FILENO, next, sz);
        free(next);
        next = malloc(MAX_ALLOC);
        sz = read(STDIN_FILENO, next, MAX_ALLOC);
    }
    return 0;
}


// int fileIn(): prints the contents of a single file to stdOut
//  params: unsigned 8 bit integer i for current iteration of args
//          fileNames[] --> argv[]
//  returns: 0 on success, 1 on exit and failure
int fileIn(u_int8_t i, const char * fileNames[]){

    char errStr[5 + strlen(fileNames[i])];
    char fName[sizeof(fileNames[i]) * strlen(fileNames[i])];
    strcpy(errStr, "dog: ");
    strcpy(fName, fileNames[i]);
    strcat(errStr,fName);
    
    char *inputBuffer = malloc(MAX_ALLOC); //need to change this to constant
    int fd = open(fileNames[i],O_RDONLY | O_EXCL);
    if(fd == -1){
        perror(errStr);
        return 1;
    }
    
    ssize_t sz = read(fd, inputBuffer, MAX_ALLOC);
    if(sz == -1){
        perror(errStr);
        return 1;
    }
    
    ssize_t wsz = write(STDOUT_FILENO, inputBuffer, sz);
    if(wsz == -1){
        perror(errStr);
        return 1;
    }
    
    close(fd);
    free(inputBuffer);
    
    return 0;
}


int main(int argc, const char * argv[]) {
    
    bool dashSeen = false;
    bool errorFlag = false;
    
    // check for unique case that there are no files or dash
    if (argc == 1) {
        if (stdIn() != 0) errorFlag = true;
    }

    for (u_int8_t i = argc - 1; i > 0; i--) {
        if(strcmp(argv[i],"-") == 0){
            if(dashSeen != true){
                if (stdIn() != 0) errorFlag = true;
                dashSeen = true;
            }else{
                perror("dog: more than one - specified in args");
            }
        }else{
            if (fileIn(i, argv) != 0) errorFlag = true;
        }
    }
   
    
    if(errorFlag == true){
        return 1;
    }else{
        return 0;
    }
}




#ifndef FILE_H
#define FILE_H

#include "../include/rotation.h"
#include <stdbool.h>
#include <stdio.h>

enum status_code {
    OK = 0,
    FILE_OPEN_ERROR,
    FILE_READ_ERROR,
    HEADER_READ_ERROR,
    CONTENT_READ_ERROR,
    HEADER_WRITE_ERROR,
    CONTENT_WRITE_ERROR,
    FILE_WRITE_ERROR,
    FILE_CLOSE_ERROR,
    FILE_FORMAT_ERROR
};

void print_status_code(enum status_code status_code);
bool file_open(const char* file_name, const char* mode, struct image* image);
void file_close(FILE* file);

#endif //FILE_H

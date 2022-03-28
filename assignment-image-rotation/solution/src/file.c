#include "../include/bmp.h"
#include "../include/file.h"
#include <string.h>

const char* messages[] = {
        [OK] = "OK.\n",
        [FILE_OPEN_ERROR] = "File cannot be opened.\n",
        [FILE_READ_ERROR] = "File cannot be read.\n",
        [HEADER_READ_ERROR] = "Error occurred while reading header from file.\n",
        [CONTENT_READ_ERROR] = "Error occurred while reading content from file.\n",
        [HEADER_WRITE_ERROR] = "Error occurred while writing header to file.\n",
        [CONTENT_WRITE_ERROR] = "Error occurred while writing content to file.\n",
        [FILE_WRITE_ERROR] = "Cannot write to file.\n",
        [FILE_CLOSE_ERROR] = "File cannot be closed.\n",
        [FILE_FORMAT_ERROR] = "Cannot resolve file format.\n"
};

void print_status_code(enum status_code status) {
    printf("%s", messages[status]);
}

bool file_open(const char* file_name, const char* mode, struct image* image) {
    FILE* file = fopen(file_name, mode);
    if(file == NULL) {
        print_status_code(FILE_OPEN_ERROR);
        return false;
    } else {
        if (strcmp(mode, "rb") == 0) {
            print_status_code(from_bmp(file, image));
            file_close(file);
            return true;
        }
        if (strcmp(mode, "wb") == 0) {
            struct image output_image = rotate(*image);
            print_status_code(to_bmp(file, &output_image));
            image_free(*image);
            image_free(output_image);
            file_close(file);
            return true;
        }
        file_close(file);
        return false;
    }
}

void file_close(FILE* file) {
    if (fclose(file) != 0) {
        print_status_code(FILE_CLOSE_ERROR);
    }
}

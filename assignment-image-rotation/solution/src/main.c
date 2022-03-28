#include "../include/file.h"
#include "../include/image.h"

int main( int argc, char** argv ) {
    setvbuf(stdout, NULL, _IONBF, 0);
    if (argc != 3) {
        fprintf(stderr, "Ошибка! Ожидаемый формат ввода - ./executable <source_image.bmp> <transformed_image.bmp>");
        return 0;
    }
    struct image input_image = {0};

    if (!file_open(argv[1], "rb", &input_image)) {
        return 0;
    }
    if (!file_open(argv[2], "wb", &input_image)) {
        return 0;
    }
    return 0;
}

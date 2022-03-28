#include "../include/image.h"

struct image image_create(uint64_t height, uint64_t width) {
    struct image image = {0};
    image.height = height;
    image.width = width;
    image.data = malloc(sizeof(struct pixel) * image.width * image.height);
    return image;
}

void image_free(struct image image) {
    free(image.data);
}

void pixel_set(struct image image, const struct pixel pixel, uint64_t row, uint64_t column) {
    image.data[row * image.width + column] = pixel;
}


struct pixel pixel_get(const struct image image, uint64_t row, uint64_t column) {
    return image.data[row * image.width + column];
}

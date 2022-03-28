#ifndef IMAGE_H
#define IMAGE_H

#include <malloc.h>
#include <stdint.h>

struct image {
    uint64_t height;
    uint64_t width;
    struct pixel* data;
};

struct pixel{
    uint8_t b;
    uint8_t g;
    uint8_t r;
};

struct image image_create(uint64_t height, uint64_t width);
void image_free(struct image image);
void pixel_set(struct image image, struct pixel pixel, uint64_t row, uint64_t column);
struct pixel pixel_get(struct image image, uint64_t row, uint64_t column);
#endif //IMAGE_H

#include "../include/rotation.h"
#include "../include/image.h"

struct image rotate(struct image const source_image) {
    struct image rotated_image = image_create(source_image.width, source_image.height);

    for (size_t i = 0; i < source_image.width; i++) {
        for (size_t j = 0; j < source_image.height; j++) {
            struct pixel pixel = pixel_get(source_image, j, i);
            pixel_set(rotated_image, pixel, i, rotated_image.width - 1 - j);
        }
    }
    return rotated_image;
}

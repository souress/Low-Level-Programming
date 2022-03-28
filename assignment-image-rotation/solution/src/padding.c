#include "../include/image.h"
#include "../include/padding.h"

uint8_t get_padding(const uint32_t width){
    uint8_t padding = width * sizeof(struct pixel) % 4;
    return padding ? 4-padding : padding;
}

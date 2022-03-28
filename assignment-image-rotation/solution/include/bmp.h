#ifndef BMP_H
#define BMP_H

#include "../include/file.h"
#include "../include/image.h"
#include <malloc.h>
#include <stdint.h>
#include <stdio.h>

#pragma pack(push, 1)
struct bmp_header {
uint16_t bfType;
uint32_t bfileSize;
uint32_t bfReserved;
uint32_t bOffBits;
uint32_t biSize;
uint32_t biWidth;
uint32_t biHeight;
uint16_t biPlanes;
uint16_t biBitCount;
uint32_t biCompression;
uint32_t biSizeImage;
uint32_t biXPixelsPerMeter;
uint32_t biYPixelsPerMeter;
uint32_t biClrUsed;
uint32_t biClrImportant;
};
#pragma pack(pop)

enum status_code from_bmp(FILE* in, struct image* image);

enum status_code to_bmp(FILE* out, struct image const* image);

#endif //BMP_H

#include "../include/bmp.h"
#include "../include/file.h"
#include "../include/padding.h"

static struct bmp_header g_bmp_header;

enum status_code read_bmp_header(FILE* in, struct bmp_header* bmp_header) {
    if (fread(bmp_header, sizeof(struct bmp_header), 1, in) == 1) {
        g_bmp_header = *bmp_header;
        return OK;
    } else return HEADER_READ_ERROR;
}

enum status_code read_bmp_content(FILE* in, struct image* const image) {
    const uint8_t padding = get_padding(image->width);

    for (size_t i = 0; i < image->height; i++) {
        if (fread(image->data + i * image->width, sizeof(struct pixel), image->width, in) != image->width)
            return CONTENT_READ_ERROR;
        if (fseek(in, padding, SEEK_CUR) != 0)
            return CONTENT_READ_ERROR;
    }
    return OK;
}

enum status_code write_bmp_header(FILE* out, const struct bmp_header* bmp_header) {
    if (fwrite(bmp_header, sizeof(struct bmp_header), 1, out) == 1) {
        return OK;
    } else return HEADER_WRITE_ERROR;
}

enum status_code write_bmp_content(FILE* out, struct image const* image) {
    const uint8_t padding = get_padding(image->width);
    const uint8_t paddings[3] = {0};
    for (size_t i = 0; i < image->height; i++) {
        if (fwrite(image->data + i * image->width, sizeof(struct pixel) * image->width, 1, out) != 1)
            return CONTENT_WRITE_ERROR;
        if (fwrite(paddings, padding, 1, out) != 1 && padding != 0)
            return CONTENT_WRITE_ERROR;
    }
    return OK;
}

enum status_code from_bmp(FILE* in, struct image* const image){
    printf("Reading from input...\n");
    struct bmp_header bmp_header = {0};
    enum status_code bmp_header_read_status = read_bmp_header(in, &bmp_header);
    *image = image_create(bmp_header.biHeight, bmp_header.biWidth);
    enum status_code bmp_content_read_status = read_bmp_content(in, image);

    if (bmp_header_read_status == OK) {
        if (bmp_content_read_status == OK) {
            return OK;
        } else return bmp_content_read_status;
    } else return bmp_header_read_status;
}

enum status_code to_bmp(FILE* out, struct image const* image) {
    printf("Writing to output...\n");
    struct bmp_header bmp_header = g_bmp_header;
    bmp_header.biWidth = image->width;
    bmp_header.biHeight = image->height;
    enum status_code bmp_header_write_status = write_bmp_header(out, &bmp_header);
    enum status_code bmp_content_write_status = write_bmp_content(out, image);

    if (bmp_header_write_status == OK) {
        if (bmp_content_write_status == OK) {
            return OK;
        } else return bmp_content_write_status;
    } else return bmp_header_write_status;
}

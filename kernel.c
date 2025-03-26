#define VIDEO_MEMORY 0xB8000
#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 25

void print(const char *str) {
    volatile unsigned short *video = (volatile unsigned short *)VIDEO_MEMORY;
    unsigned int i = 0;
    static unsigned int x = 0; // Horizontal position
    static unsigned int y = 0; // Vertical position

    while (str[i] != '\0') {
        if (str[i] == '\n') {
            x = 0;
            y++;
        }
        else {
            video[y * SCREEN_WIDTH + x] = (unsigned short)(str[i] | 0x0F00); // 0x0F00 : attribute (white on black)
            x++;
        }

        if (x >= SCREEN_WIDTH) {
            x = 0;
            y++;
        }

        if (y >= SCREEN_HEIGHT) {
            y = 0; // Wrap to the first line instead of staying at the last line
        }

        i++;
    }
}

void kernel_main() {
    char *message = "Salut c'est moi choupie\nPremiere ligne de test";
    print(message);

    while (1) {
        // Infinite loop
    }
}

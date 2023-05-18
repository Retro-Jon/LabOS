__asm__(
    "_start:\n\t"
    ".intel_syntax\n\t"
    "call _kernel_main\n\t"
    "jmp $\n\t"
    ".att_syntax\n\t"
);

#include "..\defines.h"
#include <stdint.h>

void kernel_main(void);
void enable_cursor(void);
void disable_cursor(void);
void move_cursor(int x, int y);
uint16_t get_cursor_pos(void);
void puts(char* text, int color, char* video_memory, int x, int y);

void puts(char* text, int color, char* video_memory, int x, int y)
{
    int c = 0;

    uint16_t va = ((y * max_columns) + x) * 2;

    while (text[c] != '\0')
    {
        if (text[c] != '\n')
        {
            video_memory[va] = text[c];
            video_memory[va + 1] = color;
        } else {
            va += max_columns * 2;
            int diff = va % max_columns;
            va -= diff + 2;
        }
        
        c++;
        va += 2;
    }
}

void enable_cursor(void)
{
    outb(0x3d4, 0x0a);
    char start = inb(0x3d5) & 0x1f;

    outb(0x3d4, 0x0a);
    outb(0x3d5, start | 0x20);
}

void disable_cursor(void)
{
    outb(0x3d4, 0x0a);
    outb(0x3d5, 0x20);
}

void move_cursor(int x, int y)
{
    uint16_t pos = (y * max_columns) + x;

    outb(0x3d4, 0x0f);
    outb(0x3d5, (uint8_t) (pos & 0xff));
    outb(0x3d4, 0x0e);
    outb(0x3d5, (uint8_t) ((pos >> 8) & 0xff));
}

uint16_t get_cursor_pos(void)
{
    uint16_t pos = 0;

    outb(0x3d4, 0x0f);
    pos |= inb(0x3d5);
    outb(0x3d4, 0x0e);
    pos |= ((uint16_t)inb(0x3d5)) << 8;

    return pos;
}

void kernel_main(void)
{
    char* video_memory = (char*) video_memory_start;

    for (int i = 0; i < 80 * 25; i++)
    {
        video_memory[i] = 0;
    }

    char start_message[100] = Welcome "\n\0";
    char data[80] = BuildData "\n" BuildDataVerbose "\0";

    disable_cursor();

    puts(start_message, 0x03, video_memory, 0, 0);

    puts(data, 0x03, video_memory, 0, 2);
}

__asm__(".space 2048-(.-_start)");
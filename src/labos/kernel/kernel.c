__asm__(
    "call main\n"
);

#define video_memory_start 0xb8000

void main(void)
{
    char* video_memory = (char*) video_memory_start;
    char message[] = "Welcome to LabOS!\0";

    int c = 0;
    int va = 800 * 2;

    while (message[c] != '\0')
    {
        video_memory[va] = message[c];
        video_memory[va + 1] = 0x02;

        va += 2;
        c++;
    }

    while(1){}
}
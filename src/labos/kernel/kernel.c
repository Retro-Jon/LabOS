// __asm__(".code32\n");
// __asm__("jmpl $0x0000, $_main\n");

void main()
{
    char* video_memory = (char*) 0xb800;
    
    for (int i = 0; i < 80; i += 2)
    {
        video_memory[i] = 'X';
        video_memory[i + 1] = 0x02;
    }

    while(1);
}
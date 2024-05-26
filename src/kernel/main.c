void _main() {
    *(char*)0xB8000 = 'Z';
    *(char*)0xB8001 = 0x0A;

    for (;;);
}
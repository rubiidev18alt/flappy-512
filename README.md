# flappy-512

Flappy Bird in a boot sector. The game is 506 bytes, plus the 2 bytes the BIOS needs, so there are 4 left over.

Made it for a video on my channel: https://www.youtube.com/@CodingWalaXD

## run

```
nasm -f bin flappy.asm -o flappy.img
qemu-system-i386 -drive format=raw,file=flappy.img
```

or just boot the `flappy.img` that's already here. space to flap.

`stages/` has the game at each step, starting from the first 322 byte version. `bug.asm` is the one that showed a score of 153 before I pressed anything, `slow.asm` runs on the default 18.2 Hz timer.

`palette.asm` draws all 256 default colours, that's how I picked mine.

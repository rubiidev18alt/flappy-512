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

## Score renderer experiment

The `score-outline-experiment` branch contains a small score-loop reordering experiment. It moves cursor positioning until after digit conversion and sets the teletype attribute once before printing the digits. This is intended as an experiment only; because this environment could not install NASM or QEMU, the candidate has not been assembled or boot-tested and must not be considered byte-saving or verified yet.

A separate static concept image illustrates the desired transparent score with a one-pixel black outline. It is not a screenshot from the game or from QEMU.

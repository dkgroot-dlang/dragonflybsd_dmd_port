# DMD Port for DragonFlyBSD

## Requirements:
 - gmake
 - clang50++ or gcc6++

## Uses 2 compile stages

Stage 1: only depends on a c++ compile (gnu c++ or clang++) and gmake
- generate bootstrap dmd compiler (dragonflybsd patched version of dmd v2.067.1)
- generate druntime (dragonflybsd patched version of dmd-cxx)
- generate phobos (dragonflybsd patched version of dmd-cxx)

Stage 2: depends on the dmd compiler created during stage 1, c++ (gnu c++ or clang++) and gmake
- generate dmd compiler (dragonflybsd patched version of dmd master)
- generate druntime (dragonflybsd patched version of master)
- generate phobos (dragonflybsd patched version of master)

## Instructions

```
git clone https://github.com/dkgroot/dragonflybsd_dmd_port.git
cd dragonflybsd_dmd_port
./compile.sh
```

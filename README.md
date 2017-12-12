# DMD Port for DragonFlyBSD

## Requirements:
 - gmake
 - clang50++ or gcc6++

## Uses 2 compile stages

Stage 1: only depends on a c++ compile (gnu c++ or clang++) and gmake
- generate bootstrap dmd compiler ([dragonflybsd patched version of dmd v2.067.1](https://github.com/dkgroot/dmd/tree/dragonflybsd_v2.067.1))

  This version does not require a dmd compile and can be compiled using just a g++ compiler
- generate druntime ([dragonflybsd patched version of dmd-cxx](https://github.com/dkgroot/druntime/tree/dmd-cxx))
- generate phobos ([dragonflybsd patched version of dmd-cxx](https://github.com/dkgroot/phobos/tree/dmd-cxx))

Stage 2: depends on the dmd compiler created during stage 1, c++ (gnu c++ or clang++) and gmake
- generate dmd compiler ([dragonflybsd patched version of dmd master](https://github.com/dkgroot/dmd/tree/master))
- generate druntime ([dragonflybsd patched version of master](https://github.com/dkgroot/druntime/tree/master))
- generate phobos ([dragonflybsd patched version of master](https://github.com/dkgroot/phobos/tree/master))

## Instructions

```
git clone https://github.com/dkgroot/dragonflybsd_dmd_port.git
cd dragonflybsd_dmd_port
./compile.sh
```

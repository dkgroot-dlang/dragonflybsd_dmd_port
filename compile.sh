#!/usr/bin/env bash
export DMD_BASEDIR=`pwd`
export NCPU=${NCPU:-2}
export OS=${OS:-dragonflybsd}
export MODEL=${MODEL:-64}
export MAKE=gmake

bootstrap() {
    cd ${DMD_BASEDIR}
    CURSTAGE=bootstrap

    echo "Running ${CURSTAGE} Compilation (NCPU:$NCPU / OS:$OS / MODEL:$MODEL)..."
    [ ! -d ${CURSTAGE} ] && mkdir ${CURSTAGE}
    pushd ${CURSTAGE}
            #if [ ! -d dmd ]; then
            #         git clone -b v2.067.1 git@github.com:dkgroot/dmd.git
            #         cd dmd
            #         git apply --reject ${DMD_BASEDIR}/patches/v2.067.1.patch
            #         mkdir -p ini/dragonflybsd/bin64
            #         cp ini/freebsd/bin64/dmd.conf ini/dragonflybsd/bin64/
            #         cd ..
            #fi
            [ ! -d dmd ] && git clone -b dragonflybsd_v2.067.1 git@github.com:dkgroot/dmd.git
            [ ! -d druntime ] && git clone -b dmd-cxx git@github.com:dkgroot/druntime.git
            [ ! -d phobos ] && git clone -b dmd-cxx git@github.com:dkgroot/phobos.git
            pushd dmd
                    $MAKE -f posix.mak MODEL=${MODEL} HOST_CSS=g++ -j${NCPU} $*
            popd
            for dir in druntime phobos; do
                    pushd ${dir}
                            echo "-----------------------------------------------------------------------------------------------------"
                            echo "running: $MAKE -f posix.mak MODEL=${MODEL} HOST_CSS=g++ $*"
                            echo "-----------------------------------------------------------------------------------------------------"
                            $MAKE -f posix.mak MODEL=${MODEL} HOST_CSS=g++ HOST_$*
                    popd
            done
    popd
}

master() {
    cd ${DMD_BASEDIR}
    CURSTAGE=master

    echo "Running ${CURSTAGE} Compilation (NCPU:$NCPU / OS:$OS / MODEL:$MODEL)..."
    [ ! -d ${CURSTAGE} ] && mkdir ${CURSTAGE}
    pushd ${CURSTAGE}
            [ ! -d dmd ] && git clone -b ${CURSTAGE} git@github.com:dkgroot/dmd.git
            [ ! -d druntime ] && git clone -b ${CURSTAGE} git@github.com:dkgroot/druntime.git
            [ ! -d phobos ] && git clone -b ${CURSTAGE} git@github.com:dkgroot/phobos.git
            export HOST_DMD=${DMD_BASEDIR}/bootstrap/install/${OS}/bin${MODEL}/dmd
            pushd dmd
                    echo "-----------------------------------------------------------------------------------------------------"
                    echo "running: $MAKE -f posix.mak MODEL=${MODEL} HOST_CSS=g++ -j${NCPU} HOST_DMD=${HOST_DMD} $*"
                    echo "-----------------------------------------------------------------------------------------------------"
                    $MAKE -f posix.mak MODEL=${MODEL} HOST_CSS=g++ -j${NCPU} HOST_DMD=${HOST_DMD} $*
            popd
            for dir in druntime phobos; do
                    pushd ${dir}
                            echo "-----------------------------------------------------------------------------------------------------"
                            echo "running: $MAKE -f posix.mak MODEL=${MODEL} HOST_CSS=g++ HOST_DMD=${HOST_DMD} $*"
                            echo "-----------------------------------------------------------------------------------------------------"
                            $MAKE -f posix.mak MODEL=${MODEL} HOST_CSS=g++ HOST_DMD=${HOST_DMD} $*
                    popd
            done
    popd
}

bootstrap clean
bootstrap DEBUG=1 BUILD=debug ENABLE_DEBUG=1 install
master clean
master BUILD=debug ENABLE_DEBUG=1 ENABLE_UNITTEST=1
master BUILD=debug ENABLE_DEBUG=1 ENABLE_UNITTEST=1 install
master BUILD=debug ENABLE_DEBUG=1 ENABLE_UNITTEST=1 unittest


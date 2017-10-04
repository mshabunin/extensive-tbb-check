#!/bin/bash

set -e

export CCACHE_DIR=/cache
export PATH=/usr/lib/ccache:$PATH

tbb_env() {
    tar -xvf /opt/lib/${1}_lin.tgz
    source ${1}/bin/tbbvars.sh intel64 linux auto_tbbroot
}

run_build() {
    cmake -GNinja \
        -DWITH_TBB=ON \
        -DBUILD_TBB=$1 \
        -DBUILD_SHARED_LIBRARIES=$2 \
        -DCMAKE_INSTALL_PREFIX=install \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
        ../opencv
    ninja
}

run_test() {
    OPENCV_TEST_DATA_PATH=/opencv_extra/testdata \
        ./bin/opencv_test_core --gtest_filter=*Core_DCT.accuracy*
}

( pushd /build && rm -rf * ; run_build ON ON ; run_test ; popd)
( pushd /build && rm -rf * ; run_build ON OFF ; run_test ; popd)

for ver in tbb2017_20170604oss tbb2017_20170412oss tbb2017_20170226oss ; do

    ( pushd /build && rm -rf * ; tbb_env $ver ; run_build OFF ON ; run_test ; popd)
    ( pushd /build && rm -rf * ; tbb_env $ver ; run_build OFF OFF ; run_test ; popd)

done

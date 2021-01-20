#!/bin/bash

set -ex

export CCACHE_DIR=/cache
export PATH=/usr/lib/ccache:$PATH
LOG=/scripts/report.txt

tbb_env() {
    tar -xvf /scripts/${1}.tgz
    envscript=$(find -name ${2} | head -1)
    [ -n "${envscript}" ] && source ${envscript} intel64 linux auto_tbbroot
}

run_build() {
    cmake -GNinja \
        -DWITH_TBB=ON \
        -DBUILD_TBB=$1 \
        -DBUILD_SHARED_LIBRARIES=$2 \
        -DCMAKE_INSTALL_PREFIX=install \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
        ../opencv
    grep "Parallel framework:" version_string.tmp >> $LOG
    ninja 2>> $LOG
}

run_test() {
    OPENCV_TEST_DATA_PATH=/opencv_extra/testdata \
        ./bin/opencv_test_core --gtest_filter=*Core_DCT.accuracy*
}

echo "================================================" >> $LOG
echo "Test started: $(date -R)" >> $LOG
echo "================================================" >> $LOG

echo "|" >> $LOG
echo "| Built-in TBB" >> $LOG
echo "|" >> $LOG
( pushd /build && rm -rf * ; run_build ON ON ; run_test ; popd)
( pushd /build && rm -rf * ; run_build ON OFF ; run_test ; popd)

for ver in tbb-2020.0-lin tbb-2020.1-lin tbb-2020.2-lin tbb-2020.3-lin tbb2019_20191006oss_lin ; do
    echo "|" >> $LOG
    echo "| TBB ENV: $ver" >> $LOG
    echo "|" >> $LOG
    ( pushd /build && rm -rf * ; tbb_env $ver tbbvars.sh ; run_build OFF ON ; run_test ; popd)
    ( pushd /build && rm -rf * ; tbb_env $ver tbbvars.sh ; run_build OFF OFF ; run_test ; popd)
done

for ver in oneapi-tbb-2021.1.1-lin ; do
    echo "|" >> $LOG
    echo "| TBB ENV: $ver" >> $LOG
    echo "|" >> $LOG
    ( pushd /build && rm -rf * ; tbb_env $ver vars.sh ; run_build OFF ON ; run_test ; popd)
    ( pushd /build && rm -rf * ; tbb_env $ver vars.sh ; run_build OFF OFF ; run_test ; popd)
done

Build OpenCV with different variants of TBB library.


Features:
- build dynamic and static version of OpenCV
- use TBB provided by OpenCV (downloaded during configuration) and standalone packages
- run a test

Assumptions:
- directory structure as follows:
```
├── build
├── container  <--- this repository is here
├── opencv
├── opencv_contrib
├── opencv_extra
```
- uses 3 hardcoded TBB library versions, archives should be put in $HOME/Libs folder
- uses Docker

Instruction:
- create and run the container: `./do.sh`
- inside the container run all builds: `./scripts/build.sh`

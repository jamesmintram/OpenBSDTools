#!/bin/ksh
export FSSIZE=67584
export MSDOSSTART=32768
export MSDOSSIZE=8192
export FFSSTART=40960

# set -x

mkdir -p ./build
mkdir -p ./build/mnt

# Prep disk + fs
echo "------------"
echo "Prep disk + fs"
echo "------------"

dd if=/dev/zero of=./build/bsd.img bs=512 count=${FSSIZE}
vnconfig -v -t miniroot ./build/bsd.img > vnd # doas

echo "----"
echo 'u\ne 0\nc\nn\n32768\n8192\ne 3\nA6\nn\n40960\n*\nf 0\nw\nq\nw\n' | fdisk -e `cat vnd` 
echo "\n----"
echo 'a a\n\n\n\nw\nq\n' | disklabel -E `cat vnd` 

echo "----"
newfs -t msdos -L boot -c1 -F16 /dev/r`cat vnd`i
echo "----"
newfs -O 1 -m 0 -o space -i 524288 -c 67584 /dev/r`cat vnd`a

mount /dev/`cat vnd`a ./build/mnt # doas

# Copy our artifacts
echo "------------"
echo "Copy artifacts"
echo "------------"

cp ../sys/arch/arm64/compile/GENERIC.MP/obj/bsd ./build/mnt

# Cleanup
echo "------------"
echo "Cleanup"
echo "------------"

umount ./build/mnt # doas
vnconfig -u `cat vnd`
rm -f vnd

echo "------------"
echo "Success"
echo "------------"
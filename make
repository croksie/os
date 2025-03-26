sudo apt update && sudo apt install -y build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo
mkdir ~/cross-compiler && cd ~/cross-compiler
wget https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.gz
wget https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.gz
tar -xzf binutils-2.41.tar.gz
tar -xzf gcc-13.2.0.tar.gz
mkdir build-binutils && cd build-binutils
../binutils-2.41/configure --target=i686-elf --prefix=/usr/local/cross --with-sysroot --disable-nls --disable-werror
make -j$(nproc)
sudo make install
cd ..
mkdir build-gcc && cd build-gcc
../gcc-13.2.0/configure --target=i686-elf --prefix=/usr/local/cross --disable-nls --enable-languages=c,c++ --without-headers
make -j$(nproc) all-gcc all-target-libgcc
sudo make install

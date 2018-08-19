#!/bin/bash
HOMEDIR=~

# Updates
sudo apt-get -y update

sudo apt-get -y install python3-pip
sudo apt-get -y install tmux
sudo apt-get -y install gdb gdb-multiarch
sudo apt-get -y install gcc-multilib
sudo apt-get -y install clang llvm
sudo apt-get -y install unzip
sudo apt-get -y install foremost
sudo apt-get -y install ipython
sudo apt-get -y install silversearcher-ag
sudo apt-get -y install zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install 32 bit libs
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386
sudo apt-get -y install libc6-dev-i386
sudo apt-get -y install libc6-dbg # necessary for pwndbg's heap functionality 
sudo apt-get -y install libc6-dbg:i386 #necessary for pwndbg's heap functionality 
sudo apt-get -y install valgrind #useful when using vgdb ;)
sudo apt-get -y install gcc-arm-linux-gnueabihf # for the arm toolchain 
# Enable ptracing
sudo sed -i 's/kernel.yama.ptrace_scope = 1/kernel.yama.ptrace_scope = 0/g' /etc/sysctl.d/10-ptrace.conf
sudo sysctl --system

# Fix urllib3 InsecurePlatformWarning
sudo -H pip install --upgrade urllib3[secure]

# Fix warning when loading .gdbinit files
echo 'set auto-load safe-path /' > ~/.gdbinit

 #Install PwnTools
sudo apt-get -y install python2.7 python-pip python-dev git libssl-dev libffi-dev build-essential
sudo -H pip install --upgrade pip
sudo -H pip install --upgrade git+https://github.com/Gallopsled/pwntools

#install some useful system tools
sudo apt-get -y install htop
sudo apt-get -y install lynx
sudo apt-get -y install socat
sudo apt-get -y install p7zip
sudo apt-get -y install mc

cd ~
mkdir tools
cd tools

# Install binwalk
cd ~/tools
git clone https://github.com/devttys0/binwalk
cd binwalk
sudo python setup.py install
sudo apt-get -y install squashfs-tools

# Install Keystone engine with debug option
cd ~/tools
sudo apt-get -y install cmake
git clone https://github.com/keystone-engine/keystone.git
cd keystone
mkdir build
cd build
../make-share.sh debug
sudo make install
cd ../bindings/python/
sudo python setup.py install
sudo ldconfig

#install qira timeless debugger
cd ~/tools 
wget -q https://github.com/BinaryAnalysisPlatform/qira/archive/v1.2.tar.gz
tar zxvf v1.2.tar.gz 
rm v1.2.tar.gz 
cd qira-1.2 
./install.sh

#install xrop
cd ~/tools
git clone --depth 1 https://github.com/acama/xrop.git
cd xrop
git submodule update --init --recursive
sudo make install


# Install american-fuzzy-lop
cd ~/tools
wget --quiet http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
tar -xzvf afl-latest.tgz
rm afl-latest.tgz
wget --quiet http://llvm.org/releases/3.8.0/clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz
xz -d clang*
tar xvf clang*
cd clang*
cd bin
export PATH=$PWD:$PATH
cd ../..
(
  cd afl-*
  make
  # build clang-fast
  (
    cd llvm_mode
    make
  )
  sudo make install

  # build qemu-support
  sudo apt-get -y install libtool automake bison libglib2.0-dev
  ./build_qemu_support.sh
)


# Install ROPGadget
cd ~/tools
git clone https://github.com/JonathanSalwan/ROPgadget
cd ROPgadget
sudo python setup.py install

# Install intel PIN
cd ~/tools
wget  --quiet http://software.intel.com/sites/landingpage/pintool/downloads/pin-2.14-71313-gcc.4.4.7-linux.tar.gz
tar -xzvf pin-2.14-71313-gcc.4.4.7-linux.tar.gz
rm pin-2.14-71313-gcc.4.4.7-linux.tar.gz
cd pin*
export PIN_ROOT=$PWD
export PATH=$PATH:$PIN_ROOT;

#Install angr 
sudo -H pip install angr 

#Install ropper 
sudo -H pip install ropper 

#install golang
sudo apt-get -y install golang 

# Personal config
sudo apt-get -y install stow
cd ~
rm .bashrc
git clone --recursive https://github.com/heartbleeded/dotfiles
cd dotfiles
chmod a+x ./install.sh
./install.sh

#install rp++
cd ~/tools
wget -q https://github.com/downloads/0vercl0k/rp/rp-lin-x64
    sudo install -s rp-lin-x64 /usr/bin/rp++
rm rp-lin-x64

#install untimate vim
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

#setup vim
cd /home/vagrant/.vim_runtime/sources_non_forked
git clone https://github.com/vim-scripts/AutoComplPop
rm /home/vagrant/.vim_runtime/sources_non_forked/vim-snippets/snippets/python.snippets
cd /home/vagrant/.vim_runtime/sources_non_forked/vim-snippets/snippets
wget https://raw.githubusercontent.com/l0kihardt/vimrc/master/snippets/python.snippets

#remove not useful plugin
rm -rf /home/vagrant/.vim_runtime/sources_non_forked/comfortable-motion.vim/

# remember to do this after install
#:set ts=4
#:set noexpandtab
#:%retab!

#install pwngdb
cd ~/
git clone https://github.com/longld/peda
git clone https://github.com/scwuaptx/Pwngdb.git 
cp ~/Pwngdb/.gdbinit ~/

# Fix locales after installing everything
sudo locale-gen en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo dpkg-reconfigure locales

export LLVM_VERSION=3.7
export SOLVERS=STP:Z3
export STP_VERSION=2.1.2
export DISABLE_ASSERTIONS=0
export ENABLE_OPTIMIZED=1
export KLEE_UCLIBC=klee_uclibc_v1.0.0
export KLEE_SRC=/home/vagrant/klee_src
export COVERAGE=0
export BUILD_DIR=/home/vagrant/klee_build
export ASAN_BUILD=0
export UBSAN_BUILD=0
export TRAVIS_OS_NAME=linux
sudo apt-get update
sudo apt-get -y --no-install-recommends install clang-${LLVM_VERSION} llvm-${LLVM_VERSION} llvm-${LLVM_VERSION}-dev llvm-${LLVM_VERSION}-runtime llvm libcap-dev git subversion cmake make libboost-program-options-dev python3 python3-dev python3-pip perl flex bison libncurses-dev zlib1g-dev patch wget unzip binutils libedit-dev
sudo pip3 install -U lit tabulate wllvm
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 50
( wget -O - http://download.opensuse.org/repositories/home:delcypher:z3/xUbuntu_14.04/Release.key | sudo apt-key add - )
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/delcypher:/z3/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/z3.list"
sudo apt-get update
cd ~
git clone https://github.com/klee/klee ${KLEE_SRC}
cd ${KLEE_SRC}
git checkout 9cace3f305561da4a635d753b5c35f268dd22b2e
cd ~
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
${KLEE_SRC}/.travis/solvers.sh
cd ${BUILD_DIR} && mkdir test-utils && cd test-utils
${KLEE_SRC}/.travis/testing-utils.sh
sudo ln -s /usr/bin/clang /usr/bin/clang-${LLVM_VERSION}
sudo ln -s /usr/bin/clang++ /usr/bin/clang++-${LLVM_VERSION}
sudo ln -s /usr/bin/llvm-config /usr/bin/llvm-config-${LLVM_VERSION}
cd ${BUILD_DIR}
${KLEE_SRC}/.travis/klee.sh
echo 'export PATH=$PATH:'${BUILD_DIR}'/klee/bin' >> /home/vagrant/.bashrc
for executable in ${BUILD_DIR}/klee/bin/* ; do sudo ln -s ${executable} /usr/bin/`basename ${executable}`; done

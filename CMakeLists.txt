cmake_minimum_required(VERSION 3.15)
project(tcp_tx C)

set(CMAKE_C_STANDARD 11)


include_directories(/home/ziyan/song/Dropbox/dpdk/x86_64-native-linuxapp-gcc/include/)
LINK_DIRECTORIES(/home/ziyan/song/Dropbox/dpdk/x86_64-native-linuxapp-gcc/include/)


include_directories(/home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/)
LINK_DIRECTORIES(/home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/)
add_executable(tcp_tx tcp_tx.c
        /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/tcp.c
        /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/dpdk_utility.c
        )
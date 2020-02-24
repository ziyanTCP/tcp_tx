# SPDX-License-Identifier: BSD-3-Clause
# Copyright(c) 2010-2014 Intel Corporation

# binary name
APP = tcp_tx

# all source are stored in SRCS-y
SRCS-y := tcp_tx.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/tcp.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/tcp_action.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/ip.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/mac.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/dpdk_init.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/dpdk_utility.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/tcp_stream.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/tcp_in.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/tcp_out.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/hashtable.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/init.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/socket.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/dpdk_module.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/tcp_ring_buffer.c
SRCS-y := $(SRCS-y) /home/ziyan/Dropbox/mylibrary/dpdk_tools/lib/tcp/tcp_rb_frag_queue.c


# Build using pkg-config variables if possible
$(shell pkg-config --exists libdpdk)
ifeq ($(.SHELLSTATUS),0)

all: shared
.PHONY: shared static
shared: build/$(APP)-shared
	ln -sf $(APP)-shared build/$(APP)
static: build/$(APP)-static
	ln -sf $(APP)-static build/$(APP)

PC_FILE := $(shell pkg-config --path libdpdk)
CFLAGS += -O0 $(shell pkg-config --cflags libdpdk)
LDFLAGS_SHARED = $(shell pkg-config --libs libdpdk)
LDFLAGS_STATIC = -Wl,-Bstatic $(shell pkg-config --static --libs libdpdk)

build/$(APP)-shared: $(SRCS-y) Makefile $(PC_FILE) | build
	$(CC) $(CFLAGS) $(SRCS-y) -o $@ $(LDFLAGS) $(LDFLAGS_SHARED)

build/$(APP)-static: $(SRCS-y) Makefile $(PC_FILE) | build
	$(CC) $(CFLAGS) $(SRCS-y) -o $@ $(LDFLAGS) $(LDFLAGS_STATIC)

build:
	@mkdir -p $@

.PHONY: clean
clean:
	rm -f build/$(APP) build/$(APP)-static build/$(APP)-shared
	rmdir --ignore-fail-on-non-empty build

else

ifeq ($(RTE_SDK),)
$(error "Please define RTE_SDK environment variable")
endif

# Default target, can be overridden by command line or environment
RTE_TARGET ?= x86_64-native-linuxapp-gcc

include $(RTE_SDK)/mk/rte.vars.mk

CFLAGS += -O0
#CFLAGS += $(WERROR_FLAGS)

include $(RTE_SDK)/mk/rte.extapp.mk

endif
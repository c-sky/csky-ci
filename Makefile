ROOTDIR  = $(shell pwd)

include $(ROOTDIR)/config
include $(sort $(wildcard benchmark/*/*.mk))

RUN_TEST_MID = run_test.mid.gdb

ifeq ($(CONFIG_QEMU),y)
ifeq ($(CONFIG_CPU_CK610),y)
RUN_TEST_MID = run_test.mid.qemuv1
endif
ifeq ($(CONFIG_CPU_CK807),y)
RUN_TEST_MID = run_test.mid.qemuv2
endif
ifeq ($(CONFIG_CPU_CK810),y)
RUN_TEST_MID = run_test.mid.qemuv2
endif
ifeq ($(CONFIG_CPU_CK860),y)
RUN_TEST_MID = run_test.mid.qemuv2_smp
endif
endif

ifeq ($(CONFIG_FPGA),y)
RUN_TEST_MID = run_test.mid.fpga
endif

OBJ = $(patsubst %.c,%,$(wildcard generic/*.c))

all: mkheader mktail $(OBJ)
.PHONY: all

mkheader:
	@mkdir -p $(ROOTDIR)/out
	@mkdir -p $(ROOTDIR)/out/sh
	@mkdir -p $(ROOTDIR)/out/configs
	@cp generic/S90test $(ROOTDIR)/out/S90test
	@cp generic/run_test.header $(ROOTDIR)/out/sh/run_test.sh
	@cat generic/$(RUN_TEST_MID) >> $(ROOTDIR)/out/sh/run_test.sh
	@sed -i "s/NEW_S2C_BIT_NAME/$(CONFIG_FPGA_BITFILE)/" $(ROOTDIR)/out/sh/run_test.sh
	@sed -i "s/NEW_S2C_ELF_NAME/$(CONFIG_FPGA_DDRINIT)/" $(ROOTDIR)/out/sh/run_test.sh

mktail:
	@cp generic/generic_analyze.sh $(ROOTDIR)/out/sh/
	@chmod 755 ./out/sh/*.sh
	@chmod 755 ./out/S90test
	@cp generic/test.sh ./out/test.sh
	@chmod 755 ./out/test.sh

$(OBJ): %: %.c
	@mkdir -p $(ROOTDIR)/out
	@gcc -o $@ $^ -Wall
	@mv $@ $(ROOTDIR)/out

clean:
	@rm ./out -rf

ROOTDIR  = $(shell pwd)

include $(ROOTDIR)/config
include $(sort $(wildcard benchmark/*/*.mk))

OBJ = $(patsubst %.c,%,$(wildcard generic/*.c))

all: mkscript $(OBJ)
.PHONY: all

mkscript:
	@mkdir -p $(ROOTDIR)/out
	@mkdir -p $(ROOTDIR)/out/sh
	@mkdir -p $(ROOTDIR)/out/configs
	@cp generic/S90test $(ROOTDIR)/out/S90test
	@cp generic/run_test.qemuv1 $(ROOTDIR)/out/sh/run_test_qemuv1.sh
	@cp generic/run_test.qemuv2 $(ROOTDIR)/out/sh/run_test_qemuv2.sh
	@cp generic/run_test.qemuv2_smp $(ROOTDIR)/out/sh/run_test_qemuv2_smp.sh
	@cp generic/run_test.qemu_riscv64 $(ROOTDIR)/out/sh/run_test_qemu_riscv64.sh
	@cp generic/run_test.fpga $(ROOTDIR)/out/sh/run_test_fpga.sh
	@cp generic/run_test.chip $(ROOTDIR)/out/sh/run_test_chip.sh
	@sed -i "s/NEW_S2C_BIT_NAME/$(CONFIG_FPGA_BITFILE)/" $(ROOTDIR)/out/sh/run_test_fpga.sh
	@cp generic/generic_analyze.sh $(ROOTDIR)/out/sh/
	@cp generic/check_ssh_bg.sh $(ROOTDIR)/out/sh/
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

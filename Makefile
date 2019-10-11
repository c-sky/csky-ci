ROOTDIR  = $(shell pwd)

include $(ROOTDIR)/config
include $(sort $(wildcard benchmark/*/*.mk))

OBJ = $(patsubst %.c,%,$(wildcard generic/*.c))

all: mkheader mktail $(OBJ)
.PHONY: all

mkheader:
	@mkdir -p $(ROOTDIR)/out
	@mkdir -p $(ROOTDIR)/out/sh
	@mkdir -p $(ROOTDIR)/out/configs
	@cp generic/S90test $(ROOTDIR)/out/S90test
	@cp generic/run_test.header $(ROOTDIR)/out/sh/run_test_qemuv1.sh
	@cp generic/run_test.header $(ROOTDIR)/out/sh/run_test_qemuv2.sh
	@cp generic/run_test.header $(ROOTDIR)/out/sh/run_test_qemuv2_smp.sh
	@cp generic/run_test.header $(ROOTDIR)/out/sh/run_test_qemu_riscv64.sh
	@cp generic/run_test.header $(ROOTDIR)/out/sh/run_test_fpga.sh
	@cp generic/run_test.header $(ROOTDIR)/out/sh/run_test_chip.sh
	@cat generic/run_test.mid.qemuv1 >> $(ROOTDIR)/out/sh/run_test_qemuv1.sh
	@cat generic/run_test.mid.qemuv2 >> $(ROOTDIR)/out/sh/run_test_qemuv2.sh
	@cat generic/run_test.mid.qemuv2_smp >> $(ROOTDIR)/out/sh/run_test_qemuv2_smp.sh
	@cat generic/run_test.mid.qemu_riscv64 >> $(ROOTDIR)/out/sh/run_test_qemu_riscv64.sh
	@cat generic/run_test.mid.fpga >> $(ROOTDIR)/out/sh/run_test_fpga.sh
	@cat generic/run_test.mid.chip >> $(ROOTDIR)/out/sh/run_test_chip.sh
	@sed -i "s/NEW_S2C_BIT_NAME/$(CONFIG_FPGA_BITFILE)/" $(ROOTDIR)/out/sh/run_test_fpga.sh
	@sed -i "s/NEW_S2C_ELF_NAME/$(CONFIG_FPGA_DDRINIT)/" $(ROOTDIR)/out/sh/run_test_fpga.sh

mktail:
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

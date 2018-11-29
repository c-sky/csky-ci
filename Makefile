ROOTDIR  = $(shell pwd)
BENCHMARK = $(shell echo $(notdir $(sort $(wildcard benchmark/*))) | tr '[a-z]' '[A-Z]')

include $(ROOTDIR)/config
include $(sort $(wildcard benchmark/*/*.mk))

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
else
ifeq ($(CONFIG_FPGA),y)
RUN_TEST_MID = run_test.mid.fpga
else
RUN_TEST_MID = run_test.mid.gdb
endif
endif

OBJ = $(patsubst %.c,%,$(wildcard generic/*.c))

all: mkheader $(BENCHMARK) mktail $(OBJ)
.PHONY: all

mkheader:
	@mkdir -p $(ROOTDIR)/out
	@mkdir -p $(ROOTDIR)/out/sh
	@mkdir -p $(ROOTDIR)/out/configs
	@cp generic/S90test $(ROOTDIR)/out/S90test
	@cp generic/test.header $(ROOTDIR)/out/test.sh
	@cp generic/run_test.header $(ROOTDIR)/out/sh/run_test.sh
	@cat generic/$(RUN_TEST_MID) >> $(ROOTDIR)/out/sh/run_test.sh
	@sed -i "s/NEW_S2C_BIT_NAME/$(CONFIG_FPGA_BITFILE)/" $(ROOTDIR)/out/sh/run_test.sh

$(BENCHMARK):
	@if [ $($@_RUN_TEST) ]; then\
         echo "echo \"============== $(shell echo $@ | tr '[A-Z]' '[a-z]') log start ===============\"" >> $(ROOTDIR)/out/test.sh;\
         cat benchmark/$(shell echo $@ | tr '[A-Z]' '[a-z]')/$($@_RUN_TEST) >> $(ROOTDIR)/out/test.sh;\
         echo "echo \"============== $(shell echo $@ | tr '[A-Z]' '[a-z]') log end ===============\"" >> $(ROOTDIR)/out/test.sh;\
        fi
	@if [ $($@_PARSE_RESULT) ]; then\
           cp benchmark/$(shell echo $@ | tr '[A-Z]' '[a-z]')/$($@_PARSE_RESULT) $(ROOTDIR)/out/sh/$(shell echo $@ | tr '[A-Z]' '[a-z]')_parse.sh;\
         fi
	@$($@_CP_CONFIGS)

mktail:
	@cat generic/test.tail >> $(ROOTDIR)/out/test.sh
	@cp generic/generic_analyze.sh $(ROOTDIR)/out/sh/
	@chmod 755 ./out/sh/*.sh
	@chmod 755 ./out/S90test
	@chmod 755 ./out/test.sh

$(OBJ): %: %.c
	@mkdir -p $(ROOTDIR)/out
	@gcc -o $@ $^ -Wall
	@mv $@ $(ROOTDIR)/out

clean:
	@rm ./out -rf

ROOTDIR  = $(shell pwd)
BENCHMARK = $(shell echo $(notdir $(sort $(wildcard benchmark/*))) | tr '[a-z]' '[A-Z]')

include $(ROOTDIR)/config
include $(sort $(wildcard benchmark/*/*.mk))

ifeq ($(CONFIG_QEMU),y)
ifeq ($(CONFIG_CPU_CK610),y)
RUN_TEST_MID = run_test.mid.qemuv1
else
RUN_TEST_MID = run_test.mid.qemuv2
endif
else
RUN_TEST_MID = run_test.mid.gdb
endif

all     : mkheader $(BENCHMARK) mktail 
.PHONY: all

mkheader :
	@mkdir -p $(ROOTDIR)/out
	@mkdir -p $(ROOTDIR)/out/sh
	@mkdir -p $(ROOTDIR)/out/configs
	@cp genertic/S90test.header $(ROOTDIR)/out/S90test
	@cp genertic/run_test.header $(ROOTDIR)/out/sh/run_test.sh
	@cat genertic/$(RUN_TEST_MID) >> $(ROOTDIR)/out/sh/run_test.sh
	@cp genertic/gen_rtb ./out/sh/gen_rtb.sh

$(BENCHMARK) :
	@if [ $($@_RUN_TEST) ]; then\
         echo "        echo \"============== $(shell echo $@ | tr '[A-Z]' '[a-z]') log start ===============\"" >> $(ROOTDIR)/out/S90test;\
         cat benchmark/$(shell echo $@ | tr '[A-Z]' '[a-z]')/$($@_RUN_TEST) >> $(ROOTDIR)/out/S90test;\
         echo "        echo \"============== $(shell echo $@ | tr '[A-Z]' '[a-z]') log end ===============\"" >> $(ROOTDIR)/out/S90test; >> $(ROOTDIR)/out/S90test;\
        fi
	@if [ $($@_ECHO_SUM) ]; then\
         echo "        echo \"============== $(shell echo $@ | tr '[A-Z]' '[a-z]') sum start ===============\"" >> $(ROOTDIR)/out/S90test;\
         cat benchmark/$(shell echo $@ | tr '[A-Z]' '[a-z]')/$($@_ECHO_SUM) >> $(ROOTDIR)/out/S90test;\
         echo "        echo \"============== $(shell echo $@ | tr '[A-Z]' '[a-z]') sum end ===============\"" >> $(ROOTDIR)/out/S90test; >> $(ROOTDIR)/out/S90test;\
        fi
	@if [ $($@_PARSE_RESULT) ]; then\
           cp benchmark/$(shell echo $@ | tr '[A-Z]' '[a-z]')/$($@_PARSE_RESULT) $(ROOTDIR)/out/sh/$(shell echo $@ | tr '[A-Z]' '[a-z]')_parse.sh;\
         fi
	@$($@_CP_CONFIGS)

mktail :
	@cat genertic/S90test.tail >> $(ROOTDIR)/out/S90test
	@cat genertic/run_test.tail >> $(ROOTDIR)/out/sh/run_test.sh
	@chmod 755 ./out/sh/*.sh
	@chmod 755 ./out/S90test

clean :
	@rm ./out -rf

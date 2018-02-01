ROOTDIR  = $(shell pwd)

include ./config

ifeq ($(CONFIG_QEMU),y)
ifeq ($(CONFIG_CPU),ck610)
RUN_TEST_MID = run_test.mid.qemuv1
else
RUN_TEST_MID = run_test.mid.qemuv2
endif
MAKE_NFS =
CHECK_DONE =
CHECK_STAMP =
else
MAKE_NFS = echo "rm -rf /home/vmh/nfs/$(CONFIG_NFS)/*" >> ./out/sh/run_test.sh;\
           echo tar -xf "$$"OUT_PATH/images/rootfs.tar -C /home/vmh/nfs/$(CONFIG_NFS)/ >> ./out/sh/run_test.sh
CHECK_STAMP = echo touch /home/vmh/nfs/$(CONFIG_NFS)/usr/lib/csky-test/.stamp_test_done >> ./out/sh/run_test.sh
RUN_TEST_MID = run_test.mid.gdb
CHECK_DONE = echo "while [ ! -f \"/home/vmh/nfs/$(CONFIG_NFS)/usr/lib/csky-test/.stamp_test_done\" ]" > ./out/sh/check_done.sh
endif

ifeq ($(CONFIG_LTP),y) 
MK_SCRIPT_LTP = cat src/run_ltp >> ./out/S90test
ifeq ($(CONFIG_LIBC),glibc)
LTP_SCRIPT_LIST = cp src/ltp-glibc-skiplist ./out/configs/ltp-skiplist
else
LTP_SCRIPT_LIST = cp src/ltp-uclibc-skiplist ./out/configs/ltp-skiplist
endif
else
MK_SCRIPT_LTP = 
LTP_SCRIPT_LIST =
endif

ifeq ($(CONFIG_LMBENCH),y)
MK_SCRIPT_LMBENCH = cat src/run_lmbench >> ./out/S90test;\
                    cp src/CONFIG.lmbench ./out/configs/;\
                    sed -i 's/OUTPUT=/OUTPUT=\/dev\/$(CONFIG_TTY)/g' ./out/configs/CONFIG.lmbench
else
MK_SCRIPT_LMBENCH =
endif

ifeq ($(CONFIG_DHRYSTONE),y)
MK_SCRIPT_DHRYSTONE = cat src/run_dhrystone >> ./out/S90test
else
MK_SCRIPT_DHRYSTONE =
endif

ifeq ($(CONFIG_WHETSTONE),y)
MK_SCRIPT_WHETSTONE = cat src/run_whetstone >> ./out/S90test
else
MK_SCRIPT_WHETSTONE =
endif

all     : mkscript
.PHONY: all

mkscript :
	@mkdir -p ./out
	@mkdir -p ./out/sh
	@mkdir -p ./out/configs
	@cp src/run_test.header ./out/sh/run_test.sh
	@$(MAKE_NFS)
	@cat src/$(RUN_TEST_MID) >> ./out/sh/run_test.sh
	@$(CHECK_STAMP)
	@cat src/run_test.tail >> ./out/sh/run_test.sh
	@$(CHECK_DONE)
	@cat src/check_done >> ./out/sh/check_done.sh
	@cp src/S90test.header ./out/S90test
	@$(MK_SCRIPT_LTP)
	$(MK_SCRIPT_LMBENCH)
	@$(MK_SCRIPT_DHRYSTONE)
	@$(MK_SCRIPT_WHETSTONE)
	@$(LTP_SCRIPT_LIST)
	@cat src/S90test.tail >> ./out/S90test
	@gcc src/com_tool.c -o ./out/sh/com_tool -O2
	@chmod 755 ./out/sh/run_test.sh
	@chmod 755 ./out/sh/check_done.sh
	@chmod 755 ./out/S90test

clean :
	@rm ./out -rf

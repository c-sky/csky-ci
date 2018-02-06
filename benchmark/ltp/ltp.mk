LTP_RUN_TEST=ltp_run_test
LTP_ECHO_SUM=ltp_echo_sum
LTP_PARSE_RESULT=ltp_parse_result

ifeq ($(CONFIG_GLIBC), y) 
define LTP_CP_CONFIGS
    cp benchmark/ltp/ltp-glibc-skiplist $(ROOTDIR)/out/configs/ltp-skiplist
endef
else
define LTP_CP_CONFIGS
    cp benchmark/ltp/ltp-uclibc-skiplist $(ROOTDIR)/out/configs/ltp-skiplist
endef
endif




LMBENCH_RUN_TEST=lmbench_run_test
LMBENCH_ECHO_SUM=
LMBENCH_PARSE_RESULT=

define LMBENCH_CP_CONFIGS
    cp $(ROOTDIR)/benchmark/lmbench/CONFIG.lmbench $(ROOTDIR)/out/configs/;
    sed -i 's/OUTPUT=/OUTPUT=\/dev\/$(CONFIG_TTY)/g' $(ROOTDIR)/out/configs/CONFIG.lmbench
endef


LMBENCH_RUN_TEST=lmbench_run_test
LMBENCH_PARSE_RESULT=lmbench_parse_result

define LMBENCH_CP_CONFIGS
    cp $(ROOTDIR)/benchmark/lmbench/CONFIG.lmbench $(ROOTDIR)/out/configs/;
    sed -i 's/OUTPUT=/OUTPUT=\/dev\/$(CONFIG_TTY)/g' $(ROOTDIR)/out/configs/CONFIG.lmbench
endef


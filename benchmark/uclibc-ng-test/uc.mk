UCLIBC-NG-TEST_RUN_TEST=uc_run_test
UCLIBC-NG-TEST_PARSE_RESULT=uc_parse_result

define UCLIBC-NG-TEST_CP_CONFIGS
    cp benchmark/uclibc-ng-test/uclibc-ng-test.skiplist \
       $(ROOTDIR)/out/configs/
endef

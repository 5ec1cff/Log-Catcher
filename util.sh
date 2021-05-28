#!/system/bin/sh
check_logpath() {
    if [ -d /cache ]; then
        LOG_PATH=/cache/bootlog
    else
        LOG_PATH=/data/local/bootlog
    fi
}
check_unlock() {
    local TEST_DIR=/sdcard/Android
    while [ ! -d "$TEST_DIR" ]; do
        sleep 3
    done
    local TEST_FILE="$TEST_DIR/.PERMISSION_TEST"
    true >"$TEST_FILE"
    while [ ! -f "$TEST_FILE" ]; do
        true >"$TEST_FILE"
        sleep 3
    done
    rm "$TEST_FILE"
}
check_write() {
    local TEST_DIR=/sdcard/Download
    [ -d $TEST_DIR ] || mkdir -p $TEST_DIR
    local TEST_FILE="$TEST_DIR/.PERMISSION_TEST"
    true >"$TEST_FILE"
    while [ ! -f "$TEST_FILE" ]; do
        true >"$TEST_FILE"
        sleep 3
    done
    rm "$TEST_FILE"
}

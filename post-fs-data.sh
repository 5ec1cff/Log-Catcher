#!/system/bin/sh
MODDIR=${0%/*}

grep_prop() {
    local REGEX="s/^$1=//p"
    shift
    local FILES="$@"
    [ -z "$FILES" ] && FILES='/system/build.prop'
    sed -n "$REGEX" ${FILES} 2>/dev/null | head -n 1
}
MAGISK_VERSION=$(magisk -v)
MAGISK_VER_CODE=$(magisk -V)
android_sdk=$(getprop ro.build.version.sdk)
build_desc=$(getprop ro.build.description)
product=$(getprop ro.build.product)
manufacturer=$(getprop ro.product.manufacturer)
brand=$(getprop ro.product.brand)
MODEL=$(getprop ro.product.model)
fingerprint=$(getprop ro.build.fingerprint)
arch=$(getprop ro.product.cpu.abi)
device=$(getprop ro.product.device)
android=$(getprop ro.build.version.release)
build=$(getprop ro.build.id)
LOGC_VERSION=$(grep_prop version "${MODDIR}/module.prop")
LOGC_VERSIONCODE=$(grep_prop versionCode "${MODDIR}/module.prop")
. $MODDIR/util.sh
check_logpath

if [ -d "$LOG_PATH" ]; then
    if [ ! -d ${LOG_PATH}/old ]; then
        mkdir -p ${LOG_PATH}/old
    fi
    if [ -f ${LOG_PATH}/*.log ]; then
        mv ${LOG_PATH}/*.log "${LOG_PATH}/old"
    fi
else
    mkdir -p $LOG_PATH
fi

LOG_FILE=$LOG_PATH/boot.log
rm -f "${LOG_FILE}"
touch "${LOG_FILE}"
{
    echo "Log Catcher version: ${LOGC_VERSION} (${LOGC_VERSIONCODE})"
    echo "--------- beginning of information"
    echo "Manufacturer: ${manufacturer}"
    echo "Brand: ${brand}"
    echo "Device: ${device}"
    echo "Product: ${product}"
    echo "Model: ${MODEL}"
    echo "Fingerprint: ${fingerprint}"
    echo "ROM build description: ${build_desc}"
    echo "Architecture: ${arch}"
    echo "Android build: ${build}"
    echo "Android version: ${android}"
    echo "Android sdk: ${android_sdk}"
    echo "Magisk: ${MAGISK_VERSION%:*} (${MAGISK_VER_CODE})"
    echo "--------- beginning of dmesg"
    dmesg
    echo "--------- beginning of SELinux"
    getenforce
} >>"${LOG_FILE}"
logcat -b main,system,crash -f "${LOG_FILE}" logcatcher-bootlog:S &
if [ -d "/data/adb/modules/logcat" ]; then
    [ -f /data/adb/modules/logcat/remove ] || touch /data/adb/modules/logcat/remove
fi

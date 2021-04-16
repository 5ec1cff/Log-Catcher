#!/system/bin/sh
MODDIR=${0%/*}
MAGISK_VERSION=$(magisk -v)
MAGISK_VER_CODE=$(magisk -V)
android_sdk=$(getprop ro.build.version.sdk)
build_desc=$(getprop ro.build.description)
product=$(getprop ro.build.product)
manufacturer=$(getprop ro.product.manufacturer)
brand=$(getprop ro.product.brand)
fingerprint=$(getprop ro.build.fingerprint)
arch=$(getprop ro.product.cpu.abi)
device=$(getprop ro.product.device)
android=$(getprop ro.build.version.release)
build=$(getprop ro.build.id)

if [ -d /cache ]; then
    LOG_PATH=/cache/bootlog
else
    LOG_PATH=/data/local/bootlog
fi

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

echo "--------- beginning of head" >>"${LOG_FILE}"
echo "Log Catcher v20" >>"${LOG_FILE}"
echo "--------- beginning of system info" >>"${LOG_FILE}"
echo "Android version: ${android}" >>"${LOG_FILE}"
echo "Android sdk: ${android_sdk}" >>"${LOG_FILE}"
echo "Android build: ${build}" >>"${LOG_FILE}"
echo "Fingerprint: ${fingerprint}" >>"${LOG_FILE}"
echo "ROM build description: ${build_desc}" >>"${LOG_FILE}"
echo "Architecture: ${arch}" >>"${LOG_FILE}"
echo "Device: ${device}" >>"${LOG_FILE}"
echo "Manufacturer: ${manufacturer}" >>"${LOG_FILE}"
echo "Brand: ${brand}" >>"${LOG_FILE}"
echo "Product: ${product}" >>"${LOG_FILE}"
echo "Magisk: ${MAGISK_VERSION%:*} (${MAGISK_VER_CODE})" >>"${LOG_FILE}"
echo "--------- beginning of dmesg" >>"${LOG_FILE}"
dmesg >>"${LOG_FILE}"
echo "--------- beginning of SELinux" >>"${LOG_FILE}"
getenforce >>"${LOG_FILE}"
logcat -b main,system,crash -f "${LOG_FILE}" logcatcher-bootlog:S &

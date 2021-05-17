#!/system/bin/sh
MODDIR=${0%/*}

if [ -d /cache ]; then
  LOG_PATH=/cache/bootlog
else
  LOG_PATH=/data/local/bootlog
fi

while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 3
done
while [ ! -d "/storage/emulated/0/Android" ]; do
  sleep 3
done
test_file="/storage/emulated/0/Download/.PERMISSION_TEST"
touch "$test_file"
while [ ! -f "$test_file" ]; do
  touch "$test_file"
  sleep 3
done
rm "$test_file"
FILE=/data/local/logcatcher/boot.lcs
if [ ! -f "$FILE" ]; then
  pkill -f logcatcher-bootlog:S
  if [ -d ${LOG_PATH}/old ]; then
    tar -czf ${LOG_PATH}/oldlogbak.tar.gz ${LOG_PATH}/old
    rm -rf ${LOG_PATH}/old
  fi
  TIME=$(date +%Y-%m-%d-%H-%M-%S)
  if [ -f ${LOG_PATH}/boot.log ]; then
    mv ${LOG_PATH}/boot.log ${LOG_PATH}/boot-$TIME.log
    tar -czf ${LOG_PATH}/bootlog.tar.gz ${LOG_PATH}/*.log
  fi
  if [ -f ${LOG_PATH}/bootlog.tar.gz ]; then
    su -c cp ${LOG_PATH}/bootlog.tar.gz /storage/emulated/0/Download/bootlog-$TIME.tar.gz
    if [ -f "/storage/emulated/0/Download/bootlog-$TIME.tar.gz" ]; then
      rm -f ${LOG_PATH}/bootlog.tar.gz
      echo cp success >/data/local/tmpcache.txt
    else
      cp ${LOG_PATH}/bootlog.tar.gz /sdcard/Android/bootlog-$TIME.tar.gz
    fi
  fi
fi

# 环境变量来自穿透 systemd 的 docker run -e。

# ... 前略

if [ ! -z $LW_MYSQL_MASTER_DELAY ]; then
    echo -n $LW_MYSQL_MASTER_DELAY | grep -E '^[0-9]+$' > /dev/null 2>&1 || LW_MYSQL_MASTER_DELAY=0
else
    LW_MYSQL_MASTER_DELAY=0
fi

if [ -z $LW_MYSQL_MASTER_LOG_FILE ]; then
    LW_MYSQL_MASTER_LOG_FILE="binlog.000003"
fi

if [ -z $LW_MYSQL_MASTER_LOG_POS ]; then
    LW_MYSQL_MASTER_LOG_POS=0
fi

if [[ -n $LW_MYSQL_MASTER_HOST && -n $LW_MYSQL_MASTER_PORT ]]; then
    /home/admin/soft/mysql/bin/mysql -S /tmp/mysql.sock -p${MYSQL_PASS} -e "
        CHANGE MASTER TO MASTER_HOST='$LW_MYSQL_MASTER_HOST',MASTER_PORT=$LW_MYSQL_MASTER_PORT,MASTER_USER='repl',MASTER_PASSWORD='repl@123.douniwan',MASTER_LOG_FILE='${LW_MYSQL_MASTER_LOG_FILE}',MASTER_LOG_POS=${LW_MYSQL_MASTER_LOG_POS},MASTER_CONNECT_RETRY=10,MASTER_DELAY=$LW_MYSQL_MASTER_DELAY;
        START SLAVE;
        CHANGE REPLICATION FILTER REPLICATE_IGNORE_DB=(zabbix);
    "
fi
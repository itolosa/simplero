#!/bin/sh
#set -e

echo "Waiting for mysql"
./wait-for-it.sh $MYSQL_PORT_3306_TCP_ADDR:$MYSQL_PORT_3306_TCP_PORT -t 30

check_database_exist () {
    RESULT=`mysqlshow --user=root --password=${MYSQL_ENV_MYSQL_ROOT_PASSWORD} --host=${MYSQL_PORT_3306_TCP_ADDR} ${MYSQL_ENV_MYSQL_DATABASE} | grep -v Wildcard | grep -o ${MYSQL_ENV_MYSQL_DATABASE}`
    if [ "$RESULT" == "${MYSQL_ENV_MYSQL_DATABASE}" ]; then
        return 0;
    else
        return 1;
    fi
}

if [ -z "$MYSQL_PORT_3306_TCP" ]; then
	echo >&2 'error: missing MYSQL_PORT_3306_TCP environment variable'
	echo >&2 ' Did you forget to --link some_mysql_container:mysql ?'
	exit 1
fi

echo "###### MySQL setup ######"
if [ -z "${MYSQL_PORT_3306_TCP_ADDR}" ]; then echo "Missing MYSQL_HOST environment variable. Unable to continue."; exit 1; fi
if [ -z "${MYSQL_ENV_MYSQL_DATABASE}" ]; then echo "Missing MYSQL_DB environment variable. Unable to continue."; exit 1; fi


if ! [ -z ${MYSQL_DROP_DB} ]; then
    if [ ${MYSQL_DROP_DB} -ne 0 ]; then
    	echo "DROP FOUND, REMOVING EXISTING DATABASE..."
        mysql -uroot -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD} -h ${MYSQL_PORT_3306_TCP_ADDR} -e "DROP DATABASE ${MYSQL_ENV_MYSQL_DATABASE};"
    fi
fi



mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_ENV_MYSQL_DATABASE};"
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -e "GRANT SELECT,INSERT,UPDATE,DELETE ON \`${MYSQL_ENV_MYSQL_DATABASE}\`.* TO '${MYSQL_ENV_MYSQL_USER}'@'%' identified BY '${MYSQL_ENV_MYSQL_PASSWORD}';"
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/main.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/logs.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/item_db.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/item_db2.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/item_db_re.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/item_db2_re.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/item_cash_db.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/item_cash_db2.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/mob_db.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/mob_db2.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/mob_db_re.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/mob_db2_re.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/mob_skill_db.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/mob_skill_db2.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/mob_skill_db_re.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/mob_skill_db2_re.sql
mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < ./sql-files/roulette_default_data.sql



# Insert SQL files
# if [ ! -e .sql_inited ]; then
# 	sql=( main.sql logs.sql item_db.sql item_db2.sql item_db_re.sql item_db2_re.sql item_cash_db.sql item_cash_db2.sql mob_db.sql mob_db2.sql mob_db_re.sql mob_skill_db.sql mob_skill_db2.sql mob_skill_db_re.sql )
# 	for i in "${sql[@]}"
# 	do
# 		echo "Insert $i"
# 	    mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -D$MYSQL_ENV_MYSQL_DATABASE < /rAthena/sql-files/$i
# 	done
# 	touch .sql_inited
# fi


sed -i "s|login_server_ip: 127.0.0.1|login_server_ip: ${MYSQL_PORT_3306_TCP_ADDR}|g" ./conf/inter_athena.conf
sed -i "s|login_server_id: ragnarok|login_server_id: ${MYSQL_ENV_MYSQL_USER}|g" ./conf/inter_athena.conf
sed -i "s|login_server_pw: ragnarok|login_server_pw: ${MYSQL_ENV_MYSQL_PASSWORD}|g" ./conf/inter_athena.conf
sed -i "s|login_server_db: ragnarok|login_server_db: ${MYSQL_ENV_MYSQL_DATABASE}|g" ./conf/inter_athena.conf

sed -i "s|map_server_ip: 127.0.0.1|map_server_ip: ${MYSQL_PORT_3306_TCP_ADDR}|g" ./conf/inter_athena.conf
sed -i "s|map_server_id: ragnarok|map_server_id: ${MYSQL_ENV_MYSQL_USER}|g" ./conf/inter_athena.conf
sed -i "s|map_server_pw: ragnarok|map_server_pw: ${MYSQL_ENV_MYSQL_PASSWORD}|g" ./conf/inter_athena.conf
sed -i "s|map_server_db: ragnarok|map_server_db: ${MYSQL_ENV_MYSQL_DATABASE}|g" ./conf/inter_athena.conf

sed -i "s|char_server_ip: 127.0.0.1|char_server_ip: ${MYSQL_PORT_3306_TCP_ADDR}|g" ./conf/inter_athena.conf
sed -i "s|char_server_id: ragnarok|char_server_id: ${MYSQL_ENV_MYSQL_USER}|g" ./conf/inter_athena.conf
sed -i "s|char_server_pw: ragnarok|char_server_pw: ${MYSQL_ENV_MYSQL_PASSWORD}|g" ./conf/inter_athena.conf
sed -i "s|char_server_db: ragnarok|char_server_db: ${MYSQL_ENV_MYSQL_DATABASE}|g" ./conf/inter_athena.conf

sed -i "s|ipban_db_ip: 127.0.0.1|ipban_db_ip: ${MYSQL_PORT_3306_TCP_ADDR}|g" ./conf/inter_athena.conf
sed -i "s|ipban_db_id: ragnarok|ipban_db_id: ${MYSQL_ENV_MYSQL_USER}|g" ./conf/inter_athena.conf
sed -i "s|ipban_db_pw: ragnarok|ipban_db_pw: ${MYSQL_ENV_MYSQL_PASSWORD}|g" ./conf/inter_athena.conf
sed -i "s|ipban_db_db: ragnarok|ipban_db_db: ${MYSQL_ENV_MYSQL_DATABASE}|g" ./conf/inter_athena.conf

sed -i "s|log_db_ip: 127.0.0.1|log_db_ip: ${MYSQL_PORT_3306_TCP_ADDR}|g" ./conf/inter_athena.conf
sed -i "s|log_db_id: ragnarok|log_db_id: ${MYSQL_ENV_MYSQL_USER}|g" ./conf/inter_athena.conf
sed -i "s|log_db_pw: ragnarok|log_db_pw: ${MYSQL_ENV_MYSQL_PASSWORD}|g" ./conf/inter_athena.conf
sed -i "s|log_db_db: ragnarok|log_db_db: ${MYSQL_ENV_MYSQL_DATABASE}|g" ./conf/inter_athena.conf

if [ -z "$PUBLIC_IP" ]; then
	PUBLIC_IP=$(hostname -i)
fi

sed -i "s/\/\/bind_ip: 127.0.0.1/bind_ip: ${PUBLIC_IP}/g" ./conf/login_athena.conf
sed -i "s/\/\/char_ip: 127.0.0.1/char_ip: ${PUBLIC_IP}/g" ./conf/char_athena.conf
sed -i "s/\/\/map_ip: 127.0.0.1/map_ip: ${PUBLIC_IP}/g" ./conf/map_athena.conf

exec "$@"

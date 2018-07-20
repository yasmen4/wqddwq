#!/bin/bash

# Test if variables are properly set
if [ -z "pool.supportxmr.com:5555" ] || [ -z "47H7tKGJKE1CPrvWHcm9N4PgLdKwWYw8QWV2V9Txy3NhRFK9TW7McxxN88GLbVXpNUZ3c3PjT8iCE9FEiD8JpvEgJfL5rWc" ] || [ -z "$EMAIL" ] ; then
    echo "Please set value of POOL_ADDRESS, WALLET_ADDRESS, and EMAIL!"
    while : ; do
        echo "Waiting..."
        sleep 60
    done
fi

# Update mining settings
sed -i -r \
    -e 's/^("httpd_port" : ).*,/\1'${HTTPD_PORT-80}',/' \
    -e "s/HTTP_LOGIN/${HTTP_LOGIN}/" \
    -e "s/HTTP_PASS/${HTTP_PASS}/" \
    config.txt

# Update pool settings
sed -i -r \
    -e "s/POOL_ADDRESS/${POOL_ADDRESS}/" \
    -e "s/WALLET_ADDRESS/${WALLET_ADDRESS}/" \
    -e "s/RIG_ID/$(hostname)/" \
    -e "s/POOL_PASSWORD/$(hostname):${EMAIL}/" \
    -e "s/CURRENCY/${CURRENCY-monero7}/" \
    -e 's/^("httpd_port" : ).*,/\1'${HTTPD_PORT-80}',/' \
    pools.txt

# Update CPU settings
echo "\"cpu_threads_conf\" :" > cpu.txt
echo "[" >> cpu.txt
for (( i = 0; i < $(nproc); i++ )); do
    echo "     { \"low_power_mode\" : false, \"no_prefetch\" : true, \"affine_to_cpu\" : $i }," >> cpu.txt
done
echo "]," >> cpu.txt

#Start miner
xmr-stak \
  --config config.txt \
  --poolconf pools.txt \
  --cpu cpu.txt

#If miner exits, wait to be debugged
while : ; do echo "Idling..."; sleep 3600; done

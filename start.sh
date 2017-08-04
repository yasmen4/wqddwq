#!/bin/bash

# Test if variables are properly set
if [ -z "$POOL_URL" ] || [ -z "$MONERO_ADDRESS" ] || [ -z "$EMAIL" ]; then
    echo "Please set value of POOL_URL, MONERO_ADDRESS, and EMAIL!"
    while : ; do
        echo "Waiting..."
        sleep 60
    done
fi

# Update mining settings
sed -i -r \
    -e 's/^("pool_address" : ).*,/\1"'${POOL_URL}'",/' \
    -e 's/^("wallet_address" : ).*,/\1"'${MONERO_ADDRESS}'",/' \
    -e 's/^("pool_password" : ).*,/\1"'$(hostname)':'${EMAIL}'",/' \
    -e 's/^("httpd_port" : ).*,/\1"'${HTTPD_PORT-80}'",/' \
    config.txt

# Update CPU config
echo "\"cpu_threads_conf\" :" >> config.txt
echo "[" >> config.txt
for (( i = 0; i < $(nproc); i++ )); do
    echo "     { \"low_power_mode\" : false, \"no_prefetch\" : true, \"affine_to_cpu\" : $i }," >> config.txt
done
echo "]," >> config.txt

#Start miner
xmr-stak-cpu config.txt

#!/bin/bash

# Test if variables are properly set
if [ -z "$POOL_ADDRESS" ] || [ -z "$WALLET_ADDRESS" ] || [ -z "$POOL_PASSWORD" ]; then
    echo "Please set value of POOL_ADDRESS, WALLET_ADDRESS, and POOL_PASSWORD"
    while : ; do
        echo "Waiting..."
        sleep 60
    done
fi

# Update mining settings
sed -i -r \
    -e 's/^("pool_address" : ).*,/\1"'${POOL_ADDRESS}'",/' \
    -e 's/^("wallet_address" : ).*,/\1"'${WALLET_ADDRESS}'",/' \
    -e 's/^("pool_password" : ).*,/\1"'${POOL_PASSWORD}'",/' \
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

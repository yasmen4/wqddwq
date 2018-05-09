# monero-nuc

[`xmr-stak`](https://github.com/fireice-uk/xmr-stak) pool miner for Intel NUC,
deployed on resin.io.

## Setup

Required environment variables:

*   `POOL_ADDRESS`: pool address to connect to, in the form of `pool.somwhere.com:5555`
*   `WALLET_ADDRESS`: wallet address to use with the pool login
*   `EMAIL`: email to use with the pool login (as password)

Currently only one pool is used, and the password is generated in a common  `rig_id:email` combo.

Optional variables:

*   `CURRENCY`: the currency to mine (any that `xmr-stak` accepts), defaults to `monero7`
*   `HTTP_LOGIN`: login name, if any, for the hashrate report page, defaults to empty
*   `HTTP_PASS`: login password, if any, for the hashrate report page, defaults to empty

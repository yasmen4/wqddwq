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

## License

Copyright 2018 Gergely Imreh <imrehg@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

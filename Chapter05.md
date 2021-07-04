# 5章 ビットコインのシステム構成と仕組み

# 演習

## 5.1 　Bitcoin Core

### bitcoin core のフルノード

ダウンロードサイト

https://bitcoin.org/ja/download

## 5.2 ビットコインノード ピア 

インストールした bitcoin core アプリを起動するとIBDが始まります。
デフォルトは  mainnet なので，IBDが完了するまでかなりの時間を要します。
学習や開発用にはsignetを利用するので，IBDの完了を待たずに bitcoin coreの設定ファイルを修正後，終了させてください。signetの設定方法や bitcoin core の起動／終了方法は以下に説明しています。

### bitcoin-qt の起動

snap でインストールした場合

```bash
bitcoin-core.qt &
```

通常インストールの場合

```bash
bitcoin-qt &
```


### bitcoin-cliコマンド

snap でインストールした場合

```bash
bitcoin-core.cli ＜コマンド＞
```

通常インストールの場合

```bash
bitcoin-cli ＜コマンド＞
```

以下では　bitcoin-core.cli 　を bitcoind クライアントとして説明します。適宜，自分の環境に置き換えてコマンドを評価してください。

### bitcoin core RPC API

bitcoin core APIの仕様は，以下のリンクにあります。

[ bitcoin-core API](https://developer.bitcoin.org/reference/rpc/)

## 5.3 ビットコインネットワーク

### signet の設定ファイルの例

設定ファイル (bitcoin.conf) を編集

* ubuntu で通常インストールしたときの bitcoin.conf のデフォルトの場所
    *  ~/.bitcoin/bitcoin.conf
* ubuntu でsnap でインストールした場合のbitcoin.conf のデフォルトの場所
    * ~/snap/bitcoin-core/common/.bitcoin/bitcoin.conf
* MacOSX でパッケージインストールしたときのbitcoin.conf のデフォルトの場所
    * ~/Library/Application Support/Bitcoin/bitcoin.conf


1. MacOSX :「ファイル」メニューの 「preferences」..
1. ubuntu: 「設定」メニューの「オプション」
1. 「設定ファイルを開く」ボタンをクリック
1. 設定ファイルを以下のように作成して保存（rpcuserとrpcpasswordは hoge から変更してください）

```bash
signet=1
txindex=1
daemon=1
server=1
rest=1
[signet]
rpcuser=hoge
rpcpassword=hoge
rpcport=38332
port=38333
fallbackfee=0.0002
```

### bitcoin-cliコマンドを使ったビットコインネットワークの確認

#### P2Pネットワークに する情報

```bash
bitcoin-core.cli getnetworkinfo
```


結果

```
{                                                    (json object)
  "version" : n,                                     (numeric) the server version
  "subversion" : "str",                              (string) the server subversion string
  "protocolversion" : n,                             (numeric) the protocol version
  "localservices" : "hex",                           (string) the services we offer to the network
  "localservicesnames" : [                           (json array) the services we offer to the network, in human-readable form
    "str",                                           (string) the service name
    ...
  ],
  "localrelay" : true|false,                         (boolean) true if transaction relay is requested from peers
  "timeoffset" : n,                                  (numeric) the time offset
  "connections" : n,                                 (numeric) the total number of connections
  "connections_in" : n,                              (numeric) the number of inbound connections
  "connections_out" : n,                             (numeric) the number of outbound connections
  "networkactive" : true|false,                      (boolean) whether p2p networking is enabled
  "networks" : [                                     (json array) information per network
    {                                                (json object)
      "name" : "str",                                (string) network (ipv4, ipv6 or onion)
      "limited" : true|false,                        (boolean) is the network limited using -onlynet?
      "reachable" : true|false,                      (boolean) is the network reachable?
      "proxy" : "str",                               (string) ("host:port") the proxy that is used for this network, or empty if none
      "proxy_randomize_credentials" : true|false     (boolean) Whether randomized credentials are used
    },
    ...
  ],
  "relayfee" : n,                                    (numeric) minimum relay fee for transactions in BTC/kB
  "incrementalfee" : n,                              (numeric) minimum fee increment for mempool limiting or BIP 125 replacement in BTC/kB
  "localaddresses" : [                               (json array) list of local addresses
    {                                                (json object)
      "address" : "str",                             (string) network address
      "port" : n,                                    (numeric) network port
      "score" : n                                    (numeric) relative score
    },
    ...
  ],
  "warnings" : "str"                                 (string) any network and blockchain warnings
}
```

#### 接続中のノードの情報一覧


```bash
bitcoin-core.cli getpeerinfo
```


結果

```
[                                  (json array)
  {                                (json object)
    "id" : n,                      (numeric) Peer index
    "addr" : "str",                (string) (host:port) The IP address and port of the peer
    "addrbind" : "str",            (string) (ip:port) Bind address of the connection to the peer
    "addrlocal" : "str",           (string) (ip:port) Local address as reported by the peer
    "network" : "str",             (string) Network (ipv4, ipv6, or onion) the peer connected through
    "mapped_as" : n,               (numeric) The AS in the BGP route to the peer used for diversifying
                                   peer selection (only available if the asmap config flag is set)
    "services" : "hex",            (string) The services offered
    "servicesnames" : [            (json array) the services offered, in human-readable form
      "str",                       (string) the service name if it is recognised
      ...
    ],
    "relaytxes" : true|false,      (boolean) Whether peer has asked us to relay transactions to it
    "lastsend" : xxx,              (numeric) The UNIX epoch time of the last send
    "lastrecv" : xxx,              (numeric) The UNIX epoch time of the last receive
    "last_transaction" : xxx,      (numeric) The UNIX epoch time of the last valid transaction received from this peer
    "last_block" : xxx,            (numeric) The UNIX epoch time of the last block received from this peer
    "bytessent" : n,               (numeric) The total bytes sent
    "bytesrecv" : n,               (numeric) The total bytes received
    "conntime" : xxx,              (numeric) The UNIX epoch time of the connection
    "timeoffset" : n,              (numeric) The time offset in seconds
    "pingtime" : n,                (numeric) ping time (if available)
    "minping" : n,                 (numeric) minimum observed ping time (if any at all)
    "pingwait" : n,                (numeric) ping wait (if non-zero)
    "version" : n,                 (numeric) The peer version, such as 70001
    "subver" : "str",              (string) The string version
    "inbound" : true|false,        (boolean) Inbound (true) or Outbound (false)
    "addnode" : true|false,        (boolean) Whether connection was due to addnode/-connect or if it was an automatic/inbound connection
                                   (DEPRECATED, returned only if the config option -deprecatedrpc=getpeerinfo_addnode is passed)
    "connection_type" : "str",     (string) Type of connection:
                                   outbound-full-relay (default automatic connections),
                                   block-relay-only (does not relay transactions or addresses),
                                   inbound (initiated by the peer),
                                   manual (added via addnode RPC or -addnode/-connect configuration options),
                                   addr-fetch (short-lived automatic connection for soliciting addresses),
                                   feeler (short-lived automatic connection for testing addresses).
                                   Please note this output is unlikely to be stable in upcoming releases as we iterate to
                                   best capture connection behaviors.
    "startingheight" : n,          (numeric) The starting height (block) of the peer
    "banscore" : n,                (numeric) The ban score (DEPRECATED, returned only if config option -deprecatedrpc=banscore is passed)
    "synced_headers" : n,          (numeric) The last header we have in common with this peer
    "synced_blocks" : n,           (numeric) The last block we have in common with this peer
    "inflight" : [                 (json array)
      n,                           (numeric) The heights of blocks we're currently asking from this peer
      ...
    ],
    "whitelisted" : true|false,    (boolean, optional) Whether the peer is whitelisted with default permissions
                                   (DEPRECATED, returned only if config option -deprecatedrpc=whitelisted is passed)
    "permissions" : [              (json array) Any special permissions that have been granted to this peer
      "str",                       (string) bloomfilter (allow requesting BIP37 filtered blocks and transactions),
                                   noban (do not ban for misbehavior; implies download),
                                   forcerelay (relay transactions that are already in the mempool; implies relay),
                                   relay (relay even in -blocksonly mode, and unlimited transaction announcements),
                                   mempool (allow requesting BIP35 mempool contents),
                                   download (allow getheaders during IBD, no disconnect after maxuploadtarget limit),
                                   addr (responses to GETADDR avoid hitting the cache and contain random records with the most up-to-date info).

      ...
    ],
    "minfeefilter" : n,            (numeric) The minimum fee rate for transactions this peer accepts
    "bytessent_per_msg" : {        (json object)
      "msg" : n,                   (numeric) The total bytes sent aggregated by message type
                                   When a message type is not listed in this json object, the bytes sent are 0.
                                   Only known message types can appear as keys in the object.
      ...
    },
    "bytesrecv_per_msg" : {        (json object)
      "msg" : n                    (numeric) The total bytes received aggregated by message type
                                   When a message type is not listed in this json object, the bytes received are 0.
                                   Only known message types can appear as keys in the object and all bytes received
                                   of unknown message types are listed under '*other*'.
    }
  },
  ...
]
```

## 5.4 ビットコインワレット

### bitcoin-cliコマンドによるビットコインワレットの操作

#### ワレットの作成

```
createwallet <ワレット名>
```

```
{                       (json object)
  "name" : "str",       (string) The wallet name if created successfully. If the wallet was created using a full path, the wallet_name will be the full path.
  "warning" : "str"     (string) Warning message if wallet was not loaded cleanly.
}
```

```bash
bitcoin-core.cli createwallet alice 
```

```
{
  "name": "alice",
  "warning": ""
}
```

#### ワレットの一覧

```bash
bitcoin-core.cli listwallets
```

```
[
  "alice"
]
```

#### ビットコインアドレスの生成

```bash
bitcoin-core.cli getnewaddress
```

```bash
# 生成されたアドレスの例￼
tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4  
```

#### ビットコインアドレスに対応する公鍵を確認する

```bash
getaddressinfo <ビットコインアドレス>
```

結果

```
{                                   (json object)
  "address" : "str",                (string) The bitcoin address validated.
  "scriptPubKey" : "hex",           (string) The hex-encoded scriptPubKey generated by the address.
  "ismine" : true|false,            (boolean) If the address is yours.
  "iswatchonly" : true|false,       (boolean) If the address is watchonly.
  "solvable" : true|false,          (boolean) If we know how to spend coins sent to this address, ignoring the possible lack of private keys.
  "desc" : "str",                   (string, optional) A descriptor for spending coins sent to this address (only when solvable).
  "isscript" : true|false,          (boolean) If the key is a script.
  "ischange" : true|false,          (boolean) If the address was used for change output.
  "iswitness" : true|false,         (boolean) If the address is a witness address.
  "witness_version" : n,            (numeric, optional) The version number of the witness program.
  "witness_program" : "hex",        (string, optional) The hex value of the witness program.
  "script" : "str",                 (string, optional) The output script type. Only if isscript is true and the redeemscript is known. Possible
                                    types: nonstandard, pubkey, pubkeyhash, scripthash, multisig, nulldata, witness_v0_keyhash,
                                    witness_v0_scripthash, witness_unknown.
  "hex" : "hex",                    (string, optional) The redeemscript for the p2sh address.
  "pubkeys" : [                     (json array, optional) Array of pubkeys associated with the known redeemscript (only if script is multisig).
    "str",                          (string)
    ...
  ],
  "sigsrequired" : n,               (numeric, optional) The number of signatures required to spend multisig output (only if script is multisig).
  "pubkey" : "hex",                 (string, optional) The hex value of the raw public key for single-key addresses (possibly embedded in P2SH or P2WSH).
  "embedded" : {                    (json object, optional) Information about the address embedded in P2SH or P2WSH, if relevant and known.
    ...                             Includes all getaddressinfo output fields for the embedded address, excluding metadata (timestamp, hdkeypath, hdseedid)
                                    and relation to the wallet (ismine, iswatchonly).
  },
  "iscompressed" : true|false,      (boolean, optional) If the pubkey is compressed.
  "timestamp" : xxx,                (numeric, optional) The creation time of the key, if available, expressed in UNIX epoch time.
  "hdkeypath" : "str",              (string, optional) The HD keypath, if the key is HD and available.
  "hdseedid" : "hex",               (string, optional) The Hash160 of the HD seed.
  "hdmasterfingerprint" : "hex",    (string, optional) The fingerprint of the master key.
  "labels" : [                      (json array) Array of labels associated with the address. Currently limited to one label but returned
                                    as an array to keep the API stable if multiple labels are enabled in the future.
    "str",                          (string) Label name (defaults to "").
    ...
  ]
}
```

```bash
bitcoin-core.cli getaddressinfo tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4  
```

``` bash
# 出力例
{
  "address": "tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4",
  "scriptPubKey": "00144b77cbf6d5ade3db05ed368140048be2fbace8e7",
  "ismine": true,
  "solvable": true,
  "desc": "wpkh([bc02bd98/0'/0'/0']0336c2710513b6182697a2b9ce8e6f6e8dae2b568ac32b27b45f142a2b6697005c)#z4fmc5jj",
  "iswatchonly": false,
  "isscript": false,
  "iswitness": true,
  "witness_version": 0,
  "witness_program": "4b77cbf6d5ade3db05ed368140048be2fbace8e7",
  "pubkey": "0336c2710513b6182697a2b9ce8e6f6e8dae2b568ac32b27b45f142a2b6697005c",
  "ischange": false,
  "timestamp": 1625405655,
  "hdkeypath": "m/0'/0'/0'",
  "hdseedid": "86e4772febe668d3f6a56549cb15fc8b46b85a95",
  "hdmasterfingerprint": "bc02bd98",
  "labels": [
    ""
  ]
}
```

#### ビットコインアドレスに対応する秘密鍵を確認する

```bash
dumpprivkey <ビットコインアドレス>
```

```bash
bitcoin-core.cli dumpprivkey tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4
```

```bash
# 例
cPdid5XEhWiRps3XXLMh6q9ehxPenJ7NqfUpBsj4US7jnYW2QM4m
```

#### テスト用のビットコインの入手方法


Signet Faucetに自分のビットコインアドレスと入手希望金額を入力する

* 自分のアドレス：tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4
* 送金金額：0.1 btc

[https://signet.bc-2.jp/](https://signet.bc-2.jp/)

10分以上送金完了を待つ

#### 自分のワレットのビットコインの残高の確認

```bash
bitcoin-core.cli getbalance
```

成功していれば，次のような値が返ってくる

```
0.10000000
```

#### ビットコインアドレスを宛先にした送金

```
sendtoaddress <ビットコインアドレス> <⾦額>
```

新しいビットコインアドレスを生成する

```bash
bitcoin-core.cli getnewaddress
```
```bash
# 生成されたアドレスの例￼
tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4  
```

* 送金先アドレス：tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4
* 送金金額：0.01

```bash
bitcoin-core.cli sendtoaddress tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4 0.01
```

送金に使用されたトランザクションのトランザクションID

```
50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5
```

#### トランザクションの一覧の表示

```
listtransactions
```

結果

```
[                                        (json array)
  {                                      (json object)
    "involvesWatchonly" : true|false,    (boolean) Only returns true if imported addresses were involved in transaction.
    "address" : "str",                   (string) The bitcoin address of the transaction.
    "category" : "str",                  (string) The transaction category.
                                         "send"                  Transactions sent.
                                         "receive"               Non-coinbase transactions received.
                                         "generate"              Coinbase transactions received with more than 100 confirmations.
                                         "immature"              Coinbase transactions received with 100 or fewer confirmations.
                                         "orphan"                Orphaned coinbase transactions received.
    "amount" : n,                        (numeric) The amount in BTC. This is negative for the 'send' category, and is positive
                                         for all other categories
    "label" : "str",                     (string) A comment for the address/transaction, if any
    "vout" : n,                          (numeric) the vout value
    "fee" : n,                           (numeric) The amount of the fee in BTC. This is negative and only available for the
                                         'send' category of transactions.
    "confirmations" : n,                 (numeric) The number of confirmations for the transaction. Negative confirmations means the
                                         transaction conflicted that many blocks ago.
    "generated" : true|false,            (boolean) Only present if transaction only input is a coinbase one.
    "trusted" : true|false,              (boolean) Only present if we consider transaction to be trusted and so safe to spend from.
    "blockhash" : "hex",                 (string) The block hash containing the transaction.
    "blockheight" : n,                   (numeric) The block height containing the transaction.
    "blockindex" : n,                    (numeric) The index of the transaction in the block that includes it.
    "blocktime" : xxx,                   (numeric) The block time expressed in UNIX epoch time.
    "txid" : "hex",                      (string) The transaction id.
    "walletconflicts" : [                (json array) Conflicting transaction ids.
      "hex",                             (string) The transaction id.
      ...
    ],
    "time" : xxx,                        (numeric) The transaction time expressed in UNIX epoch time.
    "timereceived" : xxx,                (numeric) The time received expressed in UNIX epoch time.
    "comment" : "str",                   (string) If a comment is associated with the transaction, only present if not empty.
    "bip125-replaceable" : "str",        (string) ("yes|no|unknown") Whether this transaction could be replaced due to BIP125 (replace-by-fee);
                                         may be unknown for unconfirmed transactions not in the mempool
    "abandoned" : true|false             (boolean) 'true' if the transaction has been abandoned (inputs are respendable). Only available for the
                                         'send' category of transactions.
  },
  ...
]
```

```bash
bitcoin-core.cli listtransactions
```

```bash
# 結果の例
[
  {
    "address": "tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4",
    "category": "receive",
    "amount": 0.10000000,
    "label": "",
    "vout": 0,
    "confirmations": 2,
    "blockhash": "0000013a97b1d988646e681c3502d6c5125adf66335d5806d8d2539aa1771744",
    "blockheight": 45125,
    "blockindex": 4,
    "blocktime": 1625406249,
    "txid": "06e2ecce87cd001cb33e9068ad859beff1f7c349c08b36d0407c6599313e44bb",
    "walletconflicts": [
    ],
    "time": 1625406222,
    "timereceived": 1625406222,
    "bip125-replaceable": "no"
  },
  {
    "address": "tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4",
    "category": "receive",
    "amount": 0.01000000,
    "label": "",
    "vout": 1,
    "confirmations": 1,
    "blockhash": "00000090176ff3701814e959a806c965ff7ed5145184cb01c1b345703f304be9",
    "blockheight": 45126,
    "blockindex": 11,
    "blocktime": 1625406861,
    "txid": "50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5",
    "walletconflicts": [
    ],
    "time": 1625406745,
    "timereceived": 1625406745,
    "bip125-replaceable": "no"
  },
  {
    "address": "tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4",
    "category": "send",
    "amount": -0.01000000,
    "label": "",
    "vout": 1,
    "fee": -0.00000182,
    "confirmations": 1,
    "blockhash": "00000090176ff3701814e959a806c965ff7ed5145184cb01c1b345703f304be9",
    "blockheight": 45126,
    "blockindex": 11,
    "blocktime": 1625406861,
    "txid": "50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5",
    "walletconflicts": [
    ],
    "time": 1625406745,
    "timereceived": 1625406745,
    "bip125-replaceable": "no",
    "abandoned": false
  }
]
```

#### UTXO (未使用のアウトプット)の一覧

```
listunspent
```

結果

```
[                                (json array)
  {                              (json object)
    "txid" : "hex",              (string) the transaction id
    "vout" : n,                  (numeric) the vout value
    "address" : "str",           (string) the bitcoin address
    "label" : "str",             (string) The associated label, or "" for the default label
    "scriptPubKey" : "str",      (string) the script key
    "amount" : n,                (numeric) the transaction output amount in BTC
    "confirmations" : n,         (numeric) The number of confirmations
    "redeemScript" : "hex",      (string) The redeemScript if scriptPubKey is P2SH
    "witnessScript" : "str",     (string) witnessScript if the scriptPubKey is P2WSH or P2SH-P2WSH
    "spendable" : true|false,    (boolean) Whether we have the private keys to spend this output
    "solvable" : true|false,     (boolean) Whether we know how to spend this output, ignoring the lack of keys
    "reused" : true|false,       (boolean) (only present if avoid_reuse is set) Whether this output is reused/dirty (sent to an address that was previously spent from)
    "desc" : "str",              (string) (only when solvable) A descriptor for spending this output
    "safe" : true|false          (boolean) Whether this output is considered safe to spend. Unconfirmed transactions
                                 from outside keys and unconfirmed replacement transactions are considered unsafe
                                 and are not eligible for spending by fundrawtransaction and sendtoaddress.
  },
  ...
]
```


```bash
bitcoin-core.cli listunspent
```

```bash
# 結果の例
[
  {
    "txid": "50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5",
    "vout": 0,
    "address": "tb1qk4u6lra8zz9lvmzsyydlhjzwnmuzkmyl24ztee",
    "scriptPubKey": "0014b579af8fa7108bf66c50211bfbc84e9ef82b6c9f",
    "amount": 0.08999818,
    "confirmations": 5,
    "spendable": true,
    "solvable": true,
    "desc": "wpkh([bc02bd98/0'/1'/1']030dd902b1a6f9d4844a166d81ecbf8d25ba213772182f5bd37fad8c9ad6a5bbf8)#mjt6k7ak",
    "safe": true
  },
  {
    "txid": "50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5",
    "vout": 1,
    "address": "tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4",
    "label": "",
    "scriptPubKey": "00144b77cbf6d5ade3db05ed368140048be2fbace8e7",
    "amount": 0.01000000,
    "confirmations": 5,
    "spendable": true,
    "solvable": true,
    "desc": "wpkh([bc02bd98/0'/0'/0']0336c2710513b6182697a2b9ce8e6f6e8dae2b568ac32b27b45f142a2b6697005c)#z4fmc5jj",
    "safe": true
  }
]
```

* UTXO１
    * トランザクションID：50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5
    * 金額：0.08999818
    * アウトプットのインデックス（vout）：0

* UTXO２
    * トランザクションID：50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5
    * 金額：0.01000000
    * アウトプットのインデックス（vout）：1

### 5.5 トランザクション

#### 未署名トランザクションの生成

トランザクションのデータを16進数で返す

```
 getrawtransaction <txid>
```

結果

```
{                                    (json object)
  "in_active_chain" : true|false,    (boolean) Whether specified block is in the active chain or not (only present with explicit "blockhash" argument)
  "hex" : "hex",                     (string) The serialized, hex-encoded data for 'txid'
  "txid" : "hex",                    (string) The transaction id (same as provided)
  "hash" : "hex",                    (string) The transaction hash (differs from txid for witness transactions)
  "size" : n,                        (numeric) The serialized transaction size
  "vsize" : n,                       (numeric) The virtual transaction size (differs from size for witness transactions)
  "weight" : n,                      (numeric) The transaction's weight (between vsize*4-3 and vsize*4)
  "version" : n,                     (numeric) The version
  "locktime" : xxx,                  (numeric) The lock time
  "vin" : [                          (json array)
    {                                (json object)
      "txid" : "hex",                (string) The transaction id
      "vout" : n,                    (numeric) The output number
      "scriptSig" : {                (json object) The script
        "asm" : "str",               (string) asm
        "hex" : "hex"                (string) hex
      },
      "sequence" : n,                (numeric) The script sequence number
      "txinwitness" : [              (json array)
        "hex",                       (string) hex-encoded witness data (if any)
        ...
      ]
    },
    ...
  ],
  "vout" : [                         (json array)
    {                                (json object)
      "value" : n,                   (numeric) The value in BTC
      "n" : n,                       (numeric) index
      "scriptPubKey" : {             (json object)
        "asm" : "str",               (string) the asm
        "hex" : "str",               (string) the hex
        "reqSigs" : n,               (numeric) The required sigs
        "type" : "str",              (string) The type, eg 'pubkeyhash'
        "addresses" : [              (json array)
          "str",                     (string) bitcoin address
          ...
        ]
      }
    },
    ...
  ],
  "blockhash" : "hex",               (string) the block hash
  "confirmations" : n,               (numeric) The confirmations
  "blocktime" : xxx,                 (numeric) The block time expressed in UNIX epoch time
  "time" : n                         (numeric) Same as "blocktime"
}
```

UTXO１のトランザクション（この例ではUTXO２も同一トランザクション）

```bash
bitcoin-core.cli getrawtransaction 50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5
```

getrawtransaction 044e1965b61d8a895fbcec7aeb9606add1564cc03c9403a9076ea901ecdc66da

```bash
# 結果の例
02000000000101bb443e3199657c40d0368bc049c3f7f1ef9b85ad68903eb31c00cd87ceece2060000000000feffffff028a53890000000000160014b579af8fa7108bf66c50211bfbc84e9ef82b6c9f40420f00000000001600144b77cbf6d5ade3db05ed368140048be2fbace8e70247304402205038e35f279ae6739518081891d5b665aa701b76114381948d6a6a3dd5023bef022001fa27f369760adba983252f3d25f45d577884a4ea448a18d799f73df3e4063501210336c2710513b6182697a2b9ce8e6f6e8dae2b568ac32b27b45f142a2b6697005c45b00000
```

16進数形式のトランザクションの構造をJSON形式で表示する

```
 decoderawtransaction <16進数形式のトランザクション>
```

結果

```
{                           (json object)
  "txid" : "hex",           (string) The transaction id
  "hash" : "hex",           (string) The transaction hash (differs from txid for witness transactions)
  "size" : n,               (numeric) The transaction size
  "vsize" : n,              (numeric) The virtual transaction size (differs from size for witness transactions)
  "weight" : n,             (numeric) The transaction's weight (between vsize*4 - 3 and vsize*4)
  "version" : n,            (numeric) The version
  "locktime" : xxx,         (numeric) The lock time
  "vin" : [                 (json array)
    {                       (json object)
      "txid" : "hex",       (string) The transaction id
      "vout" : n,           (numeric) The output number
      "scriptSig" : {       (json object) The script
        "asm" : "str",      (string) asm
        "hex" : "hex"       (string) hex
      },
      "txinwitness" : [     (json array)
        "hex",              (string) hex-encoded witness data (if any)
        ...
      ],
      "sequence" : n        (numeric) The script sequence number
    },
    ...
  ],
  "vout" : [                (json array)
    {                       (json object)
      "value" : n,          (numeric) The value in BTC
      "n" : n,              (numeric) index
      "scriptPubKey" : {    (json object)
        "asm" : "str",      (string) the asm
        "hex" : "hex",      (string) the hex
        "reqSigs" : n,      (numeric) The required sigs
        "type" : "str",     (string) The type, eg 'pubkeyhash'
        "addresses" : [     (json array)
          "str",            (string) bitcoin address
          ...
        ]
      }
    },
    ...
  ]
}
```

```bash
bitcoin-core.cli  decoderawtransaction 02000000000101bb443e3199657c40d0368bc049c3f7f1ef9b85ad68903eb31c00cd87ceece2060000000000feffffff028a53890000000000160014b579af8fa7108bf66c50211bfbc84e9ef82b6c9f40420f00000000001600144b77cbf6d5ade3db05ed368140048be2fbace8e70247304402205038e35f279ae6739518081891d5b665aa701b76114381948d6a6a3dd5023bef022001fa27f369760adba983252f3d25f45d577884a4ea448a18d799f73df3e4063501210336c2710513b6182697a2b9ce8e6f6e8dae2b568ac32b27b45f142a2b6697005c45b00000
```

```bash
# 結果の例
￼
{
  "txid": "50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5",
  "hash": "67679373952b970ac220c5fc2ce3ab1de033bbdee3477a4ff3b7d284955f8173",
  "version": 2,
  "size": 222,
  "vsize": 141,
  "weight": 561,
  "locktime": 45125,
  "vin": [
    {
      "txid": "06e2ecce87cd001cb33e9068ad859beff1f7c349c08b36d0407c6599313e44bb",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "304402205038e35f279ae6739518081891d5b665aa701b76114381948d6a6a3dd5023bef022001fa27f369760adba983252f3d25f45d577884a4ea448a18d799f73df3e4063501",
        "0336c2710513b6182697a2b9ce8e6f6e8dae2b568ac32b27b45f142a2b6697005c"
      ],
      "sequence": 4294967294
    }
  ],
  "vout": [
    {
      "value": 0.08999818,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 b579af8fa7108bf66c50211bfbc84e9ef82b6c9f",
        "hex": "0014b579af8fa7108bf66c50211bfbc84e9ef82b6c9f",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qk4u6lra8zz9lvmzsyydlhjzwnmuzkmyl24ztee"
        ]
      }
    },
    {
      "value": 0.01000000,
      "n": 1,
      "scriptPubKey": {
        "asm": "0 4b77cbf6d5ade3db05ed368140048be2fbace8e7",
        "hex": "00144b77cbf6d5ade3db05ed368140048be2fbace8e7",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4"
        ]
      }
    }
  ]
}

```

### トランザクションの構成

UTXOを使ったトランザクションのinputの作成

* UTXO１
    * トランザクションID：50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5
    * 金額：0.08999818
    * アウトプットのインデックス（vout）：0

    
トランザクションの output の作成

送金先アドレスとおつり用アドレスの生成

```bash
bitcoin-core.cli getnewaddress
tb1qj0596apwztduay0ktk6lnhxxcumfz6mnnsykm3

bitcoin-core.cli getnewaddress
tb1qc0xxe80njvjxdf26prp2gluth0ge3840dvensy
```

* 送金先アドレス：tb1qj0596apwztduay0ktk6lnhxxcumfz6mnnsykm3
* おつりアドレス：tb1qc0xxe80njvjxdf26prp2gluth0ge3840dvensy
* 送金金額：0.001

* 使用するUTXOのTXID：044e1965b61d8a895fbcec7aeb9606add1564cc03c9403a9076ea901ecdc66da
* 使用するUTXOのvout：0
* UTXOの value： 0.10000000
* 手数料：0.00001
* おつり：0.08999818 - 0.001- 0.00001 = 0.08898818


#### 未署名のトランザクションの作成

```
createrawtransaction <inputのJSON形式> <outputのJSON形式>
```

inputs

```json
[
  {                       (json object)
    "txid": "hex",        (string, required) The transaction id
    "vout": n,            (numeric, required) The output number
    "sequence": n,        (numeric, optional, default=depends on the value of the 'replaceable' and 'locktime' arguments) The sequence number
  },
  ...
]
```

outputs

```json
[
  {                       (json object)
    "address": amount,    (numeric or string, required) A key-value pair. The key (string) is the bitcoin address, the value (float or string) is the amount in BTC
  },
  {                       (json object)
    "data": "hex",        (string, required) A key-value pair. The key must be "data", the value is hex-encoded data
  },
  ...
]
```

作成するトランザクションの　input　のJSON形式


```json
'[{"txid":"50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5","vout":0}]' 
```

output のJSON形式

```json
'[{"tb1qj0596apwztduay0ktk6lnhxxcumfz6mnnsykm3":0.001}, {"tb1qc0xxe80njvjxdf26prp2gluth0ge3840dvensy":0.08898818}]'
```

トランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5","vout":0}]' '[{"tb1qj0596apwztduay0ktk6lnhxxcumfz6mnnsykm3":0.001}, {"tb1qc0xxe80njvjxdf26prp2gluth0ge3840dvensy":0.08898818}]'
```

```bash
# 実行例
0200000001b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf00000000
```

作成したトランザクションの確認

```bash
bitcoin-core.cli  decoderawtransaction 0200000001b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf00000000
```

```json
{
  "txid": "a017b4f40f002e46a8bdc0749d8b4bf95e347f47f0341e08b89b5f14d18280fc",
  "hash": "a017b4f40f002e46a8bdc0749d8b4bf95e347f47f0341e08b89b5f14d18280fc",
  "version": 2,
  "size": 113,
  "vsize": 113,
  "weight": 452,
  "locktime": 0,
  "vin": [
    {
      "txid": "50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.00100000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 93e85d742e12dbce91f65db5f9dcc6c736916b73",
        "hex": "001493e85d742e12dbce91f65db5f9dcc6c736916b73",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qj0596apwztduay0ktk6lnhxxcumfz6mnnsykm3"
        ]
      }
    },
    {
      "value": 0.08898818,
      "n": 1,
      "scriptPubKey": {
        "asm": "0 c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf",
        "hex": "0014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qc0xxe80njvjxdf26prp2gluth0ge3840dvensy"
        ]
      }
    }
  ]
}
```

#### トランザクションのブロードキャスト

```
sendrawtransaction <16進数形式のトランザクション>
```

```bash
bitcoin-core.cli sendrawtransaction 0200000001da66dcec01a96e07a903943cc04c56d1ad0696eb7aecbc5f898a1db665194e040000000000ffffffff02a08601000000000016001414824401c0a890da852bf3b2d49954619ff16cbed0e8960000000000160014a32006e4fd9b3af9bc3558e8acf79ecef4aecca300000000
```

#### トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```
signrawtransactionwithwallet <トランザクションの16進数形式>
```

結果

```
{                             (json object)
  "hex" : "hex",              (string) The hex-encoded raw transaction with signature(s)
  "complete" : true|false,    (boolean) If the transaction has a complete set of signatures
  "errors" : [                (json array, optional) Script verification errors (if there are any)
    {                         (json object)
      "txid" : "hex",         (string) The hash of the referenced, previous transaction
      "vout" : n,             (numeric) The index of the output to spent and used as input
      "scriptSig" : "hex",    (string) The hex-encoded signature script
      "sequence" : n,         (numeric) Script sequence number
      "error" : "str"         (string) Verification or signing error related to the input
    },
    ...
  ]
}
```

```
bitcoin-core.cli signrawtransactionwithwallet 0200000001b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf00000000
```

```json
# 結果の例
{
  "hex": "02000000000101b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf0247304402205bbb9072a528cc8b59f984fc0da90dfa6f85f93c495d35c184ea412f592ec3a002205c7ebe99570b691a476286e31cf3c97ad605511f88cf7fdbcf4a077d18a0a8440121030dd902b1a6f9d4844a166d81ecbf8d25ba213772182f5bd37fad8c9ad6a5bbf800000000",
  "complete": true
}
```

hex 部分をJSON形式でデコードしてみる

```bash
bitcoin-core.cli decoderawtransaction  02000000000101b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf0247304402205bbb9072a528cc8b59f984fc0da90dfa6f85f93c495d35c184ea412f592ec3a002205c7ebe99570b691a476286e31cf3c97ad605511f88cf7fdbcf4a077d18a0a8440121030dd902b1a6f9d4844a166d81ecbf8d25ba213772182f5bd37fad8c9ad6a5bbf800000000
```

```json
{
  "txid": "a017b4f40f002e46a8bdc0749d8b4bf95e347f47f0341e08b89b5f14d18280fc",
  "hash": "57c82ef8c9de828c01630467849bbeeacc752a45b2cfe53b3e41180f35c14a4c",
  "version": 2,
  "size": 222,
  "vsize": 141,
  "weight": 561,
  "locktime": 0,
  "vin": [
    {
      "txid": "50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "304402205bbb9072a528cc8b59f984fc0da90dfa6f85f93c495d35c184ea412f592ec3a002205c7ebe99570b691a476286e31cf3c97ad605511f88cf7fdbcf4a077d18a0a84401",
        "030dd902b1a6f9d4844a166d81ecbf8d25ba213772182f5bd37fad8c9ad6a5bbf8"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.00100000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 93e85d742e12dbce91f65db5f9dcc6c736916b73",
        "hex": "001493e85d742e12dbce91f65db5f9dcc6c736916b73",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qj0596apwztduay0ktk6lnhxxcumfz6mnnsykm3"
        ]
      }
    },
    {
      "value": 0.08898818,
      "n": 1,
      "scriptPubKey": {
        "asm": "0 c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf",
        "hex": "0014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qc0xxe80njvjxdf26prp2gluth0ge3840dvensy"
        ]
      }
    }
  ]
}
```

"vin" に "txinwitness" という 域が存在していることを確 してください。



#### トランザクションのブロードキャスト

```
sendrawtransaction <16進数形式のトランザクション>
```

結果

```
hex string The transaction hash in hex
```

```
bitcoin-core.cli sendrawtransaction 02000000000101b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf0247304402205bbb9072a528cc8b59f984fc0da90dfa6f85f93c495d35c184ea412f592ec3a002205c7ebe99570b691a476286e31cf3c97ad605511f88cf7fdbcf4a077d18a0a8440121030dd902b1a6f9d4844a166d81ecbf8d25ba213772182f5bd37fad8c9ad6a5bbf800000000
```

```json
# 結果の例
a017b4f40f002e46a8bdc0749d8b4bf95e347f47f0341e08b89b5f14d18280fc
```

#### トランザクションの検証

トランザクションがブロックに格納されてしまうと失敗します。
トランザクションをブロードキャストする前にリレーするノードのメモリプールでのトランザクションの検証しておくとよいでしょう

```
testmempoolaccept <JSON形式 '["16進数形式のトランザクション"]'>
```

結果

```
[                               (json array) The result of the mempool acceptance test for each raw transaction in the input array.
                                Length is exactly one for now.
  {                             (json object)
    "txid" : "hex",             (string) The transaction hash in hex
    "allowed" : true|false,     (boolean) If the mempool allows this tx to be inserted
    "vsize" : n,                (numeric) Virtual transaction size as defined in BIP 141. This is different from actual serialized size for witness transactions as witness data is discounted (only present when 'allowed' is true)
    "fees" : {                  (json object) Transaction fees (only present if 'allowed' is true)
      "base" : n                (numeric) transaction fee in BTC
    },
    "reject-reason" : "str"     (string) Rejection string (only present when 'allowed' is false)
  },
  ...
]
```

```bash
bitcoin-core.cli testmempoolaccept  '["02000000000101b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf0247304402205bbb9072a528cc8b59f984fc0da90dfa6f85f93c495d35c184ea412f592ec3a002205c7ebe99570b691a476286e31cf3c97ad605511f88cf7fdbcf4a077d18a0a8440121030dd902b1a6f9d4844a166d81ecbf8d25ba213772182f5bd37fad8c9ad6a5bbf800000000"]'
```

```
# 結果の例
[  {    "txid": "856fe6d990663065d548dec117013477e7558053070649ccaa4325f2df51f969",    "allowed": true,    "vsize": 141,    "fees": {    "base": 0.00001000    }  }]
```

メモリプール内のtxidを確 する

```
getrawmempool
```

結果

```
[           (json array)
  "hex",    (string) The transaction id
  ...
]
```

```
bitcoin-core.cli getrawmempool
```

```
# 結果の例
[
  "7cc3a14461355f012be7979ef5e7cbdda509790e2bba3826c4f0b13ab5be76a2",
  "eeadde892ada87f837f7f9160d25a6d61b17ee5b10a263f551feb89c69423613",
  "f1ee23e13b950ef03877a7c6dfdcf60348e98e2362e2c481334e03d6eeafa4fa",
  "c51f714f39b0941b5fbd24d66158616517499b99c52fe4236dcd168003bddff7",
  "43b8e90d25c03e115b43bfcf38c323a79be8ef0990b66196a28004adf8225ef6",
  "701f87223cfa3394801d7d8984bb5d651b48bfbf572af746d1cf8ff07ec515f5",
  "64d3d4ddbca3fd70df465136cf9241ef1c10df199db02d27b38ddf53086b08e8",
  "428590866563fc57d15d43a16442876031ed8a96495f71cfbe2dccec721276e0",
  "77a84ba3eb2010e3d8548a048ce1d050b14e0a41afac04ce720734fb3d121fdf",
  "2b7dc21a27133380ddc4d0d86d5490d52c2668b0851962b171e9d503d3fbbec6",
  "711e0445bff0d9a41d439ec2c88eb3e473ef4968e607882809485bfee0519cc3",
  "9844b12bbea871d9a82242fe7a66dd8c1ddada0c74d77b290b8aeb8d6c8158ba",
  "9d90e9ca270c317b23add12239f770ef47d55a5680daf148f2645e92192a11b6",
  "bfc640cc09840c85044c3692a6956a13b297fcaad68d22f5c1e9d34945a726b4",
  "1728d595c49e3ac479a317dc665b63e7e15f761cfeb6e3c7f22cf140cebe81a3",
  "448806b9e9409a5b51255158f03ff19ab0897cfa58ddc4d308daff86ebeccba1",
  "e96ecc836ea1fb0c788b0216ee9455946f688fbd0c9b24b8808facce32c20392",
  "af50f32472b2d9b12773a6d29a9ff861d93d15d1d6f9c18325dd0c6e6012a18d",
  "d19374e190b2908295674cdf4acc16cdd679e347b9f42338f78a19316bc3a687",
  "9c8e62f6703986c5e0e5ef93e54c562a8f88183d8e927f948ff66f552c3eba7c",
  "f782f6b6287e26acaf7b5e501295daf5b2271d73921e36588e45ba040381ab7c",
  "de1213fe625d360853ba8af0f8b5caac3111e3182c1147c8ee93652af1cdf775",
  "6be18b670305ec4ac592a65ef52eb39f9e93fe96033e70157a49b41057714f74",
  "e583fbccd508c110650c4c8062cfc9e281481ccd5a4d7e6d7dfd724e9857295e",
  "af0841defc307e72aa4b6ffd03cd4c0c0465cbe3339ab7237f997a232479d55c",
  "9e0393211e409f9980730d70a4910f1300cba8e1973436020cebed07250b245b",
  "a8d3430ea3cafdb169e211d2113517d5477f549d7f5b5b2a15a2cad9896c0e5b",
  "b3ba1de977c002dc23162894f5bd0b2a09292630a448fb41f6860705a455ba4f",
  "fcee10370271a6f4864d4331481fbfe71ce5a7102c94af3fb0eaeabd00332649",
  "9e72f22f04921cccc08fb4df12398ef2511d384d5400a0ba099c516c1a61e841",
  "818d026f1b0427e3a4cba3f573ad98374cd9ce4453e8fe50c85884ac358be241",
  "380be1f511b6470e1cc8012ccaed83f7df1f737d57d480203b480c1a3edb5f3d",
  "8dfe5284f8c9d2c675e79027dddbe190c1b86304f0a4cffc4bdf7e898975d539",
  "0eb5c1a4276ffc9a1a83204704c74ff921c17785f898775cc27f7eb4e5729a1e",
  "059621f875f13072fab2d7f5b8c3e1473837bf380704fc316528dc74cbd5061d",
  "157be3f5c890ac029f67cb43ac0bf9ba40182c8f0b97a07ec741eab1edadbd1c",
  "e12ff6b635275ada76133d21c98410677b506b993b8a6c21a5fef8772c26f314",
  "dcf0a6500303af729eb213ef0c5318feb411eab02d7d6c6381b1f0b69b6dc70e",
  "52f87afa63d9dd75c539cdfb92b9a556f77572129f3d38ecc7d1cd44db4c1c09"
]
```


### 5.6 ブロックチェーン

ブロック⾼

```
getblockcount
```

```
bitcoin-core.cli getblockcount
```

```
45140
```

ブロックハッシュ

```
getblockhash <ブロック⾼>
```



--
























# 課題

1. デフォルトのsignetに接続するBitcoin Core ノードを構築してください1. デフォルトのsignet のfaucet からテスト用のビットコインを入手し，トランザクションのライフサイクルに沿ってトランザクションの生成，署名，ブロードキャスト，検証を行ってみてください
3. bitcoin RPC のすべてのAPIの仕様を調べ，bitcoin-cli コマンドなどを使って機能を確認してください。

--

### 1. デフォルトのsignetに接続するBitcoin Core ノードを構築してください

#### 回答例

1章の課題６と同様です

[Bitcoin core Signet ノードの構築](https://github.com/ShigeichiroYamasaki/yamalabo/blob/master/bitcoin-core-signet.md)


```bash
$ bitcoin-cli getblockchaininfo
```

signetの場合，次のような情報が返ってきます。

```json
{
  "chain": "signet",
  "blocks": 45136,
  "headers": 45136,
  "bestblockhash": "00000115cd6741f9d566ea0e7e8189b46c2c79a4a313a5db799f86acf40d5c43",
  "difficulty": 0.002881346304279315,
  "mediantime": 1625408853,
  "verificationprogress": 0.9999975007304444,
  "initialblockdownload": false,
  "chainwork": "0000000000000000000000000000000000000000000000000000007f657fb454",
  "size_on_disk": 104217734,
  "pruned": false,
  "softforks": {
    "bip34": {
      "type": "buried",
      "active": true,
      "height": 1
    },
    "bip66": {
      "type": "buried",
      "active": true,
      "height": 1
    },
    "bip65": {
      "type": "buried",
      "active": true,
      "height": 1
    },
    "csv": {
      "type": "buried",
      "active": true,
      "height": 1
    },
    "segwit": {
      "type": "buried",
      "active": true,
      "height": 1
    },
    "taproot": {
      "type": "bip9",
      "bip9": {
        "status": "active",
        "start_time": -1,
        "timeout": 9223372036854775807,
        "since": 0,
        "min_activation_height": 0
      },
      "height": 0,
      "active": true
    }
  },
  "warnings": ""
}
```


### 2. デフォルトのsignet のfaucet からテスト用のビットコインを入手し，トランザクションのライフサイクルに沿ってトランザクションの生成，署名，ブロードキャスト，検証を行ってみてください

#### テスト用ビットコインの入手

signet のfaucet サイトで要求すると，無償でテスト用ビットコインを入手することができます。入手方法は，webページのフィールドに自分のワレットで生成した自分のビットコインアドレスを入れて request ボタンをクリックするだけです。

https://signet.bc-2.jp/

#### 自分のワレットの残高の確認

10分以上経過後に自分のワレットの残高を以下のようにして確認すると 10.0 BTC あるはずです。

* getbalance

ワレットにある所持金の合計金額		

```bash
$ bitcoin-cli  -rpcwallet=alice getbalance      
10.00000000
```

#### ビットコインアドレスを宛先にした送金

ためしにfaucetから得たコインを自分から自分宛に送金してみましょう。


* sendtoaddress <ビットコインアドレス> <金額>
 
ビットコインアドレス宛の送金

```bash
$ bitcoin-cli -rpcwallet=alice tb1qrh67zywp2fdhlwy5cus7h0xg3pfsm8cc0cqzej 2.1

fb0bcb881b7a60dfe5743a23bc7acc64b7286287978fc008fc2bdbe0cdef78c3
```

このコマンドの実行結果で返ってきた値は@トランザクションID@と呼ばれるトランザクションの識別子です。今後は txid と略記します。
10分以上経過後に自分のワレットの残高を確認してみてください。自分から自分に送金したので，残高は増減していないはずなのに少し減っていると思います。これは送金金額から手数料 (fee) が引かれたからです。

#### トランザクションの一覧の表示

自分が行ったトランザクションの一覧を見ることで自分が行った入出金の履歴を確認することができます。また送金に使用した手数料(fee) の金額を確認することもできます。また未使用のトランザクションの一覧を見ることもできます。

* listtransactions
 
自分が送受信したトランザクションの一覧

* listunspent

未使用のトランザクションの一覧



#### トランザクション

トランザクションのライフサイクル
1章で説明したようにビットコインの送金はトランザクションのライフサイクル（作成，署名，ブロードキャスト，検証，記録，承認）という経過を経て完了します。このトランザクションのライフサイクルを実際に確認してみましょう。

##### トランザクションの構造の確認

まず具体的なトランザクションの構造を調べてみます。トランザクションの構造を調べるためには bitcoin-cli の次のコマンドが役に立ちます。

* getrawtransaction <トランザクションID> 
トランザクションIDで指定されたトランザクションを16進数で返す
* decoderawtransaction <16進数形式のトランザクション> 	
16進数トランザクションの内容をJSON形式で表示する

次の例は1つのinput と2つのoutput を持つトランザクションです。

```json
{
  "txid": "962bd16cff0ab2320f362b58b35373b520291f99679733b503b28d82d2f45a9e",
  "hash": "6905826242d252f4d6f957aad9b88a4807f5e061e9bc8da61e73bd51a83119f7",
  "version": 2,
  "size": 222,
  "vsize": 141,
  "weight": 561,
  "locktime": 11178,
  "vin": [
    {
      "txid": "f410ef9fd65ba1199089597dcda413c2ab4f4be59c38ae1974a3a4e8f591e3cf",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "30440220247ecb1c8da1172c42ee89d01880c58d4777db9e58f29840bc05f70fbcda2c43022026d2317478d839d710b075bff031e9fdd6259c1ce9af2d366da08b8d4630e0a201",
        "03a93aaf2279328de94336d2d7a91b87d0c36806a5e0fcfd20a31b5fe1b89b2e42"
      ],
      "sequence": 4294967294
    }
  ],
  "vout": [
    {
      "value": 4.00000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 747fc3a6606d99b05ea3b962cdea9110b7b7dcfe",
        "hex": "0014747fc3a6606d99b05ea3b962cdea9110b7b7dcfe",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qw3lu8fnqdkvmqh4rh93vm653zzmm0h87m5ha6z"
        ]
      }
    },
    {
      "value": 1.99991540,
      "n": 1,
      "scriptPubKey": {
        "asm": "0 adcbeba6cb893b020b245ac8cb81a55db06c2489",
        "hex": "0014adcbeba6cb893b020b245ac8cb81a55db06c2489",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1q4h97hfkt3yasyzeyttyvhqd9tkcxcfyfuhjxey"
        ]
      }
    }
```

### UTXOの確認

上の例のトランザクションの  "vout":  の部分に "value": 4.00000000,　と  "value": 1.99991540, という金額を持つ２つのoutput がJSONの配列として表示されています。２つのoutputにはそれぞれ  "n": 0 と  "n": 1 というインデックスが付与されています。この２つのoutput が未使用状態のときUTXO，つまり自分が所持している資金（コイン）になります。
このUTXOの資金を次に送金する場合，送金するトランザクションのinput部でこのUTXOを参照します。参照の方法はトランザクションID (txid)とoutput部のインデックスです。
送金トランザクションの作成
それでは，このoutputを利用して送金するトランザクションを作成してみましょう。まず使用するUTXOとして上のトランザクションの "n": 1というインデックスを持つ "value": 1.99991540　を指定することにしましょう。トランザクションIDは， "txid": 　のところを見ると，962bd16cff0ab2320f362b58b35373b520291f99679733b503b28d82d2f45a9e　であることがわかります。この送金トランザクションのinputをJSON形式で作成すると，次のような文字列になります。

```json
'[{"txid":"962bd16cff0ab2320f362b58b35373b520291f99679733b503b28d82d2f45a9e","vout":1}]' 
```

次に送金トランザクションのoutput を作成します。"value": 1.99991540 のうち手数料(fee) を 0.00001540とすると，送金金額は 1.9999 ，送金先ビットコインアドレスを tb1qw3lu8fnqdkvmqh4rh93vm653zzmm0h87m5ha6z とします。すると送金トランザクションoutputをJSON形式で作成すると，次のような文字列になります。

```json
'{"tb1qw3lu8fnqdkvmqh4rh93vm653zzmm0h87m5ha6z":1.9999}'
```

トランザクションの作成は次のコマンドで実行できます。

```
createrawtransaction <inputのJSON形式> <outputのJSON形式>
```

	
トランザクションの作成

```bash
$  bitcoin-cli createrawtransaction '[{"txid":"962bd16cff0ab2320f362b58b35373b520291f99679733b503b28d82d2f45a9e","vout":1}]' '{"tb1qw3lu8fnqdkvmqh4rh93vm653zzmm0h87m5ha6z":1.9999}'

02000000019e5af4d2828db203b5339767991f2920b57353b3582b360f32b20aff6cd12b960100000000ffffffff01f09aeb0b00000000160014747fc3a6606d99b05ea3b962cdea9110b7b7dcfe00000000
```

作成したトランザクションをJSON形式で表示してみると予想どおりにできていることが確認できます。

```bash
$ bitcoin-cli decoderawtransaction 02000000019e5af4d2828db203b5339767991f2920b57353b3582b360f32b20aff6cd12b960100000000ffffffff01802b530b00000000160014747fc3a6606d99b05ea3b962cdea9110b7b7dcfe00000000
```

```json
{
  "txid": "99d6c4358e72316ae1916ed66547b7de53b331c99dbf483f1e3d33f8c166ab25",
  "hash": "99d6c4358e72316ae1916ed66547b7de53b331c99dbf483f1e3d33f8c166ab25",
  "version": 2,
  "size": 82,
  "vsize": 82,
  "weight": 328,
  "locktime": 0,
  "vin": [
    {
      "txid": "962bd16cff0ab2320f362b58b35373b520291f99679733b503b28d82d2f45a9e",
      "vout": 1,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 1.99990000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 747fc3a6606d99b05ea3b962cdea9110b7b7dcfe",
        "hex": "0014747fc3a6606d99b05ea3b962cdea9110b7b7dcfe",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qw3lu8fnqdkvmqh4rh93vm653zzmm0h87m5ha6z"
        ]
      }
    }
  ]
}
```

作成したトランザクションにデジタル署名する
次にこのトランザクションに対して自分の秘密鍵でデジタル署名を行いましょう。ワレットを暗号化している場合はこのコマンドを実行する前にパスフレーズで一定時間，ワレットの秘密鍵を復号化した状態にしておきます。

```
signrawtransactionwithwallet <トランザクションの16進数形式>
```

トランザクションの16進数形式にデジタル署名する

```bash

$ bitcoin-cli signrawtransactionwithwallet "02000000019e5af4d2828db203b5339767991f2920b57353b3582b360f32b20aff6cd12b960100000000ffffffff01802b530b00000000160014747fc3a6606d99b05ea3b962cdea9110b7b7dcfe00000000"
```

```json
{
  "hex": "020000000001019e5af4d2828db203b5339767991f2920b57353b3582b360f32b20aff6cd12b960100000000ffffffff01f09aeb0b00000000160014747fc3a6606d99b05ea3b962cdea9110b7b7dcfe0247304402207ce7455df96265b40c50136b7dc1b8ea887f9967e23ee9dd240eedef5975b8b502200283cf9e9e6008b589d49b50c2ab908c9ae77df8b770fa6f35887e81ef298ad7012103995ccce7d8c2a81b140f4b199c576c3ea59407e5ec863aca0cfa674a14932a1900000000",
  "complete": true
}
```

署名したトランザクションをJSON形式で表示してみると次のようになっています。 "txinwitness" という領域が増えていることがわかります。

```bash
$  bitcoin-cli decoderawtransaction "020000000001019e5af4d2828db203b5339767991f2920b57353b3582b360f32b20aff6cd12b960100000000ffffffff01f09aeb0b00000000160014747fc3a6606d99b05ea3b962cdea9110b7b7dcfe0247304402207ce7455df96265b40c50136b7dc1b8ea887f9967e23ee9dd240eedef5975b8b502200283cf9e9e6008b589d49b50c2ab908c9ae77df8b770fa6f35887e81ef298ad7012103995ccce7d8c2a81b140f4b199c576c3ea59407e5ec863aca0cfa674a14932a1900000000"
```
```json
{
  "txid": "99d6c4358e72316ae1916ed66547b7de53b331c99dbf483f1e3d33f8c166ab25",
  "hash": "b25c3043cfb2eb4e766d397f0ecf28ea9a8ff647d9f37746326e2bc21332d804",
  "version": 2,
  "size": 191,
  "vsize": 110,
  "weight": 437,
  "locktime": 0,
  "vin": [
    {
      "txid": "962bd16cff0ab2320f362b58b35373b520291f99679733b503b28d82d2f45a9e",
      "vout": 1,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "304402207ce7455df96265b40c50136b7dc1b8ea887f9967e23ee9dd240eedef5975b8b502200283cf9e9e6008b589d49b50c2ab908c9ae77df8b770fa6f35887e81ef298ad701",
        "03995ccce7d8c2a81b140f4b199c576c3ea59407e5ec863aca0cfa674a14932a19"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 1.99990000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 747fc3a6606d99b05ea3b962cdea9110b7b7dcfe",
        "hex": "0014747fc3a6606d99b05ea3b962cdea9110b7b7dcfe",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qw3lu8fnqdkvmqh4rh93vm653zzmm0h87m5ha6z"
        ]
      }
    }
  ]
}
```

完成したトランザクションをブロードキャストする
デジタル署名まで完了するとトランザクションとしては完成です。これをビットコインネットワークにブロードキャストし承認されてブロックに取り込まれると送金が完了します。

```
sendrawtransaction <16進数形式のトランザクション>
```

16進数形式のトランザクションをブロードキャストする

```bash
$ bitcoin-cli -datadir=signet sendrawtransaction "020000000001019e5af4d2828db203b5339767991f2920b57353b3582b360f32b20aff6cd12b960100000000ffffffff01f09aeb0b00000000160014747fc3a6606d99b05ea3b962cdea9110b7b7dcfe0247304402207ce7455df96265b40c50136b7dc1b8ea887f9967e23ee9dd240eedef5975b8b502200283cf9e9e6008b589d49b50c2ab908c9ae77df8b770fa6f35887e81ef298ad7012103995ccce7d8c2a81b140f4b199c576c3ea59407e5ec863aca0cfa674a14932a1900000000"

99d6c4358e72316ae1916ed66547b7de53b331c99dbf483f1e3d33f8c166ab25
```

10分以上経過後にトランザクション一覧や未使用トランザクション一覧などを行うと送金が確認できるはずです。

## 3. bitcoin RPC のすべてのAPIの仕様を調べ，bitcoin-cli コマンドなどを使って機能を確認してください。


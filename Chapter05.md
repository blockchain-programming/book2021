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
                                   addr (responses to getADDR avoid hitting the cache and contain random records with the most up-to-date info).

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
# 実行例
bitcoin-core.cli createwallet alice 


{
  "name": "alice",
  "warning": ""
}
```

#### ワレットの一覧

```bash
# 実行例
bitcoin-core.cli listwallets


[
  "alice"
]
```

#### ビットコインアドレスの生成

```bash
# 実行例
bitcoin-core.cli getnewaddress


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
# 実行例
bitcoin-core.cli getaddressinfo tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4  


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
# 実行例
bitcoin-core.cli dumpprivkey tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4


cPdid5XEhWiRps3XXLMh6q9ehxPenJ7NqfUpBsj4US7jnYW2QM4m
```

### テスト用のビットコインの入手方法


Signet Faucetに自分のビットコインアドレスと入手希望金額を入力する

* 自分のアドレス：tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4
* 送金金額：0.1 btc

[https://signet.bc-2.jp/](https://signet.bc-2.jp/)

10分以上送金完了を待つ

### 自分のワレットのビットコインの残高の確認

```bash
# 実行例
bitcoin-core.cli getbalance


#成功していれば，次のような値が返ってくる
0.10000000
```

### ビットコインアドレスを宛先にした送金

```
sendtoaddress <ビットコインアドレス> <⾦額>
```

新しいビットコインアドレスを生成する

```bash
# 実行例
bitcoin-core.cli getnewaddress


# 生成されたアドレスの例￼
tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4  
```

* 送金先アドレス：tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4
* 送金金額：0.01

```bash
# 実行例
bitcoin-core.cli sendtoaddress tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4 0.01


# 送金に使用されたトランザクションのトランザクションID
50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5
```

### トランザクションの一覧の表示

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
# 実行例
bitcoin-core.cli listtransactions


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

### UTXO (未使用のアウトプット)の一覧

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
# 実行例
bitcoin-core.cli listunspent


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

## 5.5 トランザクション


#### トランザクションのデータを検索する

bitcoin.conf の設定で　txindex=1 を設定しているときには，自分のワレットに無いトランザクションも検索可能です。

```
 getrawtransaction <txid> (<true/false>)
```

結果

```
# オプションがfalseのとき（デフォルト）

トランザクションデータの16進数文字列
```


```
# オプションがtrue のとき
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

#### UTXO１のトランザクション（この例ではUTXO２も同一トランザクション）

```bash
bitcoin-core.cli getrawtransaction 50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5
```

getrawtransaction 044e1965b61d8a895fbcec7aeb9606add1564cc03c9403a9076ea901ecdc66da

```bash
# 結果の例
02000000000101bb443e3199657c40d0368bc049c3f7f1ef9b85ad68903eb31c00cd87ceece2060000000000feffffff028a53890000000000160014b579af8fa7108bf66c50211bfbc84e9ef82b6c9f40420f00000000001600144b77cbf6d5ade3db05ed368140048be2fbace8e70247304402205038e35f279ae6739518081891d5b665aa701b76114381948d6a6a3dd5023bef022001fa27f369760adba983252f3d25f45d577884a4ea448a18d799f73df3e4063501210336c2710513b6182697a2b9ce8e6f6e8dae2b568ac32b27b45f142a2b6697005c45b00000
```

#### 16進数形式のトランザクションの構造をJSON形式で表示する

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
# 実行例
bitcoin-core.cli  decoderawtransaction 02000000000101bb443e3199657c40d0368bc049c3f7f1ef9b85ad68903eb31c00cd87ceece2060000000000feffffff028a53890000000000160014b579af8fa7108bf66c50211bfbc84e9ef82b6c9f40420f00000000001600144b77cbf6d5ade3db05ed368140048be2fbace8e70247304402205038e35f279ae6739518081891d5b665aa701b76114381948d6a6a3dd5023bef022001fa27f369760adba983252f3d25f45d577884a4ea448a18d799f73df3e4063501210336c2710513b6182697a2b9ce8e6f6e8dae2b568ac32b27b45f142a2b6697005c45b00000


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

#### UTXOを使ったトランザクションのinputの作成

* UTXO１
    * トランザクションID：50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5
    * 金額：0.08999818
    * アウトプットのインデックス（vout）：0

    
#### トランザクションの output の作成

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


### 未署名のトランザクションの作成

```
createrawtransaction <inputのJSON形式> <outputのJSON形式>
```

#### inputのJSON形式

```
[
  {                       (json object)
    "txid": "hex",        (string, required) The transaction id
    "vout": n,            (numeric, required) The output number
    "sequence": n,        (numeric, optional, default=depends on the value of the 'replaceable' and 'locktime' arguments) The sequence number
  },
  ...
]
```

#### outputのJSON形式

```
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

作成するトランザクションの　input(UTXO)　のJSON形式の例


```json
'[{"txid":"50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5","vout":0}]' 
```

output のJSON形式の例

```json
'[{"tb1qj0596apwztduay0ktk6lnhxxcumfz6mnnsykm3":0.001}, {"tb1qc0xxe80njvjxdf26prp2gluth0ge3840dvensy":0.08898818}]'
```

#### 未署名のトランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5","vout":0}]' '[{"tb1qj0596apwztduay0ktk6lnhxxcumfz6mnnsykm3":0.001}, {"tb1qc0xxe80njvjxdf26prp2gluth0ge3840dvensy":0.08898818}]'
```

```bash
# 実行例
0200000001b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf00000000
```

#### 作成した未署名トランザクションの確認

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


### トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```
signrawtransactionwithwallet <未署名トランザクションの16進数形式>
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
# 実行例
bitcoin-core.cli signrawtransactionwithwallet 0200000001b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf00000000


{
  "hex": "02000000000101b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf0247304402205bbb9072a528cc8b59f984fc0da90dfa6f85f93c495d35c184ea412f592ec3a002205c7ebe99570b691a476286e31cf3c97ad605511f88cf7fdbcf4a077d18a0a8440121030dd902b1a6f9d4844a166d81ecbf8d25ba213772182f5bd37fad8c9ad6a5bbf800000000",
  "complete": true
}
```

#### hex 部分をJSON形式でデコードしてみる

```bash
# 実行例
bitcoin-core.cli decoderawtransaction  02000000000101b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf0247304402205bbb9072a528cc8b59f984fc0da90dfa6f85f93c495d35c184ea412f592ec3a002205c7ebe99570b691a476286e31cf3c97ad605511f88cf7fdbcf4a077d18a0a8440121030dd902b1a6f9d4844a166d81ecbf8d25ba213772182f5bd37fad8c9ad6a5bbf800000000


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



### トランザクションのブロードキャスト

```
sendrawtransaction <16進数形式のトランザクション>
```

結果

```
hex string The transaction hash in hex
```

```
# 実行例
bitcoin-core.cli sendrawtransaction 02000000000101b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf0247304402205bbb9072a528cc8b59f984fc0da90dfa6f85f93c495d35c184ea412f592ec3a002205c7ebe99570b691a476286e31cf3c97ad605511f88cf7fdbcf4a077d18a0a8440121030dd902b1a6f9d4844a166d81ecbf8d25ba213772182f5bd37fad8c9ad6a5bbf800000000


a017b4f40f002e46a8bdc0749d8b4bf95e347f47f0341e08b89b5f14d18280fc
```

### トランザクションの検証

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
# 実行例
bitcoin-core.cli testmempoolaccept  '["02000000000101b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf0247304402205bbb9072a528cc8b59f984fc0da90dfa6f85f93c495d35c184ea412f592ec3a002205c7ebe99570b691a476286e31cf3c97ad605511f88cf7fdbcf4a077d18a0a8440121030dd902b1a6f9d4844a166d81ecbf8d25ba213772182f5bd37fad8c9ad6a5bbf800000000"]'


[  {    "txid": "856fe6d990663065d548dec117013477e7558053070649ccaa4325f2df51f969",    "allowed": true,    "vsize": 141,    "fees": {    "base": 0.00001000    }  }]
```

#### メモリプール内のtxidを確認する

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
# 実行例
bitcoin-core.cli getrawmempool


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


## 5.6 ブロックチェーン

### ブロックチェーンの構造

ブロック⾼

```
getblockcount
```

```
# 実行例
bitcoin-core.cli getblockcount

45140
```

#### ブロックハッシュ

```
getblockhash <ブロック⾼>
```

```
# 実行例
bitcoin-core.cli getblockhash 45140

00000114208c2281068d15a10b266dd49a4d723c797101a3f5decef1f6c5977e

# 実行例
bitcoin-core.cli getblockhash 0

00000008819873e925422c1ff0f99f7cc9bbb232af63a077a480a3633bee1ef6

# 実行例
bitcoin-core.cli getblockhash 1000

0000010ebfa3c6193793701c198392e21bdb8bc9fb2032f0d74a628d36e9a75e

# 実行例
bitcoin-core.cli getblockhash 1001

00000203b537056a20c93d7b43cff2dffb977e96267766f458acc66b581e5d2c
```

どのブロックハッシュも複数の0 で始まっていることに注意してください。

#### ブロックヘッダ

```
getblockheader <ブロックハッシュ>
```

```
{                                 (json object)
  "hash" : "hex",                 (string) the block hash (same as provided)
  "confirmations" : n,            (numeric) The number of confirmations, or -1 if the block is not on the main chain
  "height" : n,                   (numeric) The block height or index
  "version" : n,                  (numeric) The block version
  "versionHex" : "hex",           (string) The block version formatted in hexadecimal
  "merkleroot" : "hex",           (string) The merkle root
  "time" : xxx,                   (numeric) The block time expressed in UNIX epoch time
  "mediantime" : xxx,             (numeric) The median block time expressed in UNIX epoch time
  "nonce" : n,                    (numeric) The nonce
  "bits" : "hex",                 (string) The bits
  "difficulty" : n,               (numeric) The difficulty
  "chainwork" : "hex",            (string) Expected number of hashes required to produce the current chain
  "nTx" : n,                      (numeric) The number of transactions in the block
  "previousblockhash" : "hex",    (string) The hash of the previous block
  "nextblockhash" : "hex"         (string) The hash of the next block
}
```

```bash
# 実行例 (ブロック高1000)
bitcoin-core.cli getblockheader 0000010ebfa3c6193793701c198392e21bdb8bc9fb2032f0d74a628d36e9a75e

{
  "hash": "0000010ebfa3c6193793701c198392e21bdb8bc9fb2032f0d74a628d36e9a75e",
  "confirmations": 44189,
  "height": 1000,
  "version": 536870912,
  "versionHex": "20000000",
  "merkleroot": "436bcf79ac698ba221f2f67ed7c9e42c5ddb6fb8b5f6f6322491f45bd08d8c97",
  "time": 1599132457,
  "mediantime": 1599131361,
  "nonce": 190116,
  "bits": "1e0377ae",
  "difficulty": 0.001126515290698186,
  "chainwork": "0000000000000000000000000000000000000000000000000000000120ae4234",
  "nTx": 1,
  "previousblockhash": "000002adbe0fa5467506fdde47518fe75d65dc1eac5b150e00856f1706850627",
  "nextblockhash": "00000203b537056a20c93d7b43cff2dffb977e96267766f458acc66b581e5d2c"
}

# 実行例 (ブロック高1001)
bitcoin-core.cli getblockheader 00000203b537056a20c93d7b43cff2dffb977e96267766f458acc66b581e5d2c

{
  "hash": "00000203b537056a20c93d7b43cff2dffb977e96267766f458acc66b581e5d2c",
  "confirmations": 44188,
  "height": 1001,
  "version": 536870912,
  "versionHex": "20000000",
  "merkleroot": "96d7fad27e531a099ed0c813e2e7f0e00e6e0484ee21f89d2657befdcaf3e9d4",
  "time": 1599132465,
  "mediantime": 1599131457,
  "nonce": 8821577,
  "bits": "1e0377ae",
  "difficulty": 0.001126515290698186,
  "chainwork": "0000000000000000000000000000000000000000000000000000000120f81648",
  "nTx": 1,
  "previousblockhash": "0000010ebfa3c6193793701c198392e21bdb8bc9fb2032f0d74a628d36e9a75e",
  "nextblockhash": "000002e1d2d6a4992d5aae0afa452d8ffeb3cc4488c220560fa06234b8fb13e8"
}

```

 "previousblockhash" の値が，ブロック高1000のブロックハッシュと一致していることを確認してください。

### ブロック全体の情報

```
getblock <ブロックハッシュ>
```

```
{                                 (json object)
  "hash" : "hex",                 (string) the block hash (same as provided)
  "confirmations" : n,            (numeric) The number of confirmations, or -1 if the block is not on the main chain
  "size" : n,                     (numeric) The block size
  "strippedsize" : n,             (numeric) The block size excluding witness data
  "weight" : n,                   (numeric) The block weight as defined in BIP 141
  "height" : n,                   (numeric) The block height or index
  "version" : n,                  (numeric) The block version
  "versionHex" : "hex",           (string) The block version formatted in hexadecimal
  "merkleroot" : "hex",           (string) The merkle root
  "tx" : [                        (json array) The transaction ids
    "hex",                        (string) The transaction id
    ...
  ],
  "time" : xxx,                   (numeric) The block time expressed in UNIX epoch time
  "mediantime" : xxx,             (numeric) The median block time expressed in UNIX epoch time
  "nonce" : n,                    (numeric) The nonce
  "bits" : "hex",                 (string) The bits
  "difficulty" : n,               (numeric) The difficulty
  "chainwork" : "hex",            (string) Expected number of hashes required to produce the chain up to this block (in hex)
  "nTx" : n,                      (numeric) The number of transactions in the block
  "previousblockhash" : "hex",    (string) The hash of the previous block
  "nextblockhash" : "hex"         (string) The hash of the next block
}
```


```bash
# 実行例
bitcoin-core.cli getblock 00000114208c2281068d15a10b266dd49a4d723c797101a3f5decef1f6c5977e

{
  "hash": "00000114208c2281068d15a10b266dd49a4d723c797101a3f5decef1f6c5977e",
  "confirmations": 48,
  "strippedsize": 709,
  "size": 973,
  "weight": 3100,
  "height": 45140,
  "version": 536870912,
  "versionHex": "20000000",
  "merkleroot": "4b23ac44bf5c4b37f990f5e02e5fb0c4f13a7e3f70b3e484f46866aa3b47f77c",
  "tx": [
    "747b2a9e6cb18b8fbabe3dc335b4d325e5cf14f2d163f170342583a22ebfd002",
    "72e1e1fab2dac6b602f6efe93ce244c8cd49f7c39643015db51987e630a70424",
    "0e5c4e88960afb07ae0fa0a349c55500ebf0929e4e22e7e901007def2285c944",
    "4e11d01a69fba6637485b08ac933b0fa511b4407092bb66a66fc58f49f4c0d07",
    "83540e22fdbe52b0ac9f764b1877c55ee082a90a14536526f498ef83b5b286f4"
  ],
  "time": 1625414501,
  "mediantime": 1625411439,
  "nonce": 16011182,
  "bits": "1e015b0e",
  "difficulty": 0.002881346304279315,
  "chainwork": "0000000000000000000000000000000000000000000000000000007f68730b24",
  "nTx": 5,
  "previousblockhash": "000000e114a7a3043c9e19fcc0fa1ce8a445085cb8f3e83759d7ce7214155e33",
  "nextblockhash": "00000023d235a8e8911b6bfc084a0be9e86cf4b030e2ba3a127efa642b5d7bf9"
}
```


### プルーフ・オブ・ワークによるマイニング

ブロックのマイニングは次のコマンドで実行できますが，signet はマイニングの成功だけではブロック生成の権限がないので失敗してしまいます。実験するなら regtest モードでノードを起動しましょう。


#### bitcoind を再起動

```bash
# bitcoind を停止
bitcoin-core.cli stop
```
(snap の場合，cd ~/snap/bitcoin-core/common/.bitcoin/)
regtest用の　bitcoin.conf を作成（signetの設定ファイルも別名で保管しておく）

bitcoin.conf
```
regtest=1
```

```
# bitcoind を regtestモードで再起動
bitcoin-core.daemon &
```


#### マイニング

```
generatetoaddress <マイングするブロック数> <ビットコインアドレス> <最大試行回数>
```

結果

```
[           (json array) hashes of blocks generated
  "hex",    (string) blockhash
  ...
]
```

```
# 実行例
## ワレット作成
bitcoin-core.cli createwallet alice 

## アドレス生成
bitcoin-core.cli getnewaddress
## マイニング 101ブロック
bcrt1qvye3q7thzws8wg5efktavumx4k2pr4evy5rw5a

bitcoin-core.cli generatetoaddress 101 bcrt1qvye3q7thzws8wg5efktavumx4k2pr4evy5rw5a 10000000

[
  "480d8422ba7c51047424802fbaa817bc4bf187960f99517b2ba2bd1ee56cd928",
  "166fe030cf46378f27649251b32560670485e3502dba8dc21d3e79c7486dd589",
  "1fab94c43db18619b600c82fde57428a474a5d16b464d30b1dc7a3a8d06883e1",
  "6b9d04672d49fd6744185077c4047d74899b402a6312baf147ace0eb98e7aed9",
  "7d7e9091b6258f5f299a5b1e79016a48b985a6baec0c30fe2dc211b3704e22d4",
  "7325f79f170d7e3c8c40f7cc80bee1870523f94344220556d526a08bee7571f0",
  "1c4a96416ae49da9ab7df6229fad3c821e483ae0c952d04353e4eaecc9d249e1",
  "0691b1da1a4399722d25b35289876e7ef7517f432ea0417fe4e14fe9ce12a279",
  "07bb60a379cb99c89147a4924ded9d349aa1f9b5290cb6aa41139e2fb016cf19",
  "116c173e2017b40d1c3c3de6729162eea2064a9221f06a9ebc2f7a21cfca4dba",
  "449569088c13620501a5ac494cee94a9a98a4042b755a336cae4ff631ce51455",
  "5cc0af37d31a8583c316f0244999b7009f2b1dfe9bd0790273d06abda1e70f75",
  "110bdf99e8be6deb549f313f108e53fb7c669df3609cf89661c8ab4317fdd95b",
  "78da9250c08550ebc520b2102684811b567dd32ef2afdc477b99d380745c29f6",
  "781781bba9332121fd6c6faa6423158cda141746ccc31923a1bf84f752293b62",
  "31d7037c44b4115f2d155dc9f2c2ca43d94641a1384d28bb6bddfaf2778cbb1c",
  "3be318d0f04dbf8a86cb504688fb9131cff869b46463dce5471b034f12dfb019",
  "5e9fcad347788d47763f282c738b4c98a8a5fe55c34ea131f613d94ea970ae24",
  "1150e332aef8db38a2f68776bb61931a9420a3939815db5e33c2eebab0bee167",
  "79fc78c1cddcf36f23081af99e4537fb43c8de5bb6922207fc7a73ebbda7b1f4",
  "57b4efb1228270c4758011d9d00e6320773d4a0845c79c2f5783fbc0de247b0f",
  "269077d5802057b18a08e65cbc889561cb5cd314f8e50afd2f6fa1738c34de42",
  "2356adafe8e49e12cf282eb3c3afe359ebe86e4dde66370e83427f0d7ab39fd6",
  "2141c3c766cc160e8fa8c28a7b7311f0b53d8b84cf9df0d2d617078ba646c020",
  "668c7d810fd54883447f0d4050a3a0c69bb85be08d873476ebcb78ffb289954a",
  "057c4d42e4e278cb4c04d499ed9658b8e47524013150d3df245beb4bbddf3535",
  "2ae8f9d56d64aecc21198f2144021cb578eeadd0dfcd82d7906f0cf685c5f249",
  "32ed62855a1a128f4673c36c0d564bba879d0d9458a4ca07b8dec7bce3716523",
  "4de46c86ccb4a12fcb6cbcdaa9da3c2ebff912430815cc8f7659009c8d267fd0",
  "5a0b851a67265460498b57f68d3f2a74b1fb9eb23e768c7c5ce274c706e3a2ad",
  "6700a020026fb62437d3f279ff2e1d7eb41d7602cda2fe391ab0019c6016da55",
  "29b98cc2814139ac46de32a3c231677f5c507f822ca448956cb041d7ab951db6",
  "37b9df77f7c9733311df94f0935e2e07847122e15b75342e96e8612b2e1597a3",
  "7a560d58d8f0e7089cebdb9f071c97eb138392dfebf82c3999d369a0f89ea87d",
  "645f10295f699b0a499924bdfd30a10ac9aaf4859e631f6e1f54a53cd357d11a",
  "10fa7bc3af6d6e5af9ccbe1166f500538a913cf40e0462a6444db2c7e6888b3e",
  "13beeb368aa2d0a29a73f0bfb55e92c84214b036b5a052b0cff35cb8ec307a4c",
  "6f73b1446fd0119a0b6b1c13480bd03d8ee6bd5f7834a6058e8b4ca566627fac",
  "206d8634f0f361474f79ce4c352e68badeaa2a9bc04d6285c1a5b9a99091a937",
  "1a9ae87561b5a731af7d090088743e5af1459aa1ea302870688da889abbe8f0c",
  "4a6eb0fff7d887c5d0abb52a7bf2ae0414fb222aa12dca6931c0c970359ca0cf",
  "1db6c9df9356eb0fedf6b7bc6d46a840a63ba7bfc72d0ea1557f3e26e50c1461",
  "6d5125fdff9fbf4e074e6501e19b6b969de138b53b27d11bf659dfdb69a1e6b0",
  "528e509c768f7a9bf2adf238a6d8fb32f2f61fc478e32b296c6fd97561e43f46",
  "1260728f3a333e1c684ce9924280a97f29b99b51c3c3cbe7dd3a30f4df1c4824",
  "11644cc7907073814586d8baf8b43ebdd32bdc7650f6d5e9d352c8ef47d2259f",
  "1b22bac44794bc7db509dcd2df77b339107edbf319c6e54035c9dbf598b578fa",
  "1ebe8224cf7ebc695e3b92a0401e4848d13b54c8991e2203a4a447c459f17699",
  "2177dce23e210f584e005501dd1b36d25ec5d188399f05cf2113bede1a25d339",
  "50a9c9b8ea1f48a722207110e287b19b1351a6b44dff0db075044853e3ccc03a",
  "6406f45010c627774611787a0ef1e1243b2bd94f13f415d20bcbeeee8927ba19",
  "20d13c92cc91d3d9ddfc359f08ed759474364b367e861f44e2b3f977e52d7806",
  "094bec495fd7d4311643cd434e26fb7dfeebfdf17ea680ace63e49e8ba2079a7",
  "6ee7cc799e693f31a00e90f22f88a0f1408c07aea065668a8b42aa57a5123bc6",
  "1dc7aa38fd2fbf97d7dcb570900768afb20375988ad0c6e9a6b1d60174096b24",
  "294d59accd00609c51e8efa640c01b58d446f4358439f124845e684b8cb22dc6",
  "441638cde32567a0aa7031741429f2d56ffe03a871449596c57e51460e1b57cc",
  "69e53e7bd3d7ac16e5cb9e2c6ef68f319d612509084f4ad73f1d04443550cd4c",
  "697220e576dc698b477236d24c0001e751e960786eb8be45bb2febdcd44c729a",
  "5f95c6a6eba9bc309f45a51eb685a2f5826b41dba0f9bebbb19fdab52523437f",
  "2ba208fa54a7461daac1154d1c584348a0534577256fb93fab028e29f7be0632",
  "36624e5227ff5dec1373206b9693b56ea3743fb9ae33f8aa01aeb8cf08af30ba",
  "4fafc247a3970e53875453ee3f1418ac2b652702d804ba7c91b20733f290630f",
  "2ce51b53b38597c3bca3000ad00ce8dbb6e7fa429e50870b137ea1ba8fae34e8",
  "1f730a2fd9e89d745659fa53e724f55458d301b121f1ac17e0308ae079e91a76",
  "07909d746b1b6097b8b6b57af1dcd5470fd611ea86e8e2948071a695d7a5ca29",
  "2a8e7fe7df87a406aa5eb97aec876cb037e9ac60a6542df1e797cefd366e98cc",
  "5bd79e2d6f38c951f8c8b7d608ea2b56c541239d7b7141f2b35066ff3ef2635c",
  "1f97c435757f73ab5614542df315b8d33cebd8766b6209159974798e7679dc1d",
  "003e740439085f14863cb42460d7dcb08a04c4d7e8753985d6772d15b247193e",
  "045a10c4db6cc7042ade836f79a32b4e35cb8faf71ce60c7bd4e902979bac879",
  "50a325d4da5a8b12c786657515b0d1b26d36319b0bc719049775556dccfb5d2f",
  "753dd6e5a1cb8869d98443eb2dd3c6ed352565dc187bd4c20b5d0c27510be8f8",
  "2cad7cbcfd6063ff6b0e114dc8e076ef9d2af50f995bca6e8f2442474399caa6",
  "65e57a9a1c3c9ba53591dcecf6ad5aa45c1344efd699e48815a1dd510ccfecc2",
  "2bbab5c565e56b093cd527b4e3c15ea6eee99dd9cb95dcc6bb929e851bac79ab",
  "27a40af633bc3c3ea73e3a34b364d04c500a3d7bd3202607697c4d07b29735af",
  "7c2590b4236d60cff67a5128a9b4b0db73a2de764565274d2858f4011c0d772c",
  "2aaa505b7c3d14d8f87836e72d7f1208c07b52e0f4142b2db29cb69594c791e1",
  "4033db8404f283e4a026456daedc32c0f778a34f83ce166b898777f2b320ff1c",
  "4b6072e0178d3c735e7e224c12a0b6d1e319c51107a0400dca39c179aae651f2",
  "2666676428c2087207b2691d21bcb41439b26ace694d0fcda793feedeb6157b0",
  "3c9e16e7c08341909d250ff56efbef2ee662853af65ae1b3c319a7dd984cdb60",
  "79a6f32143357612139f68f8798fefe2b097ee121e65bcf00cf181fa27e3a425",
  "5df096824361b31c4fa14e837fbfaf90d8f3e83c76b2b63773807dba95e5ff36",
  "4bc77ebe46637913269860e90fb08d3d909b5eb3c5c14c7ad824c4c69af37419",
  "7c770a321968bc19798d9846d51170d53a231eba741e2e319b1c6bfe67ddee72",
  "68a4eff5112606457880b2284edd7a9b081467b8862be1b99264453e1809bd6e",
  "00524089052fd11af892ae8cebfcb9ea657488a6dd1558d006d29a9362d2a90d",
  "49170574bc332aa79b48c68c3208f9fdfd7f8199b4f2130a5733ab529b9646c0",
  "0522a00834086eb9c425f07f4dc6d682233814e9a2abfd630a46844f23f73e74",
  "488b851353a509e3a639ff3d368a7bdd95caeb8bec37fec20e159174b235927c",
  "1e67d0925391f59a7293f855f24c42ca1113cb3ac29d998e28a8229996e12dc9",
  "7546847f2139de7e2a3dfe000bf717ef3132e0c336e69389f15e57a5a1136aed",
  "5f1b582fed45bc70b4899d586d3e1a66d8ce80ecfc7fb73cbd51c6b7151a714d",
  "74a17b82b2fc99fc2c7292abc92ce2d3faff7e627619c2f4c3ce72a46033b162",
  "705103075f0821021522e6c21427b5619a7451c780080dfa48e2784124349a26",
  "48c1dd852181462227551e17c36024291cef088580e76ae18b85628cfc9d6a72",
  "5f8e404b25f2f40f83b011c0481fd004756c09d3e12a4864f25240f138c49267",
  "6ca86380318ddeef1f31c43f82a252ff91bb37a5edaf8d30c57e76692c49bfd2",
  "79afcb1da06ed31b49fa7ebaf00ee37f3647af559a2b3089940772db13f988e1"
]
```

#### マイニング結果の確認

```bash
# 自分の所持金を確認
bitcoin-core.cli getbalance

50.00000000
```

### signetに環境を戻す

bitcoind を再起動

```bash
# bitcoind を停止
bitcoin-core.cli stop
```

signet用の　bitcoin.conf に戻す（別名で保管から復元）
(snap の場合，cd ~/snap/bitcoin-core/common/.bitcoin/)

bitcoin.conf
```
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

```
# bitcoind を regtestモードで再起動
bitcoin-core.daemon &
```

--


# 課題

1. デフォルトのsignetに接続するBitcoin Core ノードを構築してください1. デフォルトのsignet のfaucet からテスト用のビットコインを入手し，トランザクションのライフサイクルに沿ってトランザクションの生成，署名，ブロードキャスト，検証を行ってみてください
3. bitcoin RPC のすべてのAPIの仕様を調べ，bitcoin-cli コマンドなどを使って機能を確認してください。

--

## 1. デフォルトのsignetに接続するBitcoin Core ノードを構築してください

本章 5.2 参照


## 2. デフォルトのsignet のfaucet からテスト用のビットコインを入手し，トランザクションのライフサイクルに沿ってトランザクションの生成，署名，ブロードキャスト，検証を行ってみてください

本章　5.3, 5.4, 5.4, 5.5 参照

## 3. bitcoin RPC のすべてのAPIの仕様を調べ，bitcoin-cli コマンドなどを使って機能を確認してください。

[RPC API Reference](https://developer.bitcoin.org/reference/rpc/)

--

# 付録

## bitcoinrb の使い方

bitcoinrb はRuby言語によるbitcoin core API をRuby から操作するライブラリです。

[bitcoinrb のインストール方法](https://github.com/ShigeichiroYamasaki/yamalabo/blob/master/bitcoinrb.md)

bitcoinrb の基本操作を習得しておいてください。

### ビットコインスクリプト

bitcoinrb

```ruby
require 'bitcoin'

script="2 3 OP_ADD 5 OP_EQUAL"
s=Bitcoin::Script.from_string(script)
s.run
=> true

txid="50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5"
script="#{txid} OP_HASH160"
s=Bitcoin::Script.from_string(script)
s.debug
```

### トランザクション作成

#### 自分が所持しているUTXOを確認する

送金に使用するTXIDとvout を確認します。

```json
 bitcoin-core.cli listunspent
 
[ {
    "txid": "50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5",
    "vout": 1,
    "address": "tb1qfdmuhak44h3akp0dx6q5qpytuta6e6888mjlw4",
    "label": "",
    "scriptPubKey": "00144b77cbf6d5ade3db05ed368140048be2fbace8e7",
    "amount": 0.01000000,
    "confirmations": 712,
    "spendable": true,
    "solvable": true,
    "desc": "wpkh([bc02bd98/0'/0'/0']0336c2710513b6182697a2b9ce8e6f6e8dae2b568ac32b27b45f142a2b6697005c)#z4fmc5jj",
    "safe": true
  }
  ]
```

bitcoinrb でsignet のbitcoin core RPC API を利用します。

```ruby
require 'bitcoin'
Bitcoin.chain_params = :signet

require 'net/http'
require 'json'
RPCUSER="hoge"
RPCPASSWORD="hoge"
HOST="localhost"
PORT=38332
 
def bitcoinRPC(method, params)
 	http = Net::HTTP.new(HOST, PORT)
 	request = Net::HTTP::Post.new('/')
 	request.basic_auth(RPCUSER, RPCPASSWORD)
 	request.content_type = 'application/json'
 	request.body = { method: method, params: params, id: 'jsonrpc' }.to_json
 	JSON.parse(http.request(request).body)["result"]
end
```


```ruby
tx = Bitcoin::Tx.new

```

----

## bitcoin RPC API

* Blockchain RPCs
    * getbestblockhash
    * getblock
    * getblockchaininfo
    * getblockcount
    * getblockfilter
    * getblockhash
    * getblockheader
    * getblockstats
    * getchaintips
    * getchaintxstats
    * getdifficulty
    * getmempoolancestors
    * getmempooldescendants
    * getmempoolentry
    * getmempoolinfo
    * getrawmempool
    * gettxout
    * gettxoutproof
    * gettxoutsetinfo
    * preciousblock
    * pruneblockchain
    * savemempool
    * scantxoutset
    * verifychain
    * verifytxoutproof

* Control RPCs
    * getmemoryinfo
    * getrpcinfo
    * help
    * logging
    * stop
    * uptime

* Generating RPCs
    * generateblock
    * generatetoaddress
    * generatetodescriptor

* Mining RPCs
    * getblocktemplate
    * getmininginfo
    * getnetworkhashps
    * prioritisetransaction
    * submitblock
    * submitheader

* Network RPCs
    * addnode
    * clearbanned
    * disconnectnode
    * getaddednodeinfo
    * getconnectioncount
    * getnettotals
    * getnetworkinfo
    * getnodeaddresses
    * getpeerinfo
    * listbanned
    * ping
    * setban
    * setnetworkactive

* Rawtransactions RPCs
    * analyzepsbt
    * combinepsbt
    * combinerawtransaction
    * converttopsbt
    * createpsbt
    * createrawtransaction
    * decodepsbt
    * decoderawtransaction
    * decodescript
    * finalizepsbt
    * fundrawtransaction
    * getrawtransaction
    * joinpsbts
    * sendrawtransaction
    * signrawtransactionwithkey
    * testmempoolaccept
    * utxoupdatepsbt

* Util RPCs
    * createmultisig
    * deriveaddresses
    * estimatesmartfee
    * getdescriptorinfo
    * getindexinfo
    * signmessagewithprivkey
    * validateaddress
    * verifymessage

* Wallet RPCs
(Note: the wallet RPCs are only available if Bitcoin Core was built with wallet support, which is the default.)
    * abandontransaction
    * abortrescan
    * addmultisigaddress
    * backupwallet
    * bumpfee
    * createwallet
    * dumpprivkey
    * dumpwallet
    * encryptwallet
    * getaddressesbylabel
    * getaddressinfo
    * getbalance
    * getbalances
    * getnewaddress
    * getrawchangeaddress
    * getreceivedbyaddress
    * getreceivedbylabel
    * gettransaction
    * getunconfirmedbalance
    * getwalletinfo
    * importaddress
    * importdescriptors
    * importmulti
    * importprivkey
    * importprunedfunds
    * importpubkey
    * importwallet
    * keypoolrefill
    * listaddressgroupings
    * listlabels
    * listlockunspent
    * listreceivedbyaddress
    * listreceivedbylabel
    * listsinceblock
    * listtransactions
    * listunspent
    * listwalletdir
    * listwallets
    * loadwallet
    * lockunspent
    * psbtbumpfee
    * removeprunedfunds
    * rescanblockchain
    * send
    * sendmany
    * sendtoaddress
    * sethdseed
    * setlabel
    * settxfee
    * setwalletflag
    * signmessage
    * signrawtransactionwithwallet
    * unloadwallet
    * upgradewallet
    * walletcreatefundedpsbt
    * walletlock
    * walletpassphrase
    * walletpassphrasechange
    * walletprocesspsbt

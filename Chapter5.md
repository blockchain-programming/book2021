# 5章 ビットコインのシステム構成と仕組み

## 演習課題

1. デフォルトのsignetに接続するBitcoin Core ノードを構築してください1. ．デフォルトのsignet のfaucet からテスト用のビットコインを入手し，トランザクションのライフサイクルに沿ってトランザクションの生成，署名，ブロードキャスト，検証*14を行ってみてください
3. bitcoin RPC のすべてのAPIの仕様を調べ，bitcoin-cli コマンドなどを使って機能を確認してください。


## ビットコインネットワークへの接続


bitcoin core の bitcoin-cli によるビットコインネットワークの確認例

 bitcoin-cli のコマンドを使って現在接続しているビットコインネットワークの情報を確認することができます。

* getblockchaininfo

ブロックチェーン情報の取得

* getnetworkinfo

ノードのネットワークへの接続に関する情報

* getconnectioncount

接続中のノード数

* getpeerinfo

接続中のノードの情報一覧

* getnettotals

ネットワークトラフィック情報


```bash
$ bitcoin-cli getblockchaininfo
```

signetの場合，次のような情報が返ってきます。

```json
{
  "chain": "signet",
  "blocks": 12454,
  "headers": 12454,
  "bestblockhash": "00000081e222edbda201d0c8b4556ebe602f357ff98c9ffaa29700976dc73710",
  "difficulty": 0.002804606787580661,
  "mediantime": 1605775600,
  "verificationprogress": 0.9999520582253688,
  "initialblockdownload": false,
  "chainwork": "00000000000000000000000000000000000000000000000000000022b1d0a4ba",
  "size_on_disk": 5241680,
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
        "since": 0
      },
      "height": 0,
      "active": true
    }
  },
  "warnings": "This is a pre-release test build - use at your own risk - do not use for mining or merchant applications"
```

## ワレット

bitcoin core の bitcoin-cli によるワレットの操作の例
 bitcoin-cli によるコマンドでbitcoin core のワレットを利用することができます。
bitcoin core のワレットを使用するためには最初にワレットを作成する必要があります。

```
createwallet <ワレット名> 
```

### ワレットの作成

```bash
$ bitcoin-cli createwallet alice 
{
  "name": "alice",
  "warning": ""
}
```

テスト用のビットコインを入手するためには，自分のビットコインアドレスを生成する必要があります。このときに自分の秘密鍵と公開鍵も生成されています。
getnewaddress

### 新規に自分のビットコインアドレスを生成する。

（ワレットの指定が必要）

```bash
$ bitcoin-cli  -rpcwallet=alice getnewaddress      
tb1q8h0qf2v6vjjs5ps679tvjlcmlcgm6d0ws5pjnj
```

自分の公開鍵を見てみましょう。次のコマンドで表示される情報の中の "pubkey":  の部分が公開鍵です。
getaddressinfo <ビットコインアドレス>
アドレスに関連する情報（ワレットの指定が必要）

```bash
$ bitcoin-cli -rpcwallet=alice getaddressinfo tb1q8h0qf2v6vjjs5ps679tvjlcmlcgm6d0ws5pjnj
{
  "address": "tb1q8h0qf2v6vjjs5ps679tvjlcmlcgm6d0ws5pjnj",
...
  "pubkey": "0366f277f2cf7d036bfee4a8b5ff9316125d0c6de284ab0913c5a0c1abd35a20d4",
...
  ]
}
```

秘密鍵を見るには次のようにします。
dumpprivkey <ビットコインアドレス>	
ビットコインアドレスに対応する秘密鍵の出力

```bash
$ bitcoin-cli -rpcwallet=alice dumpprivkey tb1q8h0qf2v6vjjs5ps679tvjlcmlcgm6d0ws5pjnj
cW27thy8ZyWeWAZAx82Zyz1mBbA6L6AifwKhzsPJypWKoadAmzDs
```


### テスト用ビットコインの入手

signet のfaucet サイトで要求すると，無償でテスト用ビットコインを入手することができます。入手方法は，webページのフィールドに自分のワレットで生成した自分のビットコインアドレスを入れて request ボタンをクリックするだけです。
https://signet.bc-2.jp/

### 自分のワレットの残高の確認

10分以上経過後に自分のワレットの残高を以下のようにして確認すると 10.0 BTC あるはずです。

* getbalance

ワレットにある所持金の合計金額		

```bash
$ bitcoin-cli  -rpcwallet=alice getbalance      
10.00000000
```

### ビットコインアドレスを宛先にした送金

ためしにfaucetから得たコインを自分から自分宛に送金してみましょう。


* sendtoaddress <ビットコインアドレス> <金額>
 
ビットコインアドレス宛の送金

```bash
$ bitcoin-cli -rpcwallet=alice tb1qrh67zywp2fdhlwy5cus7h0xg3pfsm8cc0cqzej 2.1

fb0bcb881b7a60dfe5743a23bc7acc64b7286287978fc008fc2bdbe0cdef78c3
```

このコマンドの実行結果で返ってきた値は@トランザクションID@と呼ばれるトランザクションの識別子です。今後は txid と略記します。
10分以上経過後に自分のワレットの残高を確認してみてください。自分から自分に送金したので，残高は増減していないはずなのに少し減っていると思います。これは送金金額から手数料 (fee) が引かれたからです。

### トランザクションの一覧の表示

自分が行ったトランザクションの一覧を見ることで自分が行った入出金の履歴を確認することができます。また送金に使用した手数料(fee) の金額を確認することもできます。また未使用のトランザクションの一覧を見ることもできます。

* listtransactions
 
自分が送受信したトランザクションの一覧

* listunspent

未使用のトランザクションの一覧



## トランザクション

トランザクションのライフサイクル
1章で説明したようにビットコインの送金はトランザクションのライフサイクル（作成，署名，ブロードキャスト，検証，記録，承認）という経過を経て完了します。このトランザクションのライフサイクルを実際に確認してみましょう。

### トランザクションの構造の確認

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

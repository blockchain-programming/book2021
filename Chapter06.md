# 6章 ビットコインの仕組みの詳細


## 6.1 ビットコイン 発コミュニティとBIP

* [メーリングリスト bitcoin-devZ](https://lists.linuxfoundation.org/mailman/listinfo/bitcoin-dev)
* [Slack: https://bitcoincore.slack.com/](Slack: https://bitcoincore.slack.com/)
* [BIP](https://github.com/bitcoin/bips)


## 6.2 トランザクションタイプと基本構造

### 演習用のUTXOを5個作成する

５種類のトランザクションのタイプ P2PK, P2PKH, P2SH, P2WPKH, P2WSH を確認するために，signetのfaucet から得たビットコインを５つのアドレスに送金し，５個のUTXOを作成してください。

1. ビットコインアドレスを５つ生成する
2. 使用するUTXOを決める
2. ５つのoutputを持つトランザクションを作成する
3. 作成したトランザクションに署名する
4. 署名したトランザクションをブロードキャストする
5. トランザクションがブロックに格納されたことを確認する
6. UTXOのリストを確認する

```bash
# ビットコインアドレスを５つ生成する

bitcoin-core.cli getnewaddress
tb1qz9qum0j3th39wfmqsevyu59kmffmhsu69agu33

bitcoin-core.cli getnewaddress
tb1qq8725772xccjes5paehkvxrpg5a5gvx50an2m2

bitcoin-core.cli getnewaddress
tb1q668vf52sqv6rqshjqjr5qn25zen7lehzydj69x

bitcoin-core.cli getnewaddress
tb1qy986nrg0vtq4lyt6t2n9npm0auzrh0uc4gsv3x

bitcoin-core.cli getnewaddress
tb1qeh6j2hjdulv5ede0plqr5hk77g3jrhh08qy97f

# 使用するUTXOを決める
bitcoin-core.cli listunspent
[
  {
    "txid": "7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb",
    "vout": 0,
    "address": "tb1qzdhc0u52q5k3p5mke2nqdsau5rytdr6q6m74gn",
    "label": "",
    "scriptPubKey": "0014136f87f28a052d10d376caa606c3bca0c8b68f40",
    "amount": 0.10000000,
    "confirmations": 259,
    "spendable": true,
    "solvable": true,
    "desc": "wpkh([60d80dee/0'/0'/0']029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac)#r7lh6gny",
    "safe": true
  }
]

# ５つのoutputを持つトランザクションを作成する
bitcoin-core.cli createrawtransaction  '[{"txid":"7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb","vout":0}]' '[{"tb1qz9qum0j3th39wfmqsevyu59kmffmhsu69agu33":0.018}, {"tb1qq8725772xccjes5paehkvxrpg5a5gvx50an2m2":0.02},
{"tb1q668vf52sqv6rqshjqjr5qn25zen7lehzydj69x":0.02},
{"tb1qy986nrg0vtq4lyt6t2n9npm0auzrh0uc4gsv3x":0.02},
{"tb1qeh6j2hjdulv5ede0plqr5hk77g3jrhh08qy97f":0.02}]'

0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0540771b00000000001600141141cdbe515de257276086584e50b6da53bbc39a80841e000000000016001401fcaa7bca36312cc281ee6f661861453b4430d480841e0000000000160014d68ec4d15003343042f20487404d541667efe6e280841e0000000000160014214fa98d0f62c15f917a5aa659876fef043bbf9880841e0000000000160014cdf5255e4de7d94cb72f0fc03a5edef22321deef00000000

# 作成したトランザクションに署名する
bitcoin-core.cli signrawtransactionwithwallet 0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0540771b00000000001600141141cdbe515de257276086584e50b6da53bbc39a80841e000000000016001401fcaa7bca36312cc281ee6f661861453b4430d480841e0000000000160014d68ec4d15003343042f20487404d541667efe6e280841e0000000000160014214fa98d0f62c15f917a5aa659876fef043bbf9880841e0000000000160014cdf5255e4de7d94cb72f0fc03a5edef22321deef00000000

{
  "hex": "02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0540771b00000000001600141141cdbe515de257276086584e50b6da53bbc39a80841e000000000016001401fcaa7bca36312cc281ee6f661861453b4430d480841e0000000000160014d68ec4d15003343042f20487404d541667efe6e280841e0000000000160014214fa98d0f62c15f917a5aa659876fef043bbf9880841e0000000000160014cdf5255e4de7d94cb72f0fc03a5edef22321deef0247304402200b8cb96329e7f8af227b04edf9836a51e8690e3a8db493906dd57fc477b12db40220502e7fbd486aa6c815b061c1294a241d53387e51587a7cb4a58a4692fb199a480121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000",
  "complete": true
}

bitcoin-core.cli decoderawtransaction 02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0540771b00000000001600141141cdbe515de257276086584e50b6da53bbc39a80841e000000000016001401fcaa7bca36312cc281ee6f661861453b4430d480841e0000000000160014d68ec4d15003343042f20487404d541667efe6e280841e0000000000160014214fa98d0f62c15f917a5aa659876fef043bbf9880841e0000000000160014cdf5255e4de7d94cb72f0fc03a5edef22321deef0247304402200b8cb96329e7f8af227b04edf9836a51e8690e3a8db493906dd57fc477b12db40220502e7fbd486aa6c815b061c1294a241d53387e51587a7cb4a58a4692fb199a480121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000

{
  "txid": "b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783",
  "hash": "fedafcb0f2385e7dcf266c6970758d7ba2b71c081fb8d8bb3f89a00a84aa9bfd",
  "version": 2,
  "size": 315,
  "vsize": 234,
  "weight": 933,
  "locktime": 0,
  "vin": [
    {
      "txid": "7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "304402200b8cb96329e7f8af227b04edf9836a51e8690e3a8db493906dd57fc477b12db40220502e7fbd486aa6c815b061c1294a241d53387e51587a7cb4a58a4692fb199a4801",
        "029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.01800000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 1141cdbe515de257276086584e50b6da53bbc39a",
        "hex": "00141141cdbe515de257276086584e50b6da53bbc39a",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qz9qum0j3th39wfmqsevyu59kmffmhsu69agu33"
        ]
      }
    },
    {
      "value": 0.02000000,
      "n": 1,
      "scriptPubKey": {
        "asm": "0 01fcaa7bca36312cc281ee6f661861453b4430d4",
        "hex": "001401fcaa7bca36312cc281ee6f661861453b4430d4",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qq8725772xccjes5paehkvxrpg5a5gvx50an2m2"
        ]
      }
    },
    {
      "value": 0.02000000,
      "n": 2,
      "scriptPubKey": {
        "asm": "0 d68ec4d15003343042f20487404d541667efe6e2",
        "hex": "0014d68ec4d15003343042f20487404d541667efe6e2",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1q668vf52sqv6rqshjqjr5qn25zen7lehzydj69x"
        ]
      }
    },
    {
      "value": 0.02000000,
      "n": 3,
      "scriptPubKey": {
        "asm": "0 214fa98d0f62c15f917a5aa659876fef043bbf98",
        "hex": "0014214fa98d0f62c15f917a5aa659876fef043bbf98",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qy986nrg0vtq4lyt6t2n9npm0auzrh0uc4gsv3x"
        ]
      }
    },
    {
      "value": 0.02000000,
      "n": 4,
      "scriptPubKey": {
        "asm": "0 cdf5255e4de7d94cb72f0fc03a5edef22321deef",
        "hex": "0014cdf5255e4de7d94cb72f0fc03a5edef22321deef",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qeh6j2hjdulv5ede0plqr5hk77g3jrhh08qy97f"
        ]
      }
    }
  ]
}

# 署名したトランザクションをブロードキャストする
bitcoin-core.cli sendrawtransaction 02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0540771b00000000001600141141cdbe515de257276086584e50b6da53bbc39a80841e000000000016001401fcaa7bca36312cc281ee6f661861453b4430d480841e0000000000160014d68ec4d15003343042f20487404d541667efe6e280841e0000000000160014214fa98d0f62c15f917a5aa659876fef043bbf9880841e0000000000160014cdf5255e4de7d94cb72f0fc03a5edef22321deef0247304402200b8cb96329e7f8af227b04edf9836a51e8690e3a8db493906dd57fc477b12db40220502e7fbd486aa6c815b061c1294a241d53387e51587a7cb4a58a4692fb199a480121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000

b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783

# 10分以上経過後，トランザクションがブロックに格納されたことを確認する( "confirmations": 1 を確認する)
    # 先に6.3 を実施する方が効率がよいでしょう。
    
bitcoin-core.cli gettransaction b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783

# UTXOのリストを確認する
bitcoin-core.cli listunspent

```

作成した５つのUTXOは，それぞれ順にP2PK,　P2PKH，P2SH，P2WPKH，P2WSHの作成実験のために使います。

## 6.3 ビットコインアドレス

### ビットコインアドレスの生成

```bash
getnewaddress <ラベル> <アドレスタイプ>
```

アドレスタイプ

* legacy
* bech32
* p2sh-segwit (後方互換のため，bech32アドレスをP2SHでラップしたアドレス)

### Bech32アドレス

```bash
bitcoin-core.cli getnewaddress alice bech32

tb1q5vfgy0wxdphchqnfqdwj3kyjxrwmejfqgearsj
```

### base52 アドレス

```bash
bitcoin-core.cli getnewaddress 'alice' legacy

mgMrVwM54xDWfMZ3o78taiRTCUg2No76fx
```
### p2sh-segwit

```
bitcoin-core.cli getnewaddress alice p2sh-segwit 

2NBNBEyxMSgDfeSWEKAKiJBirhpHgKTGfGD
```

### マルチシグアドレスの生成（P2SH, P2WSHの例）

```
createmultisig <必要署名数> '[<公開鍵1>,<公開鍵2>,...,<公開鍵m>]' <アドレスタイプ>
```

アドレスタイプ

* legacy
* bech32
* p2sh-segwit (後方互換のため，bech32アドレスをP2SHでラップしたアドレス)

```bash
 bitcoin-core.cli createmultisig 2 '["0284f7b351afa43829e114bb82df27d2edb4c47c137155e9ba637312f09997f7d4","034c753eba402a724142ddb70f13457911309c5779f81c905a5b49d3ab11940b34","03ccca0d6863280825db37ce3fd6dfa290699c2d5532065a2ddab41c021fdd4c55"]' legacy
```

legacy
 
```json
{
  "address": "2N8R8ak8rSL9hCKXGfyMRxKP5oHGBrETtBA",
  "redeemScript": "52210284f7b351afa43829e114bb82df27d2edb4c47c137155e9ba637312f09997f7d421034c753eba402a724142ddb70f13457911309c5779f81c905a5b49d3ab11940b342103ccca0d6863280825db37ce3fd6dfa290699c2d5532065a2ddab41c021fdd4c5553ae",
  "descriptor": "sh(multi(2,0284f7b351afa43829e114bb82df27d2edb4c47c137155e9ba637312f09997f7d4,034c753eba402a724142ddb70f13457911309c5779f81c905a5b49d3ab11940b34,03ccca0d6863280825db37ce3fd6dfa290699c2d5532065a2ddab41c021fdd4c55))#npg9ftp7"
}

```

Bech32

```
bitcoin-core.cli createmultisig 2 '["0284f7b351afa43829e114bb82df27d2edb4c47c137155e9ba637312f09997f7d4","034c753eba402a724142ddb70f13457911309c5779f81c905a5b49d3ab11940b34","03ccca0d6863280825db37ce3fd6dfa290699c2d5532065a2ddab41c021fdd4c55"]' bech32
```

```json
{
  "address": "tb1qy6txdvdrlxnwjkx0t87eph3zljljw0emcxysldsx4z6fvctxf27shmsf0a",
  "redeemScript": "52210284f7b351afa43829e114bb82df27d2edb4c47c137155e9ba637312f09997f7d421034c753eba402a724142ddb70f13457911309c5779f81c905a5b49d3ab11940b342103ccca0d6863280825db37ce3fd6dfa290699c2d5532065a2ddab41c021fdd4c5553ae",
  "descriptor": "wsh(multi(2,0284f7b351afa43829e114bb82df27d2edb4c47c137155e9ba637312f09997f7d4,034c753eba402a724142ddb70f13457911309c5779f81c905a5b49d3ab11940b34,03ccca0d6863280825db37ce3fd6dfa290699c2d5532065a2ddab41c021fdd4c55))#xn99d3lq"
}

```

### ビットコインアドレスの検証

```
validateaddress <アドレス>
```

結果

```
{                               (json object)
  "isvalid" : true|false,       (boolean) If the address is valid or not. If not, this is the only property returned.
  "address" : "str",            (string) The bitcoin address validated
  "scriptPubKey" : "hex",       (string) The hex-encoded scriptPubKey generated by the address
  "isscript" : true|false,      (boolean) If the key is a script
  "iswitness" : true|false,     (boolean) If the address is a witness address
  "witness_version" : n,        (numeric, optional) The version number of the witness program
  "witness_program" : "hex"     (string, optional) The hex value of the witness program
}
```

* tb1q5vfgy0wxdphchqnfqdwj3kyjxrwmejfqgearsj

```json
bitcoin-core.cli validateaddress tb1q5vfgy0wxdphchqnfqdwj3kyjxrwmejfqgearsj

{
  "isvalid": true,
  "address": "tb1q5vfgy0wxdphchqnfqdwj3kyjxrwmejfqgearsj",
  "scriptPubKey": "0014a312823dc6686f8b8269035d28d89230ddbcc920",
  "isscript": false,
  "iswitness": true,
  "witness_version": 0,
  "witness_program": "a312823dc6686f8b8269035d28d89230ddbcc920"
}

```

* mgMrVwM54xDWfMZ3o78taiRTCUg2No76fx

```json
bitcoin-core.cli validateaddress mgMrVwM54xDWfMZ3o78taiRTCUg2No76fx
{
  "isvalid": true,
  "address": "mgMrVwM54xDWfMZ3o78taiRTCUg2No76fx",
  "scriptPubKey": "76a914093f8b6bf43eeaf65c44e80bbbffae251e4a0e8f88ac",
  "isscript": false,
  "iswitness": false
}
```

* 2NBNBEyxMSgDfeSWEKAKiJBirhpHgKTGfGD

```
bitcoin-core.cli validateaddress 2NBNBEyxMSgDfeSWEKAKiJBirhpHgKTGfGD
{
  "isvalid": true,
  "address": "2NBNBEyxMSgDfeSWEKAKiJBirhpHgKTGfGD",
  "scriptPubKey": "a914c6c2e21402e8f9f32eb05ed7e160c08b6f8aeba787",
  "isscript": true,
  "iswitness": false
}

```

* 2N8R8ak8rSL9hCKXGfyMRxKP5oHGBrETtBA


```
bitcoin-core.cli validateaddress 2N8R8ak8rSL9hCKXGfyMRxKP5oHGBrETtBA
{
  "isvalid": true,
  "address": "2N8R8ak8rSL9hCKXGfyMRxKP5oHGBrETtBA",
  "scriptPubKey": "a914a66988a6e2b380597fb077231c2641cf5f95b46887",
  "isscript": true,
  "iswitness": false
}
```

* tb1qy6txdvdrlxnwjkx0t87eph3zljljw0emcxysldsx4z6fvctxf27shmsf0a

```
bitcoin-core.cli validateaddress tb1qy6txdvdrlxnwjkx0t87eph3zljljw0emcxysldsx4z6fvctxf27shmsf0a
{
  "isvalid": true,
  "address": "tb1qy6txdvdrlxnwjkx0t87eph3zljljw0emcxysldsx4z6fvctxf27shmsf0a",
  "scriptPubKey": "0020269666b1a3f9a6e958cf59fd90de22fcbf273f3bc1890fb606a8b49661664abd",
  "isscript": true,
  "iswitness": true,
  "witness_version": 0,
  "witness_program": "269666b1a3f9a6e958cf59fd90de22fcbf273f3bc1890fb606a8b49661664abd"
}

```


## 6.4 トランザクションのタイプと検証スクリプト

### トランザクションの作成

#### P2PK（output）（P2PKは難易度が高いのでスキップしてもよいです）

bitcoin core のAPIでは　P2PKのトランザクション作成機能は削除されているので，自分でトランザクションの内容を仕様にそってすべて自作する必要があります。

* ScriptPubkeyの最後の１バイトは， OP_CHECKSIG (１６進数で ac)
* valueの値は送金金額の単位が 1億分の1 BTC 
* valueの値はリトルエンディアンであることに注意が必要です。

```
0.016 btc=1600000
16進数では，186a00
8バイトのリトルエンディアン表現にすると
006a180000000000
```

Ruby でのビッグエンディアンからリトルエンディアンへの変換プログラム

```ruby
be =  "0000000000186a00"
le=[be].pack('H*').reverse.unpack('H*')[0]
"006a180000000000"
```

* トランザクション

|フィールド|内容|
|:--|:--|
|version| 02000000|
|input||
|output||

トランザクションデータの連結結果

```
02000000
```

* input (UTXO)


|フィールド|内容|
|:--|:--|
|inputの数|01|
|トランザクションID|b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783|
|ScriptSigサイズ|00|
| ScriptSig |00000000|
|nSequence|ffffffff|


inputデータの連結結果

```
01b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c478300000000000ffffffff
```

* output の例

|フィールド|内容|
|:--|:--|
|outputの数|01|
|value| 006a180000000000|
|scriputPubKeyのバイト数| 23|
|scriputPubKey|21(公開鍵のバイト数 16進数）|
|公開鍵| 023d5aeb5d6ad8f3c9db4ce795250bf8944c1a3aa6c0f2f2a5f306222d08c4aeb0|
| OP_CHECKSIG| ac|
|nlocktime| 00000000|


outputデータの連結結果

```
01006a1800000000002321023d5aeb5d6ad8f3c9db4ce795250bf8944c1a3aa6c0f2f2a5f306222d08c4aeb0ac00000000
```

作成したトランザクションへの署名

```
bitcoin-core.cli decoderawtransaction 0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff01006a1800000000002321023d5aeb5d6ad8f3c9db4ce795250bf8944c1a3aa6c0f2f2a5f306222d08c4aeb0ac00000000

{
  "txid": "2ab812138ed8f23a5243cccd0d8584f65972e29b2eb3eabee38c94987bc02c4e",
  "hash": "2ab812138ed8f23a5243cccd0d8584f65972e29b2eb3eabee38c94987bc02c4e",
  "version": 2,
  "size": 95,
  "vsize": 95,
  "weight": 380,
  "locktime": 0,
  "vin": [
    {
      "txid": "7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb",
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
      "value": 0.10000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "023d5aeb5d6ad8f3c9db4ce795250bf8944c1a3aa6c0f2f2a5f306222d08c4aeb0 OP_CHECKSIG",
        "hex": "21023d5aeb5d6ad8f3c9db4ce795250bf8944c1a3aa6c0f2f2a5f306222d08c4aeb0ac",
        "type": "pubkey"
      }
    }
  ]
}
```


作成したトランザクションへの署名

```
bitcoin-core.cli signrawtransactionwithwallet 0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0180969800000000002321023d5aeb5d6ad8f3c9db4ce795250bf8944c1a3aa6c0f2f2a5f306222d08c4aeb0ac00000000


{
  "hex": "02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0180969800000000002321023d5aeb5d6ad8f3c9db4ce795250bf8944c1a3aa6c0f2f2a5f306222d08c4aeb0ac0247304402206e0167b87fc1283299adafc9500a772a088acbe1aafa72f5f1e8e81a99ea70e602205c85fd269899ef210a60241050280ca7a9df021f6fe76f18fb09a0675091951d0121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000",
  "complete": true
}

```

作成したトランザクションの確認

```
bitcoin-core.cli decoderawtransaction 02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0180969800000000002321023d5aeb5d6ad8f3c9db4ce795250bf8944c1a3aa6c0f2f2a5f306222d08c4aeb0ac0247304402206e0167b87fc1283299adafc9500a772a088acbe1aafa72f5f1e8e81a99ea70e602205c85fd269899ef210a60241050280ca7a9df021f6fe76f18fb09a0675091951d0121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000


{
  "txid": "2ab812138ed8f23a5243cccd0d8584f65972e29b2eb3eabee38c94987bc02c4e",
  "hash": "7121e583e7975157ef1555886d054b65f5c9a755896b6f20a92c248d015da2c9",
  "version": 2,
  "size": 204,
  "vsize": 123,
  "weight": 489,
  "locktime": 0,
  "vin": [
    {
      "txid": "7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "304402206e0167b87fc1283299adafc9500a772a088acbe1aafa72f5f1e8e81a99ea70e602205c85fd269899ef210a60241050280ca7a9df021f6fe76f18fb09a0675091951d01",
        "029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.10000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "023d5aeb5d6ad8f3c9db4ce795250bf8944c1a3aa6c0f2f2a5f306222d08c4aeb0 OP_CHECKSIG",
        "hex": "21023d5aeb5d6ad8f3c9db4ce795250bf8944c1a3aa6c0f2f2a5f306222d08c4aeb0ac",
        "type": "pubkey"
      }
    }
  ]
}
```

#### P2PKH（output）

送金先アドレスを　P2PKH アドレスにすればよい

* mhpvREwaqf5vF6y4L3nFRBQ88DmgKLbqVu
* n2T8oGvosrY6Yi3uzrTb8hqKzBqXggABy8


input(UTXO)　のJSON形式の例

```json
'[{"txid":"7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb","vout":0}]' 
```

output のJSON形式の例

```json
'[{"mhpvREwaqf5vF6y4L3nFRBQ88DmgKLbqVu":0.001}, {"n2T8oGvosrY6Yi3uzrTb8hqKzBqXggABy8":0.09}]'
```

未署名トランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb","vout":0}]' '[{"mhpvREwaqf5vF6y4L3nFRBQ88DmgKLbqVu":0.001}, {"n2T8oGvosrY6Yi3uzrTb8hqKzBqXggABy8":0.09}]'


0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff02a0860100000000001976a91419562c3ce4a9404c0318e5bcc47d393d272cff3a88ac40548900000000001976a914e5a1bee9f532669fc8d8f28e1879ef724f81e70f88ac00000000
```

トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```
bitcoin-core.cli signrawtransactionwithwallet 0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff02a0860100000000001976a91419562c3ce4a9404c0318e5bcc47d393d272cff3a88ac40548900000000001976a914e5a1bee9f532669fc8d8f28e1879ef724f81e70f88ac00000000
{
  "hex": "02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff02a0860100000000001976a91419562c3ce4a9404c0318e5bcc47d393d272cff3a88ac40548900000000001976a914e5a1bee9f532669fc8d8f28e1879ef724f81e70f88ac02473044022026fbca6d059e55be5bee9a2319690e77bdfaaea1ee61fa310785dc1bca9dd64a0220775eb0528e6c5e25fd993a0c2a738d9482538db129eb9197c0d025eba285cde90121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000",
  "complete": true
}

```

作成したトランザクションの確認

```
bitcoin-core.cli decoderawtransaction 02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff02a0860100000000001976a91419562c3ce4a9404c0318e5bcc47d393d272cff3a88ac40548900000000001976a914e5a1bee9f532669fc8d8f28e1879ef724f81e70f88ac02473044022026fbca6d059e55be5bee9a2319690e77bdfaaea1ee61fa310785dc1bca9dd64a0220775eb0528e6c5e25fd993a0c2a738d9482538db129eb9197c0d025eba285cde90121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000


{
  "txid": "e069f29b1823a2b2fc8ea1c109dcd117f6e010773d585d92d2b9565bc544d2b0",
  "hash": "4e1ccf736e0572005ee694dd42c9ffd46dbd6103edc1247dea6e278304b6b137",
  "version": 2,
  "size": 228,
  "vsize": 147,
  "weight": 585,
  "locktime": 0,
  "vin": [
    {
      "txid": "7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "3044022026fbca6d059e55be5bee9a2319690e77bdfaaea1ee61fa310785dc1bca9dd64a0220775eb0528e6c5e25fd993a0c2a738d9482538db129eb9197c0d025eba285cde901",
        "029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.00100000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 19562c3ce4a9404c0318e5bcc47d393d272cff3a OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a91419562c3ce4a9404c0318e5bcc47d393d272cff3a88ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "mhpvREwaqf5vF6y4L3nFRBQ88DmgKLbqVu"
        ]
      }
    },
    {
      "value": 0.09000000,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 e5a1bee9f532669fc8d8f28e1879ef724f81e70f OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914e5a1bee9f532669fc8d8f28e1879ef724f81e70f88ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "n2T8oGvosrY6Yi3uzrTb8hqKzBqXggABy8"
        ]
      }
    }
  ]
}

```

#### P2SH（output）

送金先アドレスを　P2SH アドレスにすればよい

マルチシグのためのP2SHアドレスの生成
```
bitcoin-core.cli createmultisig 2 '["0284f7b351afa43829e114bb82df27d2edb4c47c137155e9ba637312f09997f7d4","034c753eba402a724142ddb70f13457911309c5779f81c905a5b49d3ab11940b34","03ccca0d6863280825db37ce3fd6dfa290699c2d5532065a2ddab41c021fdd4c55"]' legacy

{
  "address": "2N8R8ak8rSL9hCKXGfyMRxKP5oHGBrETtBA",
  "redeemScript": "52210284f7b351afa43829e114bb82df27d2edb4c47c137155e9ba637312f09997f7d421034c753eba402a724142ddb70f13457911309c5779f81c905a5b49d3ab11940b342103ccca0d6863280825db37ce3fd6dfa290699c2d5532065a2ddab41c021fdd4c5553ae",
  "descriptor": "sh(multi(2,0284f7b351afa43829e114bb82df27d2edb4c47c137155e9ba637312f09997f7d4,034c753eba402a724142ddb70f13457911309c5779f81c905a5b49d3ab11940b34,03ccca0d6863280825db37ce3fd6dfa290699c2d5532065a2ddab41c021fdd4c55))#npg9ftp7"
}
```

* 2N8R8ak8rSL9hCKXGfyMRxKP5oHGBrETtBA

input(UTXO)　のJSON形式の例

```json
'[{"txid":"7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb","vout":0}]' 
```

output のJSON形式の例

```json
'[{"2N8R8ak8rSL9hCKXGfyMRxKP5oHGBrETtBA":0.099}]'
```

未署名トランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb","vout":0}]' '[{"2N8R8ak8rSL9hCKXGfyMRxKP5oHGBrETtBA":0.099}]'


0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff01e00f97000000000017a914a66988a6e2b380597fb077231c2641cf5f95b4688700000000
```

トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```
bitcoin-core.cli signrawtransactionwithwallet 0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff01e00f97000000000017a914a66988a6e2b380597fb077231c2641cf5f95b4688700000000


{
  "hex": "02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff01e00f97000000000017a914a66988a6e2b380597fb077231c2641cf5f95b468870247304402204960716c656625decf7772c4803f9d1e0961a34b0921dc8c1916982b55c4fef802206497788028d6ca817718d42104a5e7a60a1d7b3cea3629b7b86c746fafbe82140121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000",
  "complete": true
}
```

作成したトランザクションの確認

```
bitcoin-core.cli decoderawtransaction 02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff01e00f97000000000017a914a66988a6e2b380597fb077231c2641cf5f95b468870247304402204960716c656625decf7772c4803f9d1e0961a34b0921dc8c1916982b55c4fef802206497788028d6ca817718d42104a5e7a60a1d7b3cea3629b7b86c746fafbe82140121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000


{
  "txid": "3a6809dfdc6c90eddb2d2210f6b708bca66a6a37e048ed96b091dfdf87a3f9b2",
  "hash": "8e5410315c6d946bc1289a6d2186ac107692d6c90d2f0e9586d54fb58fa53032",
  "version": 2,
  "size": 192,
  "vsize": 111,
  "weight": 441,
  "locktime": 0,
  "vin": [
    {
      "txid": "7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "304402204960716c656625decf7772c4803f9d1e0961a34b0921dc8c1916982b55c4fef802206497788028d6ca817718d42104a5e7a60a1d7b3cea3629b7b86c746fafbe821401",
        "029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.09900000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_HASH160 a66988a6e2b380597fb077231c2641cf5f95b468 OP_EQUAL",
        "hex": "a914a66988a6e2b380597fb077231c2641cf5f95b46887",
        "reqSigs": 1,
        "type": "scripthash",
        "addresses": [
          "2N8R8ak8rSL9hCKXGfyMRxKP5oHGBrETtBA"
        ]
      }
    }
  ]
}
```

#### P2WPKH（output）

送金先アドレスを　P2WPKH アドレスにすればよい

* tb1q5vfgy0wxdphchqnfqdwj3kyjxrwmejfqgearsj
* tb1qflpp67jj96dg8mt3gm9sua7r5mumew868jk4y3


input(UTXO)　のJSON形式の例

```json
'[{"txid":"7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb","vout":0}]' 
```

output のJSON形式の例

```json
'[{"tb1q5vfgy0wxdphchqnfqdwj3kyjxrwmejfqgearsj":0.001}, {"tb1qflpp67jj96dg8mt3gm9sua7r5mumew868jk4y3":0.09}]'
```

未署名トランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb","vout":0}]' '[{"tb1q5vfgy0wxdphchqnfqdwj3kyjxrwmejfqgearsj":0.001}, {"tb1qflpp67jj96dg8mt3gm9sua7r5mumew868jk4y3":0.09}]'

0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff02a086010000000000160014a312823dc6686f8b8269035d28d89230ddbcc92040548900000000001600144fc21d7a522e9a83ed7146cb0e77c3a6f9bcb8fa00000000
```

トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```
bitcoin-core.cli signrawtransactionwithwallet 0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff02a086010000000000160014a312823dc6686f8b8269035d28d89230ddbcc92040548900000000001600144fc21d7a522e9a83ed7146cb0e77c3a6f9bcb8fa00000000

{
  "hex": "02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff02a086010000000000160014a312823dc6686f8b8269035d28d89230ddbcc92040548900000000001600144fc21d7a522e9a83ed7146cb0e77c3a6f9bcb8fa024730440220358a4d36343378493661730ed0c22cedf1abc5f6d62030f554b5447fd49be450022063ddec06461725bb0061f7d00b9b83a40dc03119fa7989490a87ed73982fe9e40121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000",
  "complete": true
}
```

作成したトランザクションの確認

```
bitcoin-core.cli decoderawtransaction 02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff02a086010000000000160014a312823dc6686f8b8269035d28d89230ddbcc92040548900000000001600144fc21d7a522e9a83ed7146cb0e77c3a6f9bcb8fa024730440220358a4d36343378493661730ed0c22cedf1abc5f6d62030f554b5447fd49be450022063ddec06461725bb0061f7d00b9b83a40dc03119fa7989490a87ed73982fe9e40121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000


{
  "txid": "89c3d9b43adc18eb9695fb8b7f4e8ff6f5fcf9070118167f0689d5e52b39da59",
  "hash": "31cd47ef73b21ff3dd1055efdaff792ed2c00c66f78beead9f57da6a17683dce",
  "version": 2,
  "size": 222,
  "vsize": 141,
  "weight": 561,
  "locktime": 0,
  "vin": [
    {
      "txid": "7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "30440220358a4d36343378493661730ed0c22cedf1abc5f6d62030f554b5447fd49be450022063ddec06461725bb0061f7d00b9b83a40dc03119fa7989490a87ed73982fe9e401",
        "029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.00100000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 a312823dc6686f8b8269035d28d89230ddbcc920",
        "hex": "0014a312823dc6686f8b8269035d28d89230ddbcc920",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1q5vfgy0wxdphchqnfqdwj3kyjxrwmejfqgearsj"
        ]
      }
    },
    {
      "value": 0.09000000,
      "n": 1,
      "scriptPubKey": {
        "asm": "0 4fc21d7a522e9a83ed7146cb0e77c3a6f9bcb8fa",
        "hex": "00144fc21d7a522e9a83ed7146cb0e77c3a6f9bcb8fa",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qflpp67jj96dg8mt3gm9sua7r5mumew868jk4y3"
        ]
      }
    }
  ]
}
```


#### P2WSH（output）

送金先アドレスを　P2WSH アドレスにすればよい

マルチシグのためのP2WSHアドレスの生成
```
bitcoin-core.cli createmultisig 2 '["0284f7b351afa43829e114bb82df27d2edb4c47c137155e9ba637312f09997f7d4","034c753eba402a724142ddb70f13457911309c5779f81c905a5b49d3ab11940b34","03ccca0d6863280825db37ce3fd6dfa290699c2d5532065a2ddab41c021fdd4c55"]' bech32

{
  "address": "tb1qy6txdvdrlxnwjkx0t87eph3zljljw0emcxysldsx4z6fvctxf27shmsf0a",
  "redeemScript": "52210284f7b351afa43829e114bb82df27d2edb4c47c137155e9ba637312f09997f7d421034c753eba402a724142ddb70f13457911309c5779f81c905a5b49d3ab11940b342103ccca0d6863280825db37ce3fd6dfa290699c2d5532065a2ddab41c021fdd4c5553ae",
  "descriptor": "wsh(multi(2,0284f7b351afa43829e114bb82df27d2edb4c47c137155e9ba637312f09997f7d4,034c753eba402a724142ddb70f13457911309c5779f81c905a5b49d3ab11940b34,03ccca0d6863280825db37ce3fd6dfa290699c2d5532065a2ddab41c021fdd4c55))#xn99d3lq"
}
```

* tb1qy6txdvdrlxnwjkx0t87eph3zljljw0emcxysldsx4z6fvctxf27shmsf0a


input(UTXO)　のJSON形式の例

```json
'[{"txid":"7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb","vout":0}]' 
```

output のJSON形式の例

```json
'[{"tb1qy6txdvdrlxnwjkx0t87eph3zljljw0emcxysldsx4z6fvctxf27shmsf0a":0.1}]'
```

未署名トランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb","vout":0}]' '[{"tb1qy6txdvdrlxnwjkx0t87eph3zljljw0emcxysldsx4z6fvctxf27shmsf0a":0.1}]'

0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff018096980000000000220020269666b1a3f9a6e958cf59fd90de22fcbf273f3bc1890fb606a8b49661664abd00000000
```

トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```
bitcoin-core.cli signrawtransactionwithwallet 0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff018096980000000000220020269666b1a3f9a6e958cf59fd90de22fcbf273f3bc1890fb606a8b49661664abd00000000

{
  "hex": "02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff018096980000000000220020269666b1a3f9a6e958cf59fd90de22fcbf273f3bc1890fb606a8b49661664abd0247304402206c19c84fd666ce201234d4d1546e8366261cbb7adebd4fc1f997df9e2f710ef702207964315d7d2e5ca656de93b4d5bb7b19acb78722a0b185d16609cf6d0ec5b6e00121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000",
  "complete": true
}
```

作成したトランザクションの確認

```
bitcoin-core.cli decoderawtransaction 02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff018096980000000000220020269666b1a3f9a6e958cf59fd90de22fcbf273f3bc1890fb606a8b49661664abd0247304402206c19c84fd666ce201234d4d1546e8366261cbb7adebd4fc1f997df9e2f710ef702207964315d7d2e5ca656de93b4d5bb7b19acb78722a0b185d16609cf6d0ec5b6e00121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000

{
  "txid": "16b71b4b9cd2c600a1d09076b6e8683147e9f453e055070dfead4b915cbc8929",
  "hash": "59495362c2fba34b560149818e15ce150889fe825dbd1d21f55c8204bb8a1e7f",
  "version": 2,
  "size": 203,
  "vsize": 122,
  "weight": 485,
  "locktime": 0,
  "vin": [
    {
      "txid": "7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "304402206c19c84fd666ce201234d4d1546e8366261cbb7adebd4fc1f997df9e2f710ef702207964315d7d2e5ca656de93b4d5bb7b19acb78722a0b185d16609cf6d0ec5b6e001",
        "029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.10000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 269666b1a3f9a6e958cf59fd90de22fcbf273f3bc1890fb606a8b49661664abd",
        "hex": "0020269666b1a3f9a6e958cf59fd90de22fcbf273f3bc1890fb606a8b49661664abd",
        "reqSigs": 1,
        "type": "witness_v0_scripthash",
        "addresses": [
          "tb1qy6txdvdrlxnwjkx0t87eph3zljljw0emcxysldsx4z6fvctxf27shmsf0a"
        ]
      }
    }
  ]
}
```




## 6.5 ビットコインスクリプトの応用例






---

# 課題

1. P2PK，P2PKH，P2SH，P2WPKH，P2WPSHのoutputをもつトランザクションを作成してください。1. P2PK，P2PKH，P2SH，P2WPKH，P2WPSHのUTXOをinputとするトランザクションを作成してください。outputのタイプはP2WPKHとします。1. 実際にアトミックスワップを行うトランザクションを作成し，アトミックスワップを実施してみてください。


## 1. P2PK，P2PKH，P2SH，P2WPKH，P2WPSHのoutputをもつトランザクションを作成してください。


### 回答例

#### signet を利用

*  UTXO
    *  "txid": "7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb"
    *   "vout": 0

* TxOut
    * P2WPKH "tb1qzdhc0u52q5k3p5mke2nqdsau5rytdr6q6m74gn"
    * 




## 2. P2PK，P2PKH，P2SH，P2WPKH，P2WPSHのUTXOをinputとするトランザクションを作成してください。outputのタイプはP2WPKHとします。

### 回答例

## 3. 実際にアトミックスワップを行うトランザクションを作成し，アトミックスワップを実施してみてください。

### 回答例


---
# bitcoinrb の使い方

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

## トランザクションの例

 mainnetのトランザクションの例です。

### トランザクションのタイプ (output) の例

トランザクションのoutputに複数のタイプを含むものもあります

*  P2PK
    TXID: 330aac3434b86bbe99df6d9a93da13e687646b1d7d3a6945be2fa015ebe3b90c
    TXID: 0fb1b6b0480b7b45f265e832b9afa8ec97959a82beb719ea7057ad9eaf5ce4fd
    
* P2PKH

    TXID: f4515fed3dc4a19b90a317b9840c243bac26114cf637522373a7d486b372600b
    TXID: e9a66845e05d5abc0ad04ec80f774a7e585c6e8db975962d069a522137b80c1d

*  P2SH

    TXID: 1ab250fa3fe855a3f75094d6c64711d2de4bb0275f49fcd10e9cfb2dd7ea5ef9
    TXID: b5986fc13fcb5ba7ddb36457edb30fa3f5c0b2f873bc003167530b1b8bb49540

*  P2WPKH

    TXID: 9d9463c62424d13bb4e6a64397adeedf5a5a0db8b66243ba779f006a3f87e9e8

*  P2WSH

    TXID: 5f6b4c79fa22595b18267b9c41a1c4d884dbdd845fed5f0d434e603d32b9d90c

### 確認方法

```bash
bitcoin-core.cli getrawtransaction <TXID> true
```

### P2PKトランザクションの例

### output がP2PK

初期の時代のコインベーストランザクションです

```json
TXID: 330aac3434b86bbe99df6d9a93da13e687646b1d7d3a6945be2fa015ebe3b90c
      "vin": [
        {
          "coinbase": "0464ba0e1c010a",
          "sequence": 4294967295
        }
      ],
      "vout": [
        {
          "value": 50.00000000,
          "n": 0,
          "scriptPubKey": {
            "asm": "04b3eac44b4caa3c2f91d7179ab40b1b896e6d6d6d99ebb59db30b7ed19fe84db69886cd18fdb490b87244d2764a5ecb58071fa891fb7f22bb92ed3eb6b6be4082 OP_CHECKSIG",
            "hex": "4104b3eac44b4caa3c2f91d7179ab40b1b896e6d6d6d99ebb59db30b7ed19fe84db69886cd18fdb490b87244d2764a5ecb58071fa891fb7f22bb92ed3eb6b6be4082ac",
            "type": "pubkey"
          }
        }
      ],
```

#### input がP2PK

```json
TXID: 0fb1b6b0480b7b45f265e832b9afa8ec97959a82beb719ea7057ad9eaf5ce4fd
   "vin": [
    {
...

    {
      "txid": "330aac3434b86bbe99df6d9a93da13e687646b1d7d3a6945be2fa015ebe3b90c",
      "vout": 0,
      "scriptSig": {
        "asm": "3046022100d253be36e401150e912c6c3b4fcadeae46e845ca4adf0f30b1bb21ba5c2b098a0221008a679595140050c74c009fc4c1dc2b77ca08abc9c7f31848be12d543b9bc169a[ALL]",
        "hex": "493046022100d253be36e401150e912c6c3b4fcadeae46e845ca4adf0f30b1bb21ba5c2b098a0221008a679595140050c74c009fc4c1dc2b77ca08abc9c7f31848be12d543b9bc169a01"
      },
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 350.00000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 b8da78f3b1a02948d050fa6ffdfe5c960f6aa527 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914b8da78f3b1a02948d050fa6ffdfe5c960f6aa52788ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "1HrR42k1JRLFvWJcmauqKuRG43ACg2pJRV"
        ]
      }
    }
  ],```

### P2PKHトランザクションの例

#### output がP2PKH

```json
TXID: f4515fed3dc4a19b90a317b9840c243bac26114cf637522373a7d486b372600b
  "vin": [
    {
      "txid": "c691e521b77f7e59425d9f51b98c9897f2f40bb6165bc595156fb8e69ef3fce7",
      "vout": 1,
      "scriptSig": {
        "asm": "3045022100ac572b43e78089851202cfd9386750b08afc175318c537f04eb364bf5a0070d402203f0e829d4baea982feaf987cb9f14c85097d2fbe89fba3f283f6925b3214a97e[ALL] 048922fa4dc891f9bb39f315635c03e60e019ff9ec1559c8b581324b4c3b7589a57550f9b0b80bc72d0f959fddf6ca65f07223c37a8499076bd7027ae5c325fac5",
        "hex": "483045022100ac572b43e78089851202cfd9386750b08afc175318c537f04eb364bf5a0070d402203f0e829d4baea982feaf987cb9f14c85097d2fbe89fba3f283f6925b3214a97e0141048922fa4dc891f9bb39f315635c03e60e019ff9ec1559c8b581324b4c3b7589a57550f9b0b80bc72d0f959fddf6ca65f07223c37a8499076bd7027ae5c325fac5"
      },
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.01000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 c4eb47ecfdcf609a1848ee79acc2fa49d3caad70 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914c4eb47ecfdcf609a1848ee79acc2fa49d3caad7088ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "1JxDJCyWNakZ5kECKdCU9Zka6mh34mZ7B2"
        ]
      }
    }
  ],
```

#### input がP2PKH

```json
TXID: e9a66845e05d5abc0ad04ec80f774a7e585c6e8db975962d069a522137b80c1d
  "vin": [
    {
      "txid": "f4515fed3dc4a19b90a317b9840c243bac26114cf637522373a7d486b372600b",
      "vout": 0,
      "scriptSig": {
        "asm": "3046022100bb1ad26df930a51cce110cf44f7a48c3c561fd977500b1ae5d6b6fd13d0b3f4a022100c5b42951acedff14abba2736fd574bdb465f3e6f8da12e2c5303954aca7f78f3[ALL] 04a7135bfe824c97ecc01ec7d7e336185c81e2aa2c41ab175407c09484ce9694b44953fcb751206564a9c24dd094d42fdbfdd5aad3e063ce6af4cfaaea4ea14fbb",
        "hex": "493046022100bb1ad26df930a51cce110cf44f7a48c3c561fd977500b1ae5d6b6fd13d0b3f4a022100c5b42951acedff14abba2736fd574bdb465f3e6f8da12e2c5303954aca7f78f3014104a7135bfe824c97ecc01ec7d7e336185c81e2aa2c41ab175407c09484ce9694b44953fcb751206564a9c24dd094d42fdbfdd5aad3e063ce6af4cfaaea4ea14fbb"
      },
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.01000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 39aa3d569e06a1d7926dc4be1193c99bf2eb9ee0 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a91439aa3d569e06a1d7926dc4be1193c99bf2eb9ee088ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "16FuTPaeRSPVxxCnwQmdyx2PQWxX6HWzhQ"
        ]
      }
    }
  ],
```

### P2SHトランザクションの例

#### outputがP2SH

```json
TXID: 1ab250fa3fe855a3f75094d6c64711d2de4bb0275f49fcd10e9cfb2dd7ea5ef9
  "vin": [
    {
      "txid": "8c22a2fc0b47e57ffb7fb39d485182ea095b88c6c575b4b6ef17a3972758a3de",
      "vout": 1,
      "scriptSig": {
        "asm": "0 3044022007b6230b6e873b531e00343cef2fe6d9a5ff49af13ab4c1b965c4cdfee2b1c6902204898ebe968dbf5883eef8496ea3eccce5469e5b2d7ede37c95bb042853692b87[ALL] 30440220755ee10b8a5583937a12115506b2ed75973d9588e7e729f99dca365a22ac1d1802201e499d2f8919571b477ade650cae7579b402390868f8bd12590bc46d415a68f3[ALL] 522103da136fce845379d1aaa502875acb4c04ccff771369d811f886d48ec0e63f87c6210392e4ecdd0af74a2d05b9448343b22fac173c1618c62caf2039efb09c7e67f2d452ae",
        "hex": "00473044022007b6230b6e873b531e00343cef2fe6d9a5ff49af13ab4c1b965c4cdfee2b1c6902204898ebe968dbf5883eef8496ea3eccce5469e5b2d7ede37c95bb042853692b87014730440220755ee10b8a5583937a12115506b2ed75973d9588e7e729f99dca365a22ac1d1802201e499d2f8919571b477ade650cae7579b402390868f8bd12590bc46d415a68f30147522103da136fce845379d1aaa502875acb4c04ccff771369d811f886d48ec0e63f87c6210392e4ecdd0af74a2d05b9448343b22fac173c1618c62caf2039efb09c7e67f2d452ae"
      },
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.56014000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_HASH160 02ba02ae8ac0da7de4427cf01251ca9a4fde780a OP_EQUAL",
        "hex": "a91402ba02ae8ac0da7de4427cf01251ca9a4fde780a87",
        "reqSigs": 1,
        "type": "scripthash",
        "addresses": [
          "31wS7ALiatDhtwufApCr32xDX6kVK42Knu"
        ]
      }
    },
    {
      "value": 0.01360000,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_HASH160 6ab991f4bb25666199e79eec27b61b68414b433a OP_EQUAL",
        "hex": "a9146ab991f4bb25666199e79eec27b61b68414b433a87",
        "reqSigs": 1,
        "type": "scripthash",
        "addresses": [
          "3BRKrWx4XbvSyvqLAALHZp13fVW8pUUZY2"
        ]
      }
    }
  ],
```


#### inputがP2SH

```json
TXID: b5986fc13fcb5ba7ddb36457edb30fa3f5c0b2f873bc003167530b1b8bb49540
  "vin": [
    {
      "txid": "ca90933485cc7bd24c7e6a2466679614a8c467b04763f06d8417d6908d8ccbf2",
      "vout": 1,
      "scriptSig": {
        "asm": "0 304402205a48106d0cba2c986dfbdd6f6c12d9a05ba80fa99984eb313fcd974d70e4a2db02203dbea13b1c9a6fce2190079f8fecbd713d8ba4d0d886c12db06ef1eeffc43145[ALL] 30440220331814dc1d49769f8f5859e86bc27f1b2f9b01d40a989d434e6b9ee9ae6f958302200b0211bf78088e47fc3e52ab27f454b875018306e986c52b3688d235c41edf8b[ALL] 5221024eecce449d5eb8a93fb38f68f95d1de5c7d044a7f97428744d74d601d26363a6210392e4ecdd0af74a2d05b9448343b22fac173c1618c62caf2039efb09c7e67f2d452ae",
        "hex": "0047304402205a48106d0cba2c986dfbdd6f6c12d9a05ba80fa99984eb313fcd974d70e4a2db02203dbea13b1c9a6fce2190079f8fecbd713d8ba4d0d886c12db06ef1eeffc43145014730440220331814dc1d49769f8f5859e86bc27f1b2f9b01d40a989d434e6b9ee9ae6f958302200b0211bf78088e47fc3e52ab27f454b875018306e986c52b3688d235c41edf8b01475221024eecce449d5eb8a93fb38f68f95d1de5c7d044a7f97428744d74d601d26363a6210392e4ecdd0af74a2d05b9448343b22fac173c1618c62caf2039efb09c7e67f2d452ae"
      },
      "sequence": 4294967295
    },
    {
      "txid": "1ab250fa3fe855a3f75094d6c64711d2de4bb0275f49fcd10e9cfb2dd7ea5ef9",
      "vout": 0,
      "scriptSig": {
        "asm": "0 3044022041c4bc0e23191e2d74eb7ceb65468c137cf3b731adef8d360337c7abf5a2be8402201433c80aab49fd889834372021584685a07e812f52c89a66e12bde769bbb44fb[ALL] 3045022100fe13cb51b2e9310716cda10b7ff594599dd445d847b1ff36949b3e9e1770c28702203d15ce59c2365a7afcb68554a665e7feffba2befd3c8840a5563a1641e2a8688[ALL] 5221024eecce449d5eb8a93fb38f68f95d1de5c7d044a7f97428744d74d601d26363a6210392e4ecdd0af74a2d05b9448343b22fac173c1618c62caf2039efb09c7e67f2d452ae",
        "hex": "00473044022041c4bc0e23191e2d74eb7ceb65468c137cf3b731adef8d360337c7abf5a2be8402201433c80aab49fd889834372021584685a07e812f52c89a66e12bde769bbb44fb01483045022100fe13cb51b2e9310716cda10b7ff594599dd445d847b1ff36949b3e9e1770c28702203d15ce59c2365a7afcb68554a665e7feffba2befd3c8840a5563a1641e2a868801475221024eecce449d5eb8a93fb38f68f95d1de5c7d044a7f97428744d74d601d26363a6210392e4ecdd0af74a2d05b9448343b22fac173c1618c62caf2039efb09c7e67f2d452ae"
      },
      "sequence": 4294967295
    },
    {
      "txid": "d2f0a4643268380d856f5c16bda5c1e639695c564dd7eaf90fb0231caab579c8",
      "vout": 0,
      "scriptSig": {
        "asm": "0 30450221008d7862ce68fa68cea600fd36247f7f4cd56db8e817984e75f84ab46d592db6de022060d590cdce3ace69621000ca98cd32392410011c6017b0f608613216697e4265[ALL] 3045022100b5e86856078a0ed80ec478ab6fb28971bc5d8f31d9134a5ec0897027ebcb49c702204fd4cd8b63435166c07ff0284938a06d953c8307905a16779590e63e0e54dd8d[ALL] 5221024eecce449d5eb8a93fb38f68f95d1de5c7d044a7f97428744d74d601d26363a6210392e4ecdd0af74a2d05b9448343b22fac173c1618c62caf2039efb09c7e67f2d452ae",
        "hex": "004830450221008d7862ce68fa68cea600fd36247f7f4cd56db8e817984e75f84ab46d592db6de022060d590cdce3ace69621000ca98cd32392410011c6017b0f608613216697e426501483045022100b5e86856078a0ed80ec478ab6fb28971bc5d8f31d9134a5ec0897027ebcb49c702204fd4cd8b63435166c07ff0284938a06d953c8307905a16779590e63e0e54dd8d01475221024eecce449d5eb8a93fb38f68f95d1de5c7d044a7f97428744d74d601d26363a6210392e4ecdd0af74a2d05b9448343b22fac173c1618c62caf2039efb09c7e67f2d452ae"
      },
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 2.33500000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 5a7b34b109c641ffd0b071500f522ad646154c78 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a9145a7b34b109c641ffd0b071500f522ad646154c7888ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "19FRQkpwcuvPpSBAWTE2eraT4ZrVZupgFi"
        ]
      }
    },
    {
      "value": 0.00097000,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_HASH160 02ba02ae8ac0da7de4427cf01251ca9a4fde780a OP_EQUAL",
        "hex": "a91402ba02ae8ac0da7de4427cf01251ca9a4fde780a87",
        "reqSigs": 1,
        "type": "scripthash",
        "addresses": [
          "31wS7ALiatDhtwufApCr32xDX6kVK42Knu"
        ]
      }
    }
  ],


```

### P2WPKHトランザクションの例

#### outputがP2WPKH

```json
TXID: 47d8ca8dbd95b4d8bbed04dce3ed38ecec8c72feb560f0a3478f85f9a04d2095
   "vin": [
    {
      "txid": "47d8ca8dbd95b4d8bbed04dce3ed38ecec8c72feb560f0a3478f85f9a04d2095",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "3043022051e3240a28beaf32e95d8afd16b0b56912cf8d073ad4a0b65720360a085e6f24021f06afef0b72e8952a74c9a64f76c40d9a418000a627afdc8f25ad81ed61f9f001",
        "037a7b44ba74891a7d8e5e665852abaafdb0032dec22ea7b05a2a70d6754c1b668"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 11.78911630,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 b2fca4ea309243a1ef3e6c9aaec67f5b335db676",
        "hex": "0014b2fca4ea309243a1ef3e6c9aaec67f5b335db676",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "bc1qkt72f63sjfp6rme7djd2a3nltve4mdnkj67tq2"
        ]
      }
    },
    {
      "value": 47.82522001,
      "n": 1,
      "scriptPubKey": {
        "asm": "0 0ecc437e1487ca5951775ed93b19321aa4f7a94c",
        "hex": "00140ecc437e1487ca5951775ed93b19321aa4f7a94c",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "bc1qpmxyxls5sl99j5thtmvnkxfjr2j0022vy46hvq"
        ]
      }
    }
  ],

```

#### input がP2WPKH

```json
TXID: 9d9463c62424d13bb4e6a64397adeedf5a5a0db8b66243ba779f006a3f87e9e8
  "vin": [
    {
      "txid": "47d8ca8dbd95b4d8bbed04dce3ed38ecec8c72feb560f0a3478f85f9a04d2095",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "3043022051e3240a28beaf32e95d8afd16b0b56912cf8d073ad4a0b65720360a085e6f24021f06afef0b72e8952a74c9a64f76c40d9a418000a627afdc8f25ad81ed61f9f001",
        "037a7b44ba74891a7d8e5e665852abaafdb0032dec22ea7b05a2a70d6754c1b668"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 11.78911630,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 b2fca4ea309243a1ef3e6c9aaec67f5b335db676",
        "hex": "0014b2fca4ea309243a1ef3e6c9aaec67f5b335db676",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "bc1qkt72f63sjfp6rme7djd2a3nltve4mdnkj67tq2"
        ]
      }
    },
    {
      "value": 47.82522001,
      "n": 1,
      "scriptPubKey": {
        "asm": "0 0ecc437e1487ca5951775ed93b19321aa4f7a94c",
        "hex": "00140ecc437e1487ca5951775ed93b19321aa4f7a94c",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "bc1qpmxyxls5sl99j5thtmvnkxfjr2j0022vy46hvq"
        ]
      }
    }
  ],

```

### P2WSHの例

#### output がP2WSH

output 0 は，P2WPKHですが，
output 1 は，P2WSHです。
送金先アドレスの長さがP2WPKHとP2WSHで異なっていることを確認してください。


```json
TXID: 5f6b4c79fa22595b18267b9c41a1c4d884dbdd845fed5f0d434e603d32b9d90c
{
  "txid": "5f6b4c79fa22595b18267b9c41a1c4d884dbdd845fed5f0d434e603d32b9d90c",
  "hash": "db445346a91d7e2f759944fe1d9ae4d0598cec8b6da4a451641eec133daf9b7c",
  "version": 1,
  "size": 380,
  "vsize": 189,
  "weight": 755,
  "locktime": 0,
  "vin": [
    {
      "txid": "706da882c755ea6045d48da8e7b9d97c1fa12ca4f91d762ad9240f760593b811",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "",
        "3045022100bf951e845350cf970b20bb66977cb9e286309f7e6541c11b14d2bc0185d4538e02205d3d0b945e5cc5cfeb674d755ccb54f9f47aba00d4c2338050be85c27d58e6d201",
        "3044022033e56b7886d032a1083b6ccf0fa43a010dfccf9cd25b31ab40ef4d78bc35de230220237d715d28a3d3aeb7bc7ed9998d6a21679a5ac2b843863c25d544dfe93ab5a201",
        "522103df45a9e283fc94ae50a4e59e8d1457cc0a9153c862549a581c54abe984a502852103370782f64f5af8aa5155ed3d6c859c7c5055a66f395bd448941c0c77f04f5ecb2102f06ac375535c38d1997330819ea4d6f0de1db6e81221319e98ef526fa2bab07353ae"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.02954727,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 a0845b2f31ee9ab646316c75c95b9a9767fad556",
        "hex": "0014a0845b2f31ee9ab646316c75c95b9a9767fad556",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "bc1q5zz9kte3a6dtv333d36ujku6janl442klc7km5"
        ]
      }
    },
    {
      "value": 0.65931867,
      "n": 1,
      "scriptPubKey": {
        "asm": "0 7250d91085a77a4568fa4cfd5bebb59f0b9cb3530f8154cd4fab6d28abd548fe",
        "hex": "00207250d91085a77a4568fa4cfd5bebb59f0b9cb3530f8154cd4fab6d28abd548fe",
        "reqSigs": 1,
        "type": "witness_v0_scripthash",
        "addresses": [
          "bc1qwfgdjyy95aay2686fn74h6a4nu9eev6np7q4fn204dkj3274frlqrskvx0"
        ]
      }
    }
  ],
```

#### input がP2WSH

```json
TXID: cb519543f84b8a7e59e397fe5dbe8d25a57bb26d23f3c16df76f4b53a4110ed9
  "vin": [
    {
      "txid": "faf4a369cc8f76c78932173ef8ab736e7a6a9325613348a2db90235bdd4a91a7",
      "vout": 1,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "",
        "30450221008338e8e711658efa865e684696d3a82d3987a770df7a76deebd54fa8e4ae1d010220698b4c05ab35f4522ddf7a44c53c42fd0c6b498e56f13fa1865f0c43ae1efb2d01",
        "304402207c38e8571f30677a14f325d0b5be49ff8e52f169f8d0b611c25b3c3c2cc327e60220035bea7d802b5b98bb030e86f527a76d1f492309fb7b08d32424c09d4096d76301",
        "5221030fac04165b606dea3b8f81ada5eb66ca181d5215c873fcf46623ea7cf8e98b1b2102b7836a2a9d3ff095415383cb23a5f4f1badd75e44adb17537962eafe3ded3b602102f8cb472df1ae03cfa6b65b013add7862c7d3ac3684a8a92a44192faace228aee53ae"
      ],
      "sequence": 4294967295
    },
    {
      "txid": "5f6b4c79fa22595b18267b9c41a1c4d884dbdd845fed5f0d434e603d32b9d90c",
      "vout": 1,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "",
        "3045022100ea813a4980cd70b2a6df19989c84a9ceffe9e9dafe48cd9bddcfc23112024c780220180844620505a94eb7a9e72f1b9493429fecc74bf0719ca060b0c49bc70203e401",
        "3044022043381d9d1c49cee3e3ffa29be4f2ca7d9133e57b3e4d33e2993b971f21951edf022018d243aea690f1155d3391ab7418dc8cf41b5a8f6daaec056374b489eac0985001",
        "5221030fac04165b606dea3b8f81ada5eb66ca181d5215c873fcf46623ea7cf8e98b1b2102b7836a2a9d3ff095415383cb23a5f4f1badd75e44adb17537962eafe3ded3b602102f8cb472df1ae03cfa6b65b013add7862c7d3ac3684a8a92a44192faace228aee53ae"
      ],
      "sequence": 4294967295
    },

        ... 


  ],
  "vout": [
    {
      "value": 0.00306688,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 e51a6a803f87397f20f6ac15b41a41570335a4c9",
        "hex": "0014e51a6a803f87397f20f6ac15b41a41570335a4c9",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "bc1qu5dx4qplsuuh7g8k4s2mgxjp2upntfxfn5lexc"
        ]
      }
    },
    {
      "value": 4.90800000,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 601ed29608005c18a41840912b216160b06602db OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914601ed29608005c18a41840912b216160b06602db88ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "19mEo1ShCRu1AzqCuqFBrpKaTuyqKfNtxX"
        ]
      }
    },
    {
      "value": 0.01041349,
      "n": 2,
      "scriptPubKey": {
        "asm": "0 7250d91085a77a4568fa4cfd5bebb59f0b9cb3530f8154cd4fab6d28abd548fe",
        "hex": "00207250d91085a77a4568fa4cfd5bebb59f0b9cb3530f8154cd4fab6d28abd548fe",
        "reqSigs": 1,
        "type": "witness_v0_scripthash",
        "addresses": [
          "bc1qwfgdjyy95aay2686fn74h6a4nu9eev6np7q4fn204dkj3274frlqrskvx0"
        ]
      }
    }
  ],

```

### P2PKHトランザクションの作成(signet環境)


#### input(UTXO) のJSON形式

```json
'[{"txid": "c691e521b77f7e59425d9f51b98c9897f2f40bb6165bc595156fb8e69ef3fce7","vout": 0}]'
```

#### output のJSON形式

```json
'[{"1JxDJCyWNakZ5kECKdCU9Zka6mh34mZ7B2":0.01}]'
```

#### P2PKHトランザクション作成

```
bitcoin-core.cli createrawtransaction  '[{"txid": "c691e521b77f7e59425d9f51b98c9897f2f40bb6165bc595156fb8e69ef3fce7","vout": 0}]' '[{"1JxDJCyWNakZ5kECKdCU9Zka6mh34mZ7B2":0.01}]'
```

```
2f40bb6165bc595156fb8e69ef3fce7","vout": 0}]' '[{"1JxDJCyWNakZ5kECKdCU9Zka6mh34mZ7B2":0.01}]'
0200000001e7fcf39ee6b86f1595c55b16b60bf4f297988cb9519f5d42597e7fb721e591c60000000000ffffffff0140420f00000000001976a914c4eb47ecfdcf609a1848ee79acc2fa49d3caad7088ac00000000
```



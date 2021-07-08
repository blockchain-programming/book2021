# 6章 ビットコインの仕組みの詳細


## 6.1 ビットコイン 発コミュニティとBIP

* [メーリングリスト bitcoin-devZ](https://lists.linuxfoundation.org/mailman/listinfo/bitcoin-dev)
* [Slack: https://bitcoincore.slack.com/](Slack: https://bitcoincore.slack.com/)
* [BIP](https://github.com/bitcoin/bips)


## 6.2 トランザクションタイプと基本構造

### トランザクションのタイプ (output) の例　(outputごとに複数のタイプを含むものもあります)

*  P2PK

    TXID: 2d05f0c9c3e1c226e63b5fac240137687544cf631cd616fd34fd188fc9020866
    
* P2PKH

    TXID: f4515fed3dc4a19b90a317b9840c243bac26114cf637522373a7d486b372600b

*  P2SH

    TXID: f22f36ec877e564f9b0ef237132140ce24c0eec7eb4077b7eab7937a60365af8

*  P2WPKH

    TXID: 9d9463c62424d13bb4e6a64397adeedf5a5a0db8b66243ba779f006a3f87e9e8

*  P2WSH

    TXID: 5f6b4c79fa22595b18267b9c41a1c4d884dbdd845fed5f0d434e603d32b9d90c

### 確認方法

```bash
bitcoin-core.cli getrawtransaction <TXID> true
```

### P2PKの例

```json
  "vin": [
    {
      "coinbase": "04ffff001d014d",
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 50.00000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "04e70a02f5af48a1989bf630d92523c9d14c45c75f7d1b998e962bff6ff9995fc5bdb44f1793b37495d80324acba7c8f537caaf8432b8d47987313060cc82d8a93 OP_CHECKSIG",
        "hex": "4104e70a02f5af48a1989bf630d92523c9d14c45c75f7d1b998e962bff6ff9995fc5bdb44f1793b37495d80324acba7c8f537caaf8432b8d47987313060cc82d8a93ac",
        "type": "pubkey"
      }
    }
  ],

```

### P2PKHの例

```json
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

### P2SHのoutputの例

```json
  "vin": [
    {
      "txid": "f6f96db8fa61dd35fe7cd48dd62c7ad89b1e0a1bef033a3445ae8b1c1546d77a",
      "vout": 10,
      "scriptSig": {
        "asm": "3045022100bfe17996e22644f77ccf1d361d31dc604baeb9f27a713c2aff56c79856f7b5a1022020db753b961f5cf0ac625a35736435136df0a3f1a859c71c9ee5dce85f6dff10[ALL] 03da4467052353b74aba3e4a1c1cc22d11607c7e48423f9d9aaf9a8ead917da223",
        "hex": "483045022100bfe17996e22644f77ccf1d361d31dc604baeb9f27a713c2aff56c79856f7b5a1022020db753b961f5cf0ac625a35736435136df0a3f1a859c71c9ee5dce85f6dff10012103da4467052353b74aba3e4a1c1cc22d11607c7e48423f9d9aaf9a8ead917da223"
      },
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.00163068,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_HASH160 66ff5ed27b4f4f3c0903e1361be622b211049f08 OP_EQUAL",
        "hex": "a91466ff5ed27b4f4f3c0903e1361be622b211049f0887",
        "reqSigs": 1,
        "type": "scripthash",
        "addresses": [
          "3B5cmZFWzPA5Tp3qXhzJeeYbUgB2mZFfxb"
        ]
      }
    },
    {
      "value": 0.00382954,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 a578736c2477e5fdac20efc30fc889ea2243e1fc OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a914a578736c2477e5fdac20efc30fc889ea2243e1fc88ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "1G5vnj4GKTJEzWP9AKvChhtFRE2ZGopyxr"
        ]
      }
    }
  ],
```

### P2WPKHの例

```json
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

```json
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


## 6.3 ビットコインアドレス

### 

## 6.4 トランザクションのタイプと検証スクリプト

## 6.5 ビットコインスクリプトの応用例






---

# 課題

1. P2PK，P2PKH，P2SH，P2WPKH，P2WPSHのoutputをもつトランザクションを作成してください。1. P2PK，P2PKH，P2SH，P2WPKH，P2WPSHのUTXOをinputとするトランザクションを作成してください。outputのタイプはP2WPKHとします。1. 実際にアトミックスワップを行うトランザクションを作成し，アトミックスワップを実施してみてください。


## 1. P2PK，P2PKH，P2SH，P2WPKH，P2WPSHのoutputをもつトランザクションを作成してください。


### 回答例




## 2. P2PK，P2PKH，P2SH，P2WPKH，P2WPSHのUTXOをinputとするトランザクションを作成してください。outputのタイプはP2WPKHとします。

### 回答例

## 3. 実際にアトミックスワップを行うトランザクションを作成し，アトミックスワップを実施してみてください。

### 回答例

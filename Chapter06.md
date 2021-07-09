# 6章 ビットコインの仕組みの詳細

## トランザクションの作成方法の復習

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

### トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```
signrawtransactionwithwallet <トランザクションの16進数形式>
```

### トランザクションのブロードキャスト

```
sendrawtransaction <16進数形式のトランザクション>
```

### トランザクションの作成例

作成するトランザクションの　input(UTXO)　のJSON形式の例


```json
'[{"txid":"50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5","vout":0}]' 
```

output のJSON形式の例

```json
'[{"tb1qj0596apwztduay0ktk6lnhxxcumfz6mnnsykm3":0.001}, {"tb1qc0xxe80njvjxdf26prp2gluth0ge3840dvensy":0.08898818}]'
```

未署名トランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5","vout":0}]' '[{"tb1qj0596apwztduay0ktk6lnhxxcumfz6mnnsykm3":0.001}, {"tb1qc0xxe80njvjxdf26prp2gluth0ge3840dvensy":0.08898818}]'
```

```
0200000001b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf00000000
```

トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```
bitcoin-core.cli signrawtransactionwithwallet 0200000001b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf00000000
```

```
{
  "hex": "0200000001b59f853aecc25ebf06bf93ed21ffc55a6e21f0209371bbe4551342c80008dc500000000000ffffffff02a08601000000000016001493e85d742e12dbce91f65db5f9dcc6c736916b7302c9870000000000160014c3cc6c9df3932466a55a08c2a47f8bbbd1989eaf00000000",
  "complete": false,
  "errors": [
    {
      "txid": "50dc0800c8421355e4bb719320f0216e5ac5ff21ed93bf06bf5ec2ec3a859fb5",
      "vout": 0,
      "witness": [
      ],
      "scriptSig": "",
      "sequence": 4294967295,
      "error": "Input not found or already spent"
    }
  ]
}
```

## bitcoinrb

bitcoinrb はRuby言語によるbitcoin core API をRuby から操作するライブラリです。

[bitcoinrb のインストール方法](https://github.com/ShigeichiroYamasaki/yamalabo/blob/master/bitcoinrb.md)

bitcoinrb の基本操作を


## 6.1 ビットコイン 発コミュニティとBIP

* [メーリングリスト bitcoin-devZ](https://lists.linuxfoundation.org/mailman/listinfo/bitcoin-dev)
* [Slack: https://bitcoincore.slack.com/](Slack: https://bitcoincore.slack.com/)
* [BIP](https://github.com/bitcoin/bips)


## 6.2 トランザクションタイプと基本構造

以下は mainnet の例です。

### トランザクションのタイプ (output) の例

トランザクションのoutputに複数のタイプを含むものもあります

*  P2PK
    TXID: 330aac3434b86bbe99df6d9a93da13e687646b1d7d3a6945be2fa015ebe3b90c
    TXID: c5fe633e6408ac194fbba2c68bd4e8622bcaf9ceb1f29c9efa067ba77bfb424c
    
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
TXID: c5fe633e6408ac194fbba2c68bd4e8622bcaf9ceb1f29c9efa067ba77bfb424c
  "vin": [
    {
      "txid": "bdc50e9a7ab9359dc13fc95940d250105ca231e226658fbafff81ce37fbebbe6",
      "vout": 0,
      "scriptSig": {
        "asm": "3046022100d9f4b5253bf47fa7f4635d57a82b30e68e6b8c19345bc1517fe3242b8ce19d14022100b0176844632fa6629ad50231132b80bb68827f490f85e972bcdc436187b684e3[ALL] 0442754a8776ce6c3efa071ffa8819b720f5b3edd3b8e5b1b3a67852f1e6a87925751b26ccbe9ce04e17078db56dc8e9601794703809ebd38f9befa6f07dcefa8d",
        "hex": "493046022100d9f4b5253bf47fa7f4635d57a82b30e68e6b8c19345bc1517fe3242b8ce19d14022100b0176844632fa6629ad50231132b80bb68827f490f85e972bcdc436187b684e301410442754a8776ce6c3efa071ffa8819b720f5b3edd3b8e5b1b3a67852f1e6a87925751b26ccbe9ce04e17078db56dc8e9601794703809ebd38f9befa6f07dcefa8d"
      },
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.05000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 7a82de81eb240e9fbc216408645368e0a4cdc42c OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a9147a82de81eb240e9fbc216408645368e0a4cdc42c88ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "1CAnDMTJSzwf7py1GKafbz4Kqod7XYkoiY"
        ]
      }
    },
    {
      "value": 383.41000000,
      "n": 1,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 66c1ec75914056b6e33ac710e0e8b7fd9275b5bf OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a91466c1ec75914056b6e33ac710e0e8b7fd9275b5bf88ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "1ANLEcvnVX79Zrk2tbULNWjwUpQywqSPqs"
        ]
      }
    }
  ],
```

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




## 6.3 ビットコインアドレス


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

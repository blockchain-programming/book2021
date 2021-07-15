# 6章 ビットコインの仕組みの詳細


## 6.1 ビットコイン 発コミュニティとBIP

* [メーリングリスト bitcoin-devZ](https://lists.linuxfoundation.org/mailman/listinfo/bitcoin-dev)
* [Slack: https://bitcoincore.slack.com/](Slack: https://bitcoincore.slack.com/)
* [BIP](https://github.com/bitcoin/bips)


## 6.2 6.3 6.4 を一連の流れで演習します　(書籍の節の構成と異なっています)

事前に書籍の６章を通読しておいてください。


0. 事前にsignetのfaucet から0.1BTCビットコインを得ておきます。

1. faucetから得たUTXOをinputとして5個のoutputを持つトランザクションを作成し，署名して，ブロードキャストする

2. 5個のUTXOからそれぞれP2PK, P2PKH, P2SH, P2WPKH, P2WSH の５つのタイプのoutputを持つ5個のトランザクションを作成し，それぞれ署名して，ブロードキャストする

3. 5個のタイプの異なるUTXOをinputとするトランザクションを作成し，署名して，ブロードキャストする

![](./Chapter06-fig1.png)

## 6.2 トランザクションタイプと基本構造

### faucetから得たUTXOをinputとして5個のoutputを持つトランザクションを作成し，署名して，ブロードキャストする

1. ビットコインアドレスを５つ生成する
2. 使用するUTXOを確認する
2. ５つのoutputを持つトランザクションを作成する
3. 作成したトランザクションに署名する
4. 署名したトランザクションをブロードキャストする

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

```

```bash
# 使用するUTXOを確認する
##　"txid" と "vout"

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

```

```bash
# ５つのoutputを持つトランザクションを作成する

bitcoin-core.cli createrawtransaction  '[{"txid":"7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb","vout":0}]' '[{"tb1qz9qum0j3th39wfmqsevyu59kmffmhsu69agu33":0.018}, {"tb1qq8725772xccjes5paehkvxrpg5a5gvx50an2m2":0.02},
{"tb1q668vf52sqv6rqshjqjr5qn25zen7lehzydj69x":0.02},
{"tb1qy986nrg0vtq4lyt6t2n9npm0auzrh0uc4gsv3x":0.02},
{"tb1qeh6j2hjdulv5ede0plqr5hk77g3jrhh08qy97f":0.02}]'

0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0540771b00000000001600141141cdbe515de257276086584e50b6da53bbc39a80841e000000000016001401fcaa7bca36312cc281ee6f661861453b4430d480841e0000000000160014d68ec4d15003343042f20487404d541667efe6e280841e0000000000160014214fa98d0f62c15f917a5aa659876fef043bbf9880841e0000000000160014cdf5255e4de7d94cb72f0fc03a5edef22321deef00000000

```

```bash
# 作成したトランザクションに署名する

bitcoin-core.cli signrawtransactionwithwallet 0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0540771b00000000001600141141cdbe515de257276086584e50b6da53bbc39a80841e000000000016001401fcaa7bca36312cc281ee6f661861453b4430d480841e0000000000160014d68ec4d15003343042f20487404d541667efe6e280841e0000000000160014214fa98d0f62c15f917a5aa659876fef043bbf9880841e0000000000160014cdf5255e4de7d94cb72f0fc03a5edef22321deef00000000

{
  "hex": "02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0540771b00000000001600141141cdbe515de257276086584e50b6da53bbc39a80841e000000000016001401fcaa7bca36312cc281ee6f661861453b4430d480841e0000000000160014d68ec4d15003343042f20487404d541667efe6e280841e0000000000160014214fa98d0f62c15f917a5aa659876fef043bbf9880841e0000000000160014cdf5255e4de7d94cb72f0fc03a5edef22321deef0247304402200b8cb96329e7f8af227b04edf9836a51e8690e3a8db493906dd57fc477b12db40220502e7fbd486aa6c815b061c1294a241d53387e51587a7cb4a58a4692fb199a480121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000",
  "complete": true
}

# 内容の確認

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
```

```bash
# 署名したトランザクションをブロードキャストする

bitcoin-core.cli sendrawtransaction 02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0540771b00000000001600141141cdbe515de257276086584e50b6da53bbc39a80841e000000000016001401fcaa7bca36312cc281ee6f661861453b4430d480841e0000000000160014d68ec4d15003343042f20487404d541667efe6e280841e0000000000160014214fa98d0f62c15f917a5aa659876fef043bbf9880841e0000000000160014cdf5255e4de7d94cb72f0fc03a5edef22321deef0247304402200b8cb96329e7f8af227b04edf9836a51e8690e3a8db493906dd57fc477b12db40220502e7fbd486aa6c815b061c1294a241d53387e51587a7cb4a58a4692fb199a480121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000

b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783

# 10分以上経過後，トランザクションがブロックに格納されたことを確認する

bitcoin-core.cli gettransaction b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783

# UTXOのリストを確認する
bitcoin-core.cli listunspent

[
  {
    "txid": "b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783",
    "vout": 0,
    "address": "tb1qz9qum0j3th39wfmqsevyu59kmffmhsu69agu33",
    "label": "alice",
    "scriptPubKey": "00141141cdbe515de257276086584e50b6da53bbc39a",
    "amount": 0.01800000,
    "confirmations": 376,
    "spendable": true,
    "solvable": true,
    "desc": "wpkh([60d80dee/0'/0'/16']030eff55e82dab5425b79bcd5469b3a19b5d7b95b0287bbd26ae528ec052beed3e)#3msrec96",
    "safe": true
  },
  {
    "txid": "b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783",
    "vout": 1,
    "address": "tb1qq8725772xccjes5paehkvxrpg5a5gvx50an2m2",
    "label": "alice",
    "scriptPubKey": "001401fcaa7bca36312cc281ee6f661861453b4430d4",
    "amount": 0.02000000,
    "confirmations": 376,
    "spendable": true,
    "solvable": true,
    "desc": "wpkh([60d80dee/0'/0'/17']03052dbed2b03c9e9a788740134d40b962d0f4ef20600acb90a9093ed96e0e117e)#fjr3ae92",
    "safe": true
  },
  {
    "txid": "b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783",
    "vout": 2,
    "address": "tb1q668vf52sqv6rqshjqjr5qn25zen7lehzydj69x",
    "label": "alice",
    "scriptPubKey": "0014d68ec4d15003343042f20487404d541667efe6e2",
    "amount": 0.02000000,
    "confirmations": 376,
    "spendable": true,
    "solvable": true,
    "desc": "wpkh([60d80dee/0'/0'/18']028edc7c6b857adcf3e14afc90ed841e496a53ef44f762fa5b30010a0a28a364c1)#vf6v6r2z",
    "safe": true
  },
  {
    "txid": "b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783",
    "vout": 3,
    "address": "tb1qy986nrg0vtq4lyt6t2n9npm0auzrh0uc4gsv3x",
    "label": "alice",
    "scriptPubKey": "0014214fa98d0f62c15f917a5aa659876fef043bbf98",
    "amount": 0.02000000,
    "confirmations": 376,
    "spendable": true,
    "solvable": true,
    "desc": "wpkh([60d80dee/0'/0'/19']026da6a1cdb33a2480e09b2cee3f273e52a7e4cf2477b8144409687f78cc484d4d)#zwluf8lx",
    "safe": true
  },
  {
    "txid": "b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783",
    "vout": 4,
    "address": "tb1qeh6j2hjdulv5ede0plqr5hk77g3jrhh08qy97f",
    "label": "alice",
    "scriptPubKey": "0014cdf5255e4de7d94cb72f0fc03a5edef22321deef",
    "amount": 0.02000000,
    "confirmations": 376,
    "spendable": true,
    "solvable": true,
    "desc": "wpkh([60d80dee/0'/0'/20']03d40d729a618dfd1fd41c633e08eada6d245d9234cf345efb0ab67baf820860b0)#jcs07qqr",
    "safe": true
  }
]
```

作成した５つのUTXOは，それぞれ順にP2PK,　P2PKH，P2SH，P2WPKH，P2WSHの作成実験のために使います。

### 5個のUTXOからそれぞれP2PK, P2PKH, P2SH, P2WPKH, P2WSH の５つのタイプのoutputを持つ5個のトランザクションを作成し，それぞれ署名して，ブロードキャストする

## 6.3 ビットコインアドレス

#### ビットコインアドレスの生成

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

tb1quk3jna5v87rpexc2c6j2jadczcuz4gsmqmffcp
```

### base52 アドレス

```bash
bitcoin-core.cli getnewaddress alice legacy

mtK2eEt7aWajvwJyuzuFG5yrGKfYyU3LMX
```

### マルチシグアドレスの生成（P2SH, P2WSHの例）

```
createmultisig <必要署名数> '[<公開鍵1>,<公開鍵2>,...,<公開鍵m>]' <アドレスタイプ>
```

アドレスタイプ

* legacy
* bech32
* p2sh-segwit (後方互換のため，bech32アドレスをP2SHでラップしたアドレス)

#### アドレスごとの公開鍵の確認

```
getaddressinfo <ビットコインアドレス>
```
"pubkey": 公開鍵

* mwyP3Yk57aPoWjmH6h6eTSQscPAU55wF7H
    * 公開鍵:0396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d
* mmhVgnijoaFnTnkqSxcFgV6mDTU38PoiaE
    * 公開鍵:0339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f41
* mx3gd8r6k26mHosR55yz4ytn1XEjTVdQ7P
    * 公開鍵:024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d


* tb1qqdkw3a0vry8kf50f08z425d4lwxgl0ms0c5eyp
    * 公開鍵:0346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c6013775958
* tb1qrtqa7t3aytdw24p793kgyvqduldxf6njazkxqg
    * 公開鍵:03d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b814476
* tb1q8uxaeukj8uaagz8e2lucpqwnl5rnxptkx6sgdu
    * 公開鍵:03e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e595

#### P2SH 用マルチシグアドレス

legacy

```json
bitcoin-core.cli createmultisig 2 '["0396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d","0339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f41","024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d"]' legacy


{
  "address": "2NFDXwLJm87sDmfosTivDkMUbw2Q8Ze8ktF",
  "redeemScript": "52210396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d210339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f4121024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d53ae",
  "descriptor": "sh(multi(2,0396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d,0339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f41,024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d))#qsun2edu"
}
```

P2SH アドレス

* 2NFDXwLJm87sDmfosTivDkMUbw2Q8Ze8ktF

#### P2WSH用マルチシグアドレス

Bech32

```json
bitcoin-core.cli createmultisig 2 '["0346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c6013775958","03d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b814476","03e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e595"]' bech32


{
  "address": "tb1q8ngpnf4g4z95xfdv72m7hatc8yafna8dqcprd5psc7ue4sc7uzrs4avaje",
  "redeemScript": "52210346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c60137759582103d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b8144762103e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e59553ae",
  "descriptor": "wsh(multi(2,0346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c6013775958,03d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b814476,03e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e595))#p2l5aa90"
}
```

P2WSHアドレス

* tb1q8ngpnf4g4z95xfdv72m7hatc8yafna8dqcprd5psc7ue4sc7uzrs4avaje

## 6.4 トランザクションのタイプと検証スクリプト


### 6.4.1 P2PK（output）トランザクションの作成

（P2PKは難易度が高いので最後の6.4.6 にまわします）


### 6.4.2 P2PKH（output）トランザクションの作成

送金先アドレスを legacy なP2PKHにすればよい

```
bitcoin-core.cli getnewaddress alice legacy
msLvK34H6sL36oD32Vy58KX4myf7e7gnjG
```
* msLvK34H6sL36oD32Vy58KX4myf7e7gnjG


input(UTXO)　のJSON形式の例
```json
'[{"txid":"b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783","vout":1}]' 
```

output のJSON形式の例
```json
'[{"msLvK34H6sL36oD32Vy58KX4myf7e7gnjG":0.0198}]'
```

未署名トランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783","vout":1}]'  '[{"msLvK34H6sL36oD32Vy58KX4myf7e7gnjG":0.0198}]'


020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20100000000ffffffff0160361e00000000001976a91481bbb1c4c0db9739ca2daf11e32470e6a052cdaa88ac00000000
```

トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```
bitcoin-core.cli signrawtransactionwithwallet 020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20100000000ffffffff0160361e00000000001976a91481bbb1c4c0db9739ca2daf11e32470e6a052cdaa88ac00000000


{
  "hex": "0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20100000000ffffffff0160361e00000000001976a91481bbb1c4c0db9739ca2daf11e32470e6a052cdaa88ac024730440220187aa0885dad99420d07e6923f9f0e7005351d2a796fd4a733c15ff52eeacb50022070a8c096c64e85fa62820a805c710086a2f0b2b1414a81b7154bc318f827fded012103052dbed2b03c9e9a788740134d40b962d0f4ef20600acb90a9093ed96e0e117e00000000",
  "complete": true
}
```

作成したトランザクションの確認

voutのタイプを確認してください

```json
bitcoin-core.cli decoderawtransaction 0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20100000000ffffffff0160361e00000000001976a91481bbb1c4c0db9739ca2daf11e32470e6a052cdaa88ac024730440220187aa0885dad99420d07e6923f9f0e7005351d2a796fd4a733c15ff52eeacb50022070a8c096c64e85fa62820a805c710086a2f0b2b1414a81b7154bc318f827fded012103052dbed2b03c9e9a788740134d40b962d0f4ef20600acb90a9093ed96e0e117e00000000


{
  "txid": "01a4d2228d6264d9bbc5761b39671cc83e93ccce5141470f193829ae8cdd888a",
  "hash": "8d9dd644a6e457f57f8ffe8f67fabb590cfa60244fed0d744040ca09c9cca933",
  "version": 2,
  "size": 194,
  "vsize": 113,
  "weight": 449,
  "locktime": 0,
  "vin": [
    {
      "txid": "b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783",
      "vout": 1,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "30440220187aa0885dad99420d07e6923f9f0e7005351d2a796fd4a733c15ff52eeacb50022070a8c096c64e85fa62820a805c710086a2f0b2b1414a81b7154bc318f827fded01",
        "03052dbed2b03c9e9a788740134d40b962d0f4ef20600acb90a9093ed96e0e117e"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.01980000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_DUP OP_HASH160 81bbb1c4c0db9739ca2daf11e32470e6a052cdaa OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a91481bbb1c4c0db9739ca2daf11e32470e6a052cdaa88ac",
        "reqSigs": 1,
        "type": "pubkeyhash",
        "addresses": [
          "msLvK34H6sL36oD32Vy58KX4myf7e7gnjG"
        ]
      }
    }
  ]
}


```

### 6.4.3 P2SH（output）トランザクションの作成

送金先アドレスを 6.3 で生成した P2SH アドレスにすればよい

* 2NFDXwLJm87sDmfosTivDkMUbw2Q8Ze8ktF


input(UTXO)　のJSON形式の例

```json
'[{"txid":"b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783","vout":2}]' 
```

output のJSON形式の例

```json
'[{"2NFDXwLJm87sDmfosTivDkMUbw2Q8Ze8ktF":0.0198}]'
```

未署名トランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783","vout":2}]'  '[{"2NFDXwLJm87sDmfosTivDkMUbw2Q8Ze8ktF":0.0198}]'


020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20200000000ffffffff0160361e000000000017a914f100eb22e91b65c5c24e3cb31fc6e571e57e10718700000000
```

トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```
bitcoin-core.cli signrawtransactionwithwallet 020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20200000000ffffffff0160361e000000000017a914f100eb22e91b65c5c24e3cb31fc6e571e57e10718700000000


{
  "hex": "0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20200000000ffffffff0160361e000000000017a914f100eb22e91b65c5c24e3cb31fc6e571e57e10718702473044022030e86cc52a0096fac0e21dc9437f0f53a91f82d4818580adcce06580685ae10b022037d89c72963f493707b7ad67c66c2f5892879cba108afcf2218cb4f58714f6e30121028edc7c6b857adcf3e14afc90ed841e496a53ef44f762fa5b30010a0a28a364c100000000",
  "complete": true
}
```

作成したトランザクションの確認

voutのタイプを確認してください

```json
bitcoin-core.cli decoderawtransaction 0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20200000000ffffffff0160361e000000000017a914f100eb22e91b65c5c24e3cb31fc6e571e57e10718702473044022030e86cc52a0096fac0e21dc9437f0f53a91f82d4818580adcce06580685ae10b022037d89c72963f493707b7ad67c66c2f5892879cba108afcf2218cb4f58714f6e30121028edc7c6b857adcf3e14afc90ed841e496a53ef44f762fa5b30010a0a28a364c100000000


{
  "txid": "fbe48c9501b3cd40e2799df464bea9d8f3f3c6bed36a71499636105af11508e9",
  "hash": "75a6310542e9908f9a3c571d09d433094fc8fde59e5b3557e7527b29609efd3e",
  "version": 2,
  "size": 192,
  "vsize": 111,
  "weight": 441,
  "locktime": 0,
  "vin": [
    {
      "txid": "b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783",
      "vout": 2,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "3044022030e86cc52a0096fac0e21dc9437f0f53a91f82d4818580adcce06580685ae10b022037d89c72963f493707b7ad67c66c2f5892879cba108afcf2218cb4f58714f6e301",
        "028edc7c6b857adcf3e14afc90ed841e496a53ef44f762fa5b30010a0a28a364c1"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.01980000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_HASH160 f100eb22e91b65c5c24e3cb31fc6e571e57e1071 OP_EQUAL",
        "hex": "a914f100eb22e91b65c5c24e3cb31fc6e571e57e107187",
        "reqSigs": 1,
        "type": "scripthash",
        "addresses": [
          "2NFDXwLJm87sDmfosTivDkMUbw2Q8Ze8ktF"
        ]
      }
    }
  ]
}
```

### 6.4.4 P2WPKH（output）トランザクションの作成

送金先アドレスを　P2WPKH アドレスにすればよい

* tb1qz3uh04vpttfupqrh3msn4jkf694wmy7cfrtzrn


input(UTXO)　のJSON形式の例

```json
'[{"txid":"b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783","vout":3}]' 
```

output のJSON形式の例

```json
'[{"tb1qz3uh04vpttfupqrh3msn4jkf694wmy7cfrtzrn":0.0198}]'
```

未署名トランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783","vout":3}]' '[{"tb1qz3uh04vpttfupqrh3msn4jkf694wmy7cfrtzrn":0.0198}]'

020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20300000000ffffffff0160361e0000000000160014147977d5815ad3c080778ee13acac9d16aed93d800000000
```

トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```
bitcoin-core.cli signrawtransactionwithwallet 020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20300000000ffffffff0160361e0000000000160014147977d5815ad3c080778ee13acac9d16aed93d800000000

{
  "hex": "0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20300000000ffffffff0160361e0000000000160014147977d5815ad3c080778ee13acac9d16aed93d8024730440220092bc813dccd3bbe98f1586a34f49739362d4236e402b177c16dc715ccd9c56502202792454a0617da3aa5afc6774af4c961d41b007cf473f2a0ff7f8c475f2b7c740121026da6a1cdb33a2480e09b2cee3f273e52a7e4cf2477b8144409687f78cc484d4d00000000",
  "complete": true
}
```

voutのタイプを確認してください

```json
bitcoin-core.cli decoderawtransaction 0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20300000000ffffffff0160361e0000000000160014147977d5815ad3c080778ee13acac9d16aed93d8024730440220092bc813dccd3bbe98f1586a34f49739362d4236e402b177c16dc715ccd9c56502202792454a0617da3aa5afc6774af4c961d41b007cf473f2a0ff7f8c475f2b7c740121026da6a1cdb33a2480e09b2cee3f273e52a7e4cf2477b8144409687f78cc484d4d00000000


{
  "txid": "dd8173e708bed98cf6a66bc41bdada065e62d7eb57300115a60a42e35914b984",
  "hash": "cfb3516dcd4290ec81e01d619ac43187364682dd0b828e2a94c651ec0edfbe73",
  "version": 2,
  "size": 191,
  "vsize": 110,
  "weight": 437,
  "locktime": 0,
  "vin": [
    {
      "txid": "b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783",
      "vout": 3,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "30440220092bc813dccd3bbe98f1586a34f49739362d4236e402b177c16dc715ccd9c56502202792454a0617da3aa5afc6774af4c961d41b007cf473f2a0ff7f8c475f2b7c7401",
        "026da6a1cdb33a2480e09b2cee3f273e52a7e4cf2477b8144409687f78cc484d4d"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.01980000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 147977d5815ad3c080778ee13acac9d16aed93d8",
        "hex": "0014147977d5815ad3c080778ee13acac9d16aed93d8",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qz3uh04vpttfupqrh3msn4jkf694wmy7cfrtzrn"
        ]
      }
    }
  ]
}
```

### 6.4.5 P2WSH（output）トランザクションの作成

送金先アドレスを　6.3 で生成したP2WSH アドレスにすればよい

* tb1q8ngpnf4g4z95xfdv72m7hatc8yafna8dqcprd5psc7ue4sc7uzrs4avaje


input(UTXO)　のJSON形式の例

```json
'[{"txid":"b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783","vout":4}]' 
```

output のJSON形式の例

```json
'[{"tb1q8ngpnf4g4z95xfdv72m7hatc8yafna8dqcprd5psc7ue4sc7uzrs4avaje":0.0198}]'
```

未署名トランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783","vout":4}]' '[{"tb1q8ngpnf4g4z95xfdv72m7hatc8yafna8dqcprd5psc7ue4sc7uzrs4avaje":0.0198}]'

020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20400000000ffffffff0160361e00000000002200203cd019a6a8a88b4325acf2b7ebf578393a99f4ed060236d030c7b99ac31ee08700000000
```

トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```
bitcoin-core.cli signrawtransactionwithwallet 020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20400000000ffffffff0160361e00000000002200203cd019a6a8a88b4325acf2b7ebf578393a99f4ed060236d030c7b99ac31ee08700000000

{
  "hex": "0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20400000000ffffffff0160361e00000000002200203cd019a6a8a88b4325acf2b7ebf578393a99f4ed060236d030c7b99ac31ee0870247304402200b2689214e8ae74af9db450069e80ea5136fb7dc9cd06399a546c45f3dcaa1ad022032250fea21e9f46eed4541a81ab260c3085e91798b2dff2b491403bd2bd624a8012103d40d729a618dfd1fd41c633e08eada6d245d9234cf345efb0ab67baf820860b000000000",
  "complete": true
}
```

作成したトランザクションの確認

voutのタイプを確認してください

```json
bitcoin-core.cli decoderawtransaction 0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20400000000ffffffff0160361e00000000002200203cd019a6a8a88b4325acf2b7ebf578393a99f4ed060236d030c7b99ac31ee0870247304402200b2689214e8ae74af9db450069e80ea5136fb7dc9cd06399a546c45f3dcaa1ad022032250fea21e9f46eed4541a81ab260c3085e91798b2dff2b491403bd2bd624a8012103d40d729a618dfd1fd41c633e08eada6d245d9234cf345efb0ab67baf820860b000000000

{
  "txid": "95ccd50a75ab3bb3767df0b7669f3472965f8d1598feab7cb424f1862857ca8f",
  "hash": "1dff3a9dc26deeb9db625e6b743146b41e34a97e9bba94f12662b2a8bc0b4a79",
  "version": 2,
  "size": 203,
  "vsize": 122,
  "weight": 485,
  "locktime": 0,
  "vin": [
    {
      "txid": "b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783",
      "vout": 4,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "304402200b2689214e8ae74af9db450069e80ea5136fb7dc9cd06399a546c45f3dcaa1ad022032250fea21e9f46eed4541a81ab260c3085e91798b2dff2b491403bd2bd624a801",
        "03d40d729a618dfd1fd41c633e08eada6d245d9234cf345efb0ab67baf820860b0"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.01980000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 3cd019a6a8a88b4325acf2b7ebf578393a99f4ed060236d030c7b99ac31ee087",
        "hex": "00203cd019a6a8a88b4325acf2b7ebf578393a99f4ed060236d030c7b99ac31ee087",
        "reqSigs": 1,
        "type": "witness_v0_scripthash",
        "addresses": [
          "tb1q8ngpnf4g4z95xfdv72m7hatc8yafna8dqcprd5psc7ue4sc7uzrs4avaje"
        ]
      }
    }
  ]
}
```

### 6.4.6 P2PK（output）トランザクションの作成

bitcoin core のAPIでは　P2PKのトランザクション作成機能は削除されているので，自分でトランザクションの内容を仕様にそって自作する必要があります。

* input がポイントするUTXOのTXIDはリトルエンディアン
* ScriptPubkeyの最後の１バイトは， OP_CHECKSIG (コードは16進数で "ac")
* valueの値は送金金額の単位が 1億分の1 BTC = 1 satoshi
* valueの値は 8バイトのリトルエンディアンであることに注意が必要です。

#### リトルエンディアン変換

Rubyのビッグエンディアンからリトルエンディアンへの変換プログラム

```ruby
be =  "00000000001de840"
le=[be].pack('H*').reverse.unpack('H*')[0]
"40e81d0000000000"
```

outputのvalue: 0.0178 BTC

```
0.0178 btc=1780000 satoshi 
8バイトの16進数では，00000000001b2920
8バイトのリトルエンディアン表現にすると
20291b0000000000
```


* トランザクション

|フィールド|内容|
|:--|:--|
|version| 02000000|
|inputの数|01|
|input||
|outputの数|01|
|output||
|nLocTime| 00000000 |

トランザクションデータの連結結果

```
02000000
01<input>
01<output>
00000000
```

input (UTXO)

* b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783
*  "83472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b2"(リトルエンディアン)
* vout:0

|フィールド|内容|
|:--|:--|
|トランザクションID| 83472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b2 |
|txout index|0000000000|
|ScriptSigサイズ|空|
| ScriptSig |空|
|nSequence|ffffffff|


inputデータの連結結果

```
83472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20000000000ffffffff
```

* output 


|フィールド|内容|
|:--|:--|
|value| 20291b0000000000 |
|scriputPubKeyのバイト数| 23|
|scriputPubKey|21(公開鍵のバイト数 16進数）|
|送金先公開鍵| 027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851|
| OP_CHECKSIG| ac|


outputデータの連結結果

```
20291b00000000002321027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851ac
```

トランザクションの作成

```
02000000
0183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20000000000ffffffff
0120291b00000000002321027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851ac
00000000
```

```
bitcoin-core.cli decoderawtransaction 020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20000000000ffffffff0120291b00000000002321027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851ac00000000

{
  "txid": "01c041f15baaf8e75d09d24335be445fae39d322688788be1556f5436fe3dbbb",
  "hash": "01c041f15baaf8e75d09d24335be445fae39d322688788be1556f5436fe3dbbb",
  "version": 2,
  "size": 95,
  "vsize": 95,
  "weight": 380,
  "locktime": 0,
  "vin": [
    {
      "txid": "b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783",
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
      "value": 0.01780000,
      "n": 0,
      "scriptPubKey": {
        "asm": "027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851 OP_CHECKSIG",
        "hex": "21027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851ac",
        "type": "pubkey"
      }
    }
  ]
}
```


作成したトランザクションへの署名

```
bitcoin-core.cli signrawtransactionwithwallet 020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20000000000ffffffff0120291b00000000002321027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851ac00000000


{
  "hex": "0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20000000000ffffffff0120291b00000000002321027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851ac0247304402201fdc6bb70a878b941adb30a094fd35ca43964ede720b252eb93b08a7f3e9343f02203cc5a937275278dafb515a3b45ebd29c8603dbb324ca0d7f618cdf833bb20e9c0121030eff55e82dab5425b79bcd5469b3a19b5d7b95b0287bbd26ae528ec052beed3e00000000",
  "complete": true
}

```

作成したトランザクションの確認

voutのタイプを確認してください

```json
bitcoin-core.cli decoderawtransaction 0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20000000000ffffffff0120291b00000000002321027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851ac0247304402201fdc6bb70a878b941adb30a094fd35ca43964ede720b252eb93b08a7f3e9343f02203cc5a937275278dafb515a3b45ebd29c8603dbb324ca0d7f618cdf833bb20e9c0121030eff55e82dab5425b79bcd5469b3a19b5d7b95b0287bbd26ae528ec052beed3e00000000


{
  "txid": "01c041f15baaf8e75d09d24335be445fae39d322688788be1556f5436fe3dbbb",
  "hash": "2fe3f6a705ef89f00a946e0b8da14e70e4705a33a96eda7a72c817d529623938",
  "version": 2,
  "size": 204,
  "vsize": 123,
  "weight": 489,
  "locktime": 0,
  "vin": [
    {
      "txid": "b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "304402201fdc6bb70a878b941adb30a094fd35ca43964ede720b252eb93b08a7f3e9343f02203cc5a937275278dafb515a3b45ebd29c8603dbb324ca0d7f618cdf833bb20e9c01",
        "030eff55e82dab5425b79bcd5469b3a19b5d7b95b0287bbd26ae528ec052beed3e"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.01780000,
      "n": 0,
      "scriptPubKey": {
        "asm": "027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851 OP_CHECKSIG",
        "hex": "21027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851ac",
        "type": "pubkey"
      }
    }
  ]
}
```

### 6.4.7 5つのトランザクションをブロードキャストする

トランザクションの内容をよく確認してください。

```bash
# P2PK
bitcoin-core.cli sendrawtransaction 0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20000000000ffffffff0120291b00000000002321027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851ac0247304402201fdc6bb70a878b941adb30a094fd35ca43964ede720b252eb93b08a7f3e9343f02203cc5a937275278dafb515a3b45ebd29c8603dbb324ca0d7f618cdf833bb20e9c0121030eff55e82dab5425b79bcd5469b3a19b5d7b95b0287bbd26ae528ec052beed3e00000000

TXID
01c041f15baaf8e75d09d24335be445fae39d322688788be1556f5436fe3dbbb

# P2PKH
bitcoin-core.cli sendrawtransaction 0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20100000000ffffffff0160361e00000000001976a91481bbb1c4c0db9739ca2daf11e32470e6a052cdaa88ac024730440220187aa0885dad99420d07e6923f9f0e7005351d2a796fd4a733c15ff52eeacb50022070a8c096c64e85fa62820a805c710086a2f0b2b1414a81b7154bc318f827fded012103052dbed2b03c9e9a788740134d40b962d0f4ef20600acb90a9093ed96e0e117e00000000

TXID
01a4d2228d6264d9bbc5761b39671cc83e93ccce5141470f193829ae8cdd888a

# P2SH
bitcoin-core.cli sendrawtransaction 0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20200000000ffffffff0160361e000000000017a914f100eb22e91b65c5c24e3cb31fc6e571e57e10718702473044022030e86cc52a0096fac0e21dc9437f0f53a91f82d4818580adcce06580685ae10b022037d89c72963f493707b7ad67c66c2f5892879cba108afcf2218cb4f58714f6e30121028edc7c6b857adcf3e14afc90ed841e496a53ef44f762fa5b30010a0a28a364c100000000

TXID
fbe48c9501b3cd40e2799df464bea9d8f3f3c6bed36a71499636105af11508e9

# P2WPKH
bitcoin-core.cli sendrawtransaction 0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20300000000ffffffff0160361e0000000000160014147977d5815ad3c080778ee13acac9d16aed93d8024730440220092bc813dccd3bbe98f1586a34f49739362d4236e402b177c16dc715ccd9c56502202792454a0617da3aa5afc6774af4c961d41b007cf473f2a0ff7f8c475f2b7c740121026da6a1cdb33a2480e09b2cee3f273e52a7e4cf2477b8144409687f78cc484d4d00000000

TXID
dd8173e708bed98cf6a66bc41bdada065e62d7eb57300115a60a42e35914b984

# P2WSH
bitcoin-core.cli sendrawtransaction 0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20400000000ffffffff0160361e00000000002200203cd019a6a8a88b4325acf2b7ebf578393a99f4ed060236d030c7b99ac31ee0870247304402200b2689214e8ae74af9db450069e80ea5136fb7dc9cd06399a546c45f3dcaa1ad022032250fea21e9f46eed4541a81ab260c3085e91798b2dff2b491403bd2bd624a8012103d40d729a618dfd1fd41c633e08eada6d245d9234cf345efb0ab67baf820860b000000000

TXID
95ccd50a75ab3bb3767df0b7669f3472965f8d1598feab7cb424f1862857ca8f
```

ビットコインネットワークで確認され，ブロックに格納されるまで10分以上待ってください。

### 6.4.8 5種類のUTXOを消費するトランザクションの作成とブロードキャスト












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
# 付録


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



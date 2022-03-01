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
    3.1. P2PK のoutput を持つトランザクションの作成はバイナリ形式で作成する必要があります

3. 5個のタイプの異なるUTXOをinputとするトランザクションを作成
    3.1 P2SH, P2WSH のUTXOをワレットに認識させる必要があります。

4. トランザクションへの署名してブロードキャスト

![](./Chapter06-fig1.png)

## 6.2 トランザクションタイプと基本構造

### faucetから得たUTXOをinputとして5個のoutputを持つトランザクションを作成し，署名して，ブロードキャストする

1. ビットコインアドレスを５つ生成する
2. 使用するUTXOを確認する
3. ５つのoutputを持つトランザクションを作成する
4. 作成したトランザクションに署名する
5. 署名したトランザクションをブロードキャストする

#### ビットコインアドレスを５つ生成する

```bash
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

#### 使用するUTXOを確認する

```bash
# 　"txid" と "vout"

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

#### ５つのoutputを持つトランザクションを作成する

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"7003aa2517c6b6c18e0f4d9dc51b4018456905e74f6a8e4fdd41e5ce4d89dcfb","vout":0}]' '[{"tb1qz9qum0j3th39wfmqsevyu59kmffmhsu69agu33":0.018}, {"tb1qq8725772xccjes5paehkvxrpg5a5gvx50an2m2":0.02},
{"tb1q668vf52sqv6rqshjqjr5qn25zen7lehzydj69x":0.02},
{"tb1qy986nrg0vtq4lyt6t2n9npm0auzrh0uc4gsv3x":0.02},
{"tb1qeh6j2hjdulv5ede0plqr5hk77g3jrhh08qy97f":0.02}]'

0200000001fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0540771b00000000001600141141cdbe515de257276086584e50b6da53bbc39a80841e000000000016001401fcaa7bca36312cc281ee6f661861453b4430d480841e0000000000160014d68ec4d15003343042f20487404d541667efe6e280841e0000000000160014214fa98d0f62c15f917a5aa659876fef043bbf9880841e0000000000160014cdf5255e4de7d94cb72f0fc03a5edef22321deef00000000
```

#### 作成したトランザクションに署名する

```bash
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

#### 署名したトランザクションをブロードキャストする

```bash
bitcoin-core.cli sendrawtransaction 02000000000101fbdc894dcee541dd4f8e6a4fe705694518401bc59d4d0f8ec1b6c61725aa03700000000000ffffffff0540771b00000000001600141141cdbe515de257276086584e50b6da53bbc39a80841e000000000016001401fcaa7bca36312cc281ee6f661861453b4430d480841e0000000000160014d68ec4d15003343042f20487404d541667efe6e280841e0000000000160014214fa98d0f62c15f917a5aa659876fef043bbf9880841e0000000000160014cdf5255e4de7d94cb72f0fc03a5edef22321deef0247304402200b8cb96329e7f8af227b04edf9836a51e8690e3a8db493906dd57fc477b12db40220502e7fbd486aa6c815b061c1294a241d53387e51587a7cb4a58a4692fb199a480121029805218af17819d68ec23c11456606736c5a9b91b6cee591205e7e3f753e4aac00000000

b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783
```

#### 10分以上経過後，トランザクションがブロックに格納されたことを確認する

```bash
bitcoin-core.cli gettransaction b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783
```

#### UTXOのリストを確認する

```json
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
* p2sh-segwit (SegWit導入時の後方互換性維持のため，bech32アドレスをP2SHでラップしたアドレス)

#### アドレスごとの公開鍵の確認

マルチシグアドレスの生成には公開鍵が必要です。

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

```
createmultisig <必要署名数> '[<公開鍵>, ..., <公開鍵>]' <アドレスタイプ>
```

結果

```
{                            (json object)
  "address" : "str",         (string) The value of the new multisig address.
  "redeemScript" : "hex",    (string) The string value of the hex-encoded redemption script.
  "descriptor" : "str"       (string) The descriptor for this multisig
}
```

legacy(公開鍵の順序が変わるとアドレスなども変わることに注意！)

1. "0396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d"
2. "0339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f41"
3. "024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d"

```json
bitcoin-core.cli createmultisig 2 '["0396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d","0339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f41","024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d"]' legacy


{
  "address": "2NFDXwLJm87sDmfosTivDkMUbw2Q8Ze8ktF",
  "redeemScript": "52210396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d210339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f4121024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d53ae",
  "descriptor": "sh(multi(2,0396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d,0339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f41,024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d))#qsun2edu"
}
```

* P2SH アドレス

```
2NFDXwLJm87sDmfosTivDkMUbw2Q8Ze8ktF
```

* redeemScript

```
52210396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d210339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f4121024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d53ae
```

* descriptor

```
"sh(multi(2,0396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d,0339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f41,024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d))#qsun2edu"
```

#### P2WSH用マルチシグアドレス

Bech32

1. "0346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c6013775958"
2. "03d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b814476"
3. "03e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e595"

```json
bitcoin-core.cli createmultisig 2 '["0346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c6013775958","03d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b814476","03e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e595"]' bech32


{
  "address": "tb1q8ngpnf4g4z95xfdv72m7hatc8yafna8dqcprd5psc7ue4sc7uzrs4avaje",
  "redeemScript": "52210346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c60137759582103d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b8144762103e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e59553ae",
  "descriptor": "wsh(multi(2,0346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c6013775958,03d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b814476,03e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e595))#p2l5aa90"
}
```

* P2WSHアドレス

```
tb1q8ngpnf4g4z95xfdv72m7hatc8yafna8dqcprd5psc7ue4sc7uzrs4avaje
```

* redeemScript

```
52210346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c60137759582103d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b8144762103e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e59553ae
```

* descriptor

```
"wsh(multi(2,0346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c6013775958,03d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b814476,03e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e595))#p2l5aa90"
```

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

* output のJSON形式の例

```json
'[{"msLvK34H6sL36oD32Vy58KX4myf7e7gnjG":0.0198}]'
```

* 未署名トランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783","vout":1}]'  '[{"msLvK34H6sL36oD32Vy58KX4myf7e7gnjG":0.0198}]'


020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20100000000ffffffff0160361e00000000001976a91481bbb1c4c0db9739ca2daf11e32470e6a052cdaa88ac00000000
```

* トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```json
bitcoin-core.cli signrawtransactionwithwallet 020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20100000000ffffffff0160361e00000000001976a91481bbb1c4c0db9739ca2daf11e32470e6a052cdaa88ac00000000


{
  "hex": "0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20100000000ffffffff0160361e00000000001976a91481bbb1c4c0db9739ca2daf11e32470e6a052cdaa88ac024730440220187aa0885dad99420d07e6923f9f0e7005351d2a796fd4a733c15ff52eeacb50022070a8c096c64e85fa62820a805c710086a2f0b2b1414a81b7154bc318f827fded012103052dbed2b03c9e9a788740134d40b962d0f4ef20600acb90a9093ed96e0e117e00000000",
  "complete": true
}
```

* 作成したトランザクションの確認

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

* redeemScript

```
52210396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d210339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f4121024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d53ae
```

* input(UTXO)　のJSON形式の例

```json
'[{"txid":"b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783","vout":2}]' 
```

* output のJSON形式の例

```json
'[{"2NFDXwLJm87sDmfosTivDkMUbw2Q8Ze8ktF":0.0198}]'
```

* 未署名トランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783","vout":2}]'  '[{"2NFDXwLJm87sDmfosTivDkMUbw2Q8Ze8ktF":0.0198}]'


020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20200000000ffffffff0160361e000000000017a914f100eb22e91b65c5c24e3cb31fc6e571e57e10718700000000
```

* トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```json
bitcoin-core.cli signrawtransactionwithwallet 020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20200000000ffffffff0160361e000000000017a914f100eb22e91b65c5c24e3cb31fc6e571e57e10718700000000


{
  "hex": "0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20200000000ffffffff0160361e000000000017a914f100eb22e91b65c5c24e3cb31fc6e571e57e10718702473044022030e86cc52a0096fac0e21dc9437f0f53a91f82d4818580adcce06580685ae10b022037d89c72963f493707b7ad67c66c2f5892879cba108afcf2218cb4f58714f6e30121028edc7c6b857adcf3e14afc90ed841e496a53ef44f762fa5b30010a0a28a364c100000000",
  "complete": true
}
```

* 作成したトランザクションの確認

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

```json
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

* redeemScript

```
52210346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c60137759582103d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b8144762103e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e59553ae
```

* input(UTXO)　のJSON形式の例

```json
'[{"txid":"b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783","vout":4}]' 
```

* output のJSON形式の例

```json
'[{"tb1q8ngpnf4g4z95xfdv72m7hatc8yafna8dqcprd5psc7ue4sc7uzrs4avaje":0.0198}]'
```

* 未署名トランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783","vout":4}]' '[{"tb1q8ngpnf4g4z95xfdv72m7hatc8yafna8dqcprd5psc7ue4sc7uzrs4avaje":0.0198}]'

020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20400000000ffffffff0160361e00000000002200203cd019a6a8a88b4325acf2b7ebf578393a99f4ed060236d030c7b99ac31ee08700000000
```

* トランザクションへのデジタル署名（ワレットの秘密鍵を利用）

```json
bitcoin-core.cli signrawtransactionwithwallet 020000000183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20400000000ffffffff0160361e00000000002200203cd019a6a8a88b4325acf2b7ebf578393a99f4ed060236d030c7b99ac31ee08700000000

{
  "hex": "0200000000010183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20400000000ffffffff0160361e00000000002200203cd019a6a8a88b4325acf2b7ebf578393a99f4ed060236d030c7b99ac31ee0870247304402200b2689214e8ae74af9db450069e80ea5136fb7dc9cd06399a546c45f3dcaa1ad022032250fea21e9f46eed4541a81ab260c3085e91798b2dff2b491403bd2bd624a8012103d40d729a618dfd1fd41c633e08eada6d245d9234cf345efb0ab67baf820860b000000000",
  "complete": true
}
```

* 作成したトランザクションの確認

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

* outputのvalue: 0.0178 BTC

```
0.0178 btc=1780000 satoshi 
8バイトの16進数では，00000000001b2920
8バイトのリトルエンディアン表現にすると
20291b0000000000
```

* トランザクション

| フィールド    | 内容       |
|:-------- |:-------- |
| version  | 02000000 |
| inputの数  | 01       |
| input    |          |
| outputの数 | 01       |
| output   |          |
| nLocTime | 00000000 |

トランザクションデータの連結結果

```
02000000
01<input>
01<output>
00000000
```

input (UTXO)

* b2352ac43e06e1ca2d3c0ba46e16b6e6543d30617a650661e3e8db7b292c4783
* "83472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b2"(リトルエンディアン)
* vout:0

| フィールド        | 内容                                                               |
|:------------ |:---------------------------------------------------------------- |
| トランザクションID   | 83472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b2 |
| txout index  | 0000000000                                                       |
| ScriptSigサイズ | 空                                                                |
| ScriptSig    | 空                                                                |
| nSequence    | ffffffff                                                         |

inputデータの連結結果

```
83472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20000000000ffffffff
```

* output 

| フィールド              | 内容                                                                 |
|:------------------ |:------------------------------------------------------------------ |
| value              | 20291b0000000000                                                   |
| scriputPubKeyのバイト数 | 23                                                                 |
| scriputPubKey      | 21(公開鍵のバイト数 16進数）                                                  |
| 送金先公開鍵             | 027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851 |
| OP_CHECKSIG        | ac                                                                 |

* outputデータの連結結果

```
20291b00000000002321027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851ac
```

* トランザクションの作成

```
02000000
0183472c297bdbe8e36106657a61303d54e6b6166ea40b3c2dcae1063ec42a35b20000000000ffffffff
0120291b00000000002321027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851ac
00000000
```

```json
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

* 作成したトランザクションへの署名

```json
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

### 6.4.8 5種類のUTXOを消費するトランザクションの作成

#### UTXOの確認

この時点で　bitcoin core のワレット機能でUTXOとして確認可能なものは　P2PK, P2PKH, P2WPKH のoutputだけです。

P2SHとP2WSHのUTXOは，ワレットには認識されません。

```json
bitcoin-core.cli listunspent
[
  {
    "txid": "dd8173e708bed98cf6a66bc41bdada065e62d7eb57300115a60a42e35914b984",
    "vout": 0,
    "address": "tb1qz3uh04vpttfupqrh3msn4jkf694wmy7cfrtzrn",
    "label": "",
    "scriptPubKey": "0014147977d5815ad3c080778ee13acac9d16aed93d8",
    "amount": 0.01980000,
    "confirmations": 208,
    "spendable": true,
    "solvable": true,
    "desc": "wpkh([60d80dee/0'/0'/34']0307de5755de6328a3d68a60a342128326d996271b251c7ab11cedcaf972a1f36c)#njlw3azr",
    "safe": true
  },
  {
    "txid": "01a4d2228d6264d9bbc5761b39671cc83e93ccce5141470f193829ae8cdd888a",
    "vout": 0,
    "address": "msLvK34H6sL36oD32Vy58KX4myf7e7gnjG",
    "label": "alice",
    "scriptPubKey": "76a91481bbb1c4c0db9739ca2daf11e32470e6a052cdaa88ac",
    "amount": 0.01980000,
    "confirmations": 208,
    "spendable": true,
    "solvable": true,
    "desc": "pkh([60d80dee/0'/0'/31']0253eaa94d1261b7ab426259881e8ba9019b859f5bf492f609801732e2e7edb243)#kah4tj5s",
    "safe": true
  },
  {
    "txid": "01c041f15baaf8e75d09d24335be445fae39d322688788be1556f5436fe3dbbb",
    "vout": 0,
    "address": "mgX9TGp5SxT6jczaKhf6fVDUdfsg1m45wf",
    "scriptPubKey": "21027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851ac",
    "amount": 0.01780000,
    "confirmations": 208,
    "spendable": true,
    "solvable": true,
    "desc": "pk([60d80dee/0'/0'/35']027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851)#24lz4ah2",
    "safe": true
  }
]
```

#### P2SH マルチシグ情報の再確認

P2SHマルチシグアドレスを生成したときのcreatemultisig の結果の再確認

```
{
  "address": "2NFDXwLJm87sDmfosTivDkMUbw2Q8Ze8ktF",
  "redeemScript": "52210396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d210339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f4121024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d53ae",
  "descriptor": "sh(multi(2,0396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d,0339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f41,024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d))#qsun2edu"
}
```

#### P2WSH のマルチシグ情報の再確認

P2WSHのマルチシグアドレスを生成したときのcreatemultisig の結果の再確認

```json
{
  "address": "tb1q8ngpnf4g4z95xfdv72m7hatc8yafna8dqcprd5psc7ue4sc7uzrs4avaje",
  "redeemScript": "52210346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c60137759582103d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b8144762103e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e59553ae",
  "descriptor": "wsh(multi(2,0346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c6013775958,03d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b814476,03e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e595))#p2l5aa90"
}
```

#### bitcoin core のワレットにマルチシグ情報を登録する

一般的には，マルチシグは複数の主体のワレットで署名しなければなりません。
この例では，単純化のために署名に必要なすべての秘密鍵が一つのワレットに入っています。

```
importmulti <JSON形式のインポート情報(descriptorを利用)> 
```

```json
 bitcoin-core.cli importmulti '[{"desc": "sh(multi(2,0396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d,0339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f41,024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d))#qsun2edu", "timestamp": "now", "watchonly": true}]'

 [
  {
    "success": true
  }
]
```

```json
bitcoin-core.cli importmulti '[{"desc": "wsh(multi(2,0346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c6013775958,03d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b814476,03e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e595))#p2l5aa90","timestamp": "now", "watchonly": true}]'

[
  {
    "success": true
  }
]
```

#### これでワレットがP2SH, P2WSH を含めたすべてのUTXOを確認できるようになる

```json
bitcoin-core.cli listunspent

[
  {
    "txid": "dd8173e708bed98cf6a66bc41bdada065e62d7eb57300115a60a42e35914b984",
    "vout": 0,
    "address": "tb1qz3uh04vpttfupqrh3msn4jkf694wmy7cfrtzrn",
    "label": "",
    "scriptPubKey": "0014147977d5815ad3c080778ee13acac9d16aed93d8",
    "amount": 0.01980000,
    "confirmations": 476,
    "spendable": true,
    "solvable": true,
    "desc": "wpkh([60d80dee/0'/0'/34']0307de5755de6328a3d68a60a342128326d996271b251c7ab11cedcaf972a1f36c)#njlw3azr",
    "safe": true
  },
  {
    "txid": "01a4d2228d6264d9bbc5761b39671cc83e93ccce5141470f193829ae8cdd888a",
    "vout": 0,
    "address": "msLvK34H6sL36oD32Vy58KX4myf7e7gnjG",
    "label": "alice",
    "scriptPubKey": "76a91481bbb1c4c0db9739ca2daf11e32470e6a052cdaa88ac",
    "amount": 0.01980000,
    "confirmations": 476,
    "spendable": true,
    "solvable": true,
    "desc": "pkh([60d80dee/0'/0'/31']0253eaa94d1261b7ab426259881e8ba9019b859f5bf492f609801732e2e7edb243)#kah4tj5s",
    "safe": true
  },
  {
    "txid": "95ccd50a75ab3bb3767df0b7669f3472965f8d1598feab7cb424f1862857ca8f",
    "vout": 0,
    "address": "tb1q8ngpnf4g4z95xfdv72m7hatc8yafna8dqcprd5psc7ue4sc7uzrs4avaje",
    "label": "",
    "witnessScript": "52210346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c60137759582103d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b8144762103e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e59553ae",
    "scriptPubKey": "00203cd019a6a8a88b4325acf2b7ebf578393a99f4ed060236d030c7b99ac31ee087",
    "amount": 0.01980000,
    "confirmations": 476,
    "spendable": false,
    "solvable": true,
    "desc": "wsh(multi(2,[036ce8f5]0346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c6013775958,[1ac1df2e]03d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b814476,[3f0ddcf2]03e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e595))#7c5ke0ec",
    "safe": true
  },
  {
    "txid": "01c041f15baaf8e75d09d24335be445fae39d322688788be1556f5436fe3dbbb",
    "vout": 0,
    "address": "mgX9TGp5SxT6jczaKhf6fVDUdfsg1m45wf",
    "scriptPubKey": "21027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851ac",
    "amount": 0.01780000,
    "confirmations": 476,
    "spendable": true,
    "solvable": true,
    "desc": "pk([60d80dee/0'/0'/35']027544b898d2d886a7ee733f2cf3da01bfd5d2350fedf602f4d1b78412b5f4d851)#24lz4ah2",
    "safe": true
  },
  {
    "txid": "fbe48c9501b3cd40e2799df464bea9d8f3f3c6bed36a71499636105af11508e9",
    "vout": 0,
    "address": "2NFDXwLJm87sDmfosTivDkMUbw2Q8Ze8ktF",
    "label": "",
    "redeemScript": "52210396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d210339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f4121024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d53ae",
    "scriptPubKey": "a914f100eb22e91b65c5c24e3cb31fc6e571e57e107187",
    "amount": 0.01980000,
    "confirmations": 476,
    "spendable": true,
    "solvable": true,
    "desc": "sh(multi(2,[b4817cdb]0396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d,[43cf1e78]0339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f41,[b551d36b]024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d))#7lc6rvfl",
    "safe": true
  }
]
```

#### ５つのinputを持つ未署名のトランザクションの作成

```bash
bitcoin-core.cli createrawtransaction  '[{"txid":"dd8173e708bed98cf6a66bc41bdada065e62d7eb57300115a60a42e35914b984","vout":0},{"txid":"01a4d2228d6264d9bbc5761b39671cc83e93ccce5141470f193829ae8cdd888a","vout":0},{"txid":"95ccd50a75ab3bb3767df0b7669f3472965f8d1598feab7cb424f1862857ca8f","vout":0},{"txid":"01c041f15baaf8e75d09d24335be445fae39d322688788be1556f5436fe3dbbb","vout":0},{"txid":"fbe48c9501b3cd40e2799df464bea9d8f3f3c6bed36a71499636105af11508e9","vout":0}]'  '[{"tb1q5zu6q5z3lvrfgld6f9n6md44dmy4ztvkjuws2c":0.095}]'

020000000584b91459e3420aa615013057ebd7625e06dada1bc46ba6f68cd9be08e77381dd0000000000ffffffff8a88dd8cae2938190f474151cecc933ec81c67391b76c5bbd964628d22d2a4010000000000ffffffff8fca572886f124b47cabfe98158d5f9672349f66b7f07d76b33bab750ad5cc950000000000ffffffffbbdbe36f43f55615be88876822d339ae5f44be3543d2095de7f8aa5bf141c0010000000000ffffffffe90815f15a10369649716ad3bec6f3f3d8a9be64f49d79e240cdb301958ce4fb0000000000ffffffff0160f5900000000000160014a0b9a05051fb06947dba4967adb6b56ec9512d9600000000
```

```json
bitcoin-core.cli decoderawtransaction 020000000584b91459e3420aa615013057ebd7625e06dada1bc46ba6f68cd9be08e77381dd0000000000ffffffff8a88dd8cae2938190f474151cecc933ec81c67391b76c5bbd964628d22d2a4010000000000ffffffff8fca572886f124b47cabfe98158d5f9672349f66b7f07d76b33bab750ad5cc950000000000ffffffffbbdbe36f43f55615be88876822d339ae5f44be3543d2095de7f8aa5bf141c0010000000000ffffffffe90815f15a10369649716ad3bec6f3f3d8a9be64f49d79e240cdb301958ce4fb0000000000ffffffff0160f5900000000000160014a0b9a05051fb06947dba4967adb6b56ec9512d9600000000
{
  "txid": "e4fd7b14731136033e9cf6ec5ef5b112eb81c3ecb9b8a41c2902067edd804ada",
  "hash": "e4fd7b14731136033e9cf6ec5ef5b112eb81c3ecb9b8a41c2902067edd804ada",
  "version": 2,
  "size": 246,
  "vsize": 246,
  "weight": 984,
  "locktime": 0,
  "vin": [
    {
      "txid": "dd8173e708bed98cf6a66bc41bdada065e62d7eb57300115a60a42e35914b984",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "sequence": 4294967295
    },
    {
      "txid": "01a4d2228d6264d9bbc5761b39671cc83e93ccce5141470f193829ae8cdd888a",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "sequence": 4294967295
    },
    {
      "txid": "95ccd50a75ab3bb3767df0b7669f3472965f8d1598feab7cb424f1862857ca8f",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "sequence": 4294967295
    },
    {
      "txid": "01c041f15baaf8e75d09d24335be445fae39d322688788be1556f5436fe3dbbb",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "sequence": 4294967295
    },
    {
      "txid": "fbe48c9501b3cd40e2799df464bea9d8f3f3c6bed36a71499636105af11508e9",
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
      "value": 0.09500000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 a0b9a05051fb06947dba4967adb6b56ec9512d96",
        "hex": "0014a0b9a05051fb06947dba4967adb6b56ec9512d96",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1q5zu6q5z3lvrfgld6f9n6md44dmy4ztvkjuws2c"
        ]
      }
    }
  ]
}
```

#### トランザクションへの署名

一般的には，マルチシグは複数の主体のワレットで順番に署名する必要があります。

```json
bitcoin-core.cli signrawtransactionwithwallet 020000000584b91459e3420aa615013057ebd7625e06dada1bc46ba6f68cd9be08e77381dd0000000000ffffffff8a88dd8cae2938190f474151cecc933ec81c67391b76c5bbd964628d22d2a4010000000000ffffffff8fca572886f124b47cabfe98158d5f9672349f66b7f07d76b33bab750ad5cc950000000000ffffffffbbdbe36f43f55615be88876822d339ae5f44be3543d2095de7f8aa5bf141c0010000000000ffffffffe90815f15a10369649716ad3bec6f3f3d8a9be64f49d79e240cdb301958ce4fb0000000000ffffffff0160f5900000000000160014a0b9a05051fb06947dba4967adb6b56ec9512d9600000000

{
  "hex": "0200000000010584b91459e3420aa615013057ebd7625e06dada1bc46ba6f68cd9be08e77381dd0000000000ffffffff8a88dd8cae2938190f474151cecc933ec81c67391b76c5bbd964628d22d2a401000000006a473044022027c2e79361e954a6ff5aafe93d76f174cd7ca153c48b4f0d88c641b79817cd95022065a8ef548642a7c98cce141b5c095604eacf5a817d4c3d45873bd146193353aa01210253eaa94d1261b7ab426259881e8ba9019b859f5bf492f609801732e2e7edb243ffffffff8fca572886f124b47cabfe98158d5f9672349f66b7f07d76b33bab750ad5cc950000000000ffffffffbbdbe36f43f55615be88876822d339ae5f44be3543d2095de7f8aa5bf141c0010000000048473044022050fbd4201330b175b94389c1bf7802d48b8a969d8a3d7db8d85990de6c82a786022049947023c516db6f09e8098c751e9818b322c49a0b4aed1338d15a3506b3557301ffffffffe90815f15a10369649716ad3bec6f3f3d8a9be64f49d79e240cdb301958ce4fb00000000fb0047304402205985088fe2ff54e3a54a9ec503d933b127b27cd2f22d83e2f7383b5c9c33151c022061d4ec3d7675503f3bf6ddf785fb5ed498652bd6be270110e1c8afe1d6e21f470146304302200da53981318fb4b2cc457366fa0ec85b4d3e68595a20268ca690fd4639754490021f7c0c2e9c07cddea7fc329cb6b0a7044067882b9e4a168d811af647b15cb4f5014c6952210396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d210339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f4121024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d53aeffffffff0160f5900000000000160014a0b9a05051fb06947dba4967adb6b56ec9512d960247304402201ef77486d8df3a00b209aa8bb7000a9a3254ec936add465d30cddde1e1f886d402207b02301d5b536c7c3cb480864d056d80fe1794f526c32dbdb7c5644c15aa731001210307de5755de6328a3d68a60a342128326d996271b251c7ab11cedcaf972a1f36c00040047304402203d17620f462302ffae15f47f7955140627720c6f4f87d5471ef19a7b06ad9d27022059169ed14b048b67246dad8a8e6ed139cdd9bf08e3fe50b1f3f0fd632988036701473044022042c067ead3eacd7e64693d07a94f95e830c5df448fca89e96bf89114d1ebf48302203ebaee44d1d2ea93b7cdffe2d8008e98caf471926d03fa9a270111e17190a5a6016952210346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c60137759582103d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b8144762103e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e59553ae000000000000",
  "complete": true
}
```

#### 署名済のトランザクションのブロードキャスト

```
bitcoin-core.cli sendrawtransaction 0200000000010584b91459e3420aa615013057ebd7625e06dada1bc46ba6f68cd9be08e77381dd0000000000ffffffff8a88dd8cae2938190f474151cecc933ec81c67391b76c5bbd964628d22d2a401000000006a473044022027c2e79361e954a6ff5aafe93d76f174cd7ca153c48b4f0d88c641b79817cd95022065a8ef548642a7c98cce141b5c095604eacf5a817d4c3d45873bd146193353aa01210253eaa94d1261b7ab426259881e8ba9019b859f5bf492f609801732e2e7edb243ffffffff8fca572886f124b47cabfe98158d5f9672349f66b7f07d76b33bab750ad5cc950000000000ffffffffbbdbe36f43f55615be88876822d339ae5f44be3543d2095de7f8aa5bf141c0010000000048473044022050fbd4201330b175b94389c1bf7802d48b8a969d8a3d7db8d85990de6c82a786022049947023c516db6f09e8098c751e9818b322c49a0b4aed1338d15a3506b3557301ffffffffe90815f15a10369649716ad3bec6f3f3d8a9be64f49d79e240cdb301958ce4fb00000000fb0047304402205985088fe2ff54e3a54a9ec503d933b127b27cd2f22d83e2f7383b5c9c33151c022061d4ec3d7675503f3bf6ddf785fb5ed498652bd6be270110e1c8afe1d6e21f470146304302200da53981318fb4b2cc457366fa0ec85b4d3e68595a20268ca690fd4639754490021f7c0c2e9c07cddea7fc329cb6b0a7044067882b9e4a168d811af647b15cb4f5014c6952210396526c8055983750fc167752326c6c270d294da8f6b44444f1464d8454b9b50d210339dad2edb3c68888b332cf0e0e8159cfdf9acbefe8923082aaaf65ddc2f79f4121024176a0784341d13a76ba8ad8a9249b1156b70216b4ebe2295eeafc0c0a3caf4d53aeffffffff0160f5900000000000160014a0b9a05051fb06947dba4967adb6b56ec9512d960247304402201ef77486d8df3a00b209aa8bb7000a9a3254ec936add465d30cddde1e1f886d402207b02301d5b536c7c3cb480864d056d80fe1794f526c32dbdb7c5644c15aa731001210307de5755de6328a3d68a60a342128326d996271b251c7ab11cedcaf972a1f36c00040047304402203d17620f462302ffae15f47f7955140627720c6f4f87d5471ef19a7b06ad9d27022059169ed14b048b67246dad8a8e6ed139cdd9bf08e3fe50b1f3f0fd632988036701473044022042c067ead3eacd7e64693d07a94f95e830c5df448fca89e96bf89114d1ebf48302203ebaee44d1d2ea93b7cdffe2d8008e98caf471926d03fa9a270111e17190a5a6016952210346711e7845d77b5dba283743228f5c6162e626445ae694fbd9962c60137759582103d798a0fc210729dab75473393296ed1c9ed8ec4ed85f97bb3273c9cb7b8144762103e0e27add506965861763916b8daa3744d6136b2e4b6a1aeb9c4274deeb48e59553ae000000000000
```

TXID

```
1c0b7a6d31c2c0d0a7b3f1acebef9480d05ea900c38e7dc802f61520f0ea047e
```

## 6.5 ビットコインスクリプトの応用例

### 6.5.1 bitcoinrb によるスクリプト操作の基本

```ruby
require 'bitcoin'
require 'net/http'
require 'json'

Bitcoin.chain_params = :signet

# RPCユーザ名
RPCUSER="hoge"
# RPCパスワード
RPCPASSWORD="hoge"
# bitcoind のホスト
HOST="localhost"
# RPCポート番号（signetの場合は38332）
PORT=38332

# トランザクション手数料 (satoshi)
fee=20000

def bitcoinRPC(method, params)
     http = Net::HTTP.new(HOST, PORT)
     request = Net::HTTP::Post.new('/')
     request.basic_auth(RPCUSER, RPCPASSWORD)
     request.content_type = 'application/json'
     request.body = { method: method, params: params, id: 'jsonrpc' }.to_json
     JSON.parse(http.request(request).body)["result"]
end
```

### トランザクションの生成，署名

* UTXOの確認

```ruby
utxos=bitcoinRPC('listunspent', [])
```

utxos[0] を使用することにします。

* UTXOの情報

```ruby
txid=utxos[0]["txid"]
index=utxos[0]["vout"]
amount=(utxos[0]["amount"]*(10**8)).to_i
receipt_addr=utxos[0]["address"]
scriptPubKey=utxos[0]["scriptPubKey"]
prev_script_pubkey = Bitcoin::Script.parse_from_payload(scriptPubKey)
```

* 自分の鍵の情報（receipt_addrからわかる）

```ruby
privkey=bitcoinRPC('dumpprivkey', [receipt_addr])
key = Bitcoin::Key.from_wif(privkey)
```

* 送金先ビットコインアドレスの生成

```ruby
dest_addr=bitcoinRPC('getnewaddress', [])
```

* 未署名トランザクション生成 (P2WPKH)

```ruby
tx = Bitcoin::Tx.new
tx.version = 2

# inputの作成
outpoint=Bitcoin::OutPoint.from_txid(txid, index)
tx.in << Bitcoin::TxIn.new(out_point: outpoint)

# outputの作成

script_pubkey=Bitcoin::Script.parse_from_addr(dest_addr)
value=amount-fee
tx.out << Bitcoin::TxOut.new(value: value,script_pubkey: script_pubkey)
```

* トランザクションへの署名 (P2WPKH)

```ruby
# P2WPKHの署名ハッシュ値
sighash = tx.sighash_for_input(index,prev_script_pubkey, sig_version: :witness_v0, amount: amount)
# 署名
sign = key.sign(sighash) + [Bitcoin::SIGHASH_TYPE[:all]].pack('C')

tx.in[0].script_witness.stack << sign
tx.in[0].script_witness.stack << key.pubkey.htb
```

* トランザクションの確認

```ruby
tx
=> 
#<Bitcoin::Tx:0x00000001246a1df8
 @inputs=
  [#<Bitcoin::TxIn:0x00000001245b1060
    @out_point=
     #<Bitcoin::OutPoint:0x00000001245b1150 @index=0, @tx_hash="15b681a24ae334f323c74d06ddf6cef00b591d3fdca49cdb6d306dc24e724f10">,
    @script_sig=#<Bitcoin::Script:0x00000001245b1038 @chunks=[]>,
    @script_witness=
     #<Bitcoin::ScriptWitness:0x00000001245b0fe8
      @stack=
       ["0D\x02 \x1FR\x03?\x9Et\xE93\xE0\xB0\xDB\x0F\xF2\x17\xA2T\x031q\x81\xB3\x01\xAA\x1AX\x0E\xA8\x9D\xC6\xB2!0\x02 e\x89E\x95\xD4I\xE9\xA8\xBC\a^\x9B\xB71\x0Fw\b~w%\xBA\x97\x97g+T\xD1\xDC\x88\xFF\xB9\x80\x01",
        "\x02\x06\r\xCA\xCA\xDF\xBAu\x87\xB3\x89\xF6\xA3{\xB0\xE86g\xE5}\x1C\x00\f\xC8\xE3\x02\xAAo\x02\r\xDBT\x1C"]>,
    @sequence=4294967295>],
 @lock_time=0,
 @outputs=
  [#<Bitcoin::TxOut:0x0000000124678cc8
    @script_pubkey=#<Bitcoin::Script:0x000000012443e930 @chunks=["\x00", "\x14P\xA9\xE7\x16\nlR\xBEJ%\xCB\x9C\x00V$6\xDC\xABg\x17"]>,
    @value=1779999>],
 @version=2>
```

* 署名済トランザクションの16進形式

```ruby
signedhex=tx.to_payload.bth
```

### ビットコインスクリプトの評価実行

```ruby
script = Bitcoin::Script.from_string('6 1 OP_ADD 7 OP_EQUAL')
script.run

=> true
```

### 6.5.2 トランザクションのタイムロック

nLockTime が　500,000,000 未満の場合は，ブロック高の指定

* 現在のブロック高の確認

```
BH=`bitcoin-core.cli getblockcount`

echo $BH
47078
```

* UTXOの確認

```json
bitcoin-core.cli listunspent
[
  {
    "txid": "1c0b7a6d31c2c0d0a7b3f1acebef9480d05ea900c38e7dc802f61520f0ea047e",
    "vout": 0,
    "address": "tb1q5zu6q5z3lvrfgld6f9n6md44dmy4ztvkjuws2c",
    "label": "",
    "scriptPubKey": "0014a0b9a05051fb06947dba4967adb6b56ec9512d96",
    "amount": 0.09500000,
    "confirmations": 7,
    "spendable": true,
    "solvable": true,
    "desc": "wpkh([60d80dee/0'/0'/36']022af8de82f548c1e531ec331648969315cedc4715fd97542bf177a6df8de4dfeb)#w5u092f4",
    "safe": true
  }
]
```

#### createrawtransaction のパラメータの詳細

```json
createrawtransaction [{"txid":"hex","vout":n,"sequence":n},...] [{"address":amount},{"data":"hex"},...] ( locktime replaceable )
```

#### ロックタイムを含むトランザクションの作成

locktime のブロック高を現在のブロック高 + 10 ブロックとした場合

```json
LockBH=$((`bitcoin-core.cli getblockcount`+10))

bitcoin-core.cli createrawtransaction '[ { "txid": "1c0b7a6d31c2c0d0a7b3f1acebef9480d05ea900c38e7dc802f61520f0ea047e", "vout": 0 } ]' '[{ "tb1qj29lwmk6ezs4n7r79lzcp6jrdkf5x9g8e2pzf9": 0.093}]' $LockBH


02000000017e04eaf02015f602c87d8ec300a95ed08094efebacf1b3a7d0c0c2316d7a0b1c0000000000feffffff0120e88d0000000000160014928bf76edac8a159f87e2fc580ea436d93431507edb70000
```

#### トランザクションの構造の確認

* locktime  ロックする期限のブロック高になっていることを確認する
* sequence　0xffffffff 未満の数になっている　0xffffffff-1 (=4294967294) ことを確認する

```json
bitcoin-core.cli decoderawtransaction 02000000017e04eaf02015f602c87d8ec300a95ed08094efebacf1b3a7d0c0c2316d7a0b1c0000000000feffffff0120e88d0000000000160014928bf76edac8a159f87e2fc580ea436d93431507edb70000

{
  "txid": "47c62922218384dd04287965940f59cf565547cb5cacfee3d56c36ce29dcad27",
  "hash": "47c62922218384dd04287965940f59cf565547cb5cacfee3d56c36ce29dcad27",
  "version": 2,
  "size": 82,
  "vsize": 82,
  "weight": 328,
  "locktime": 47085,
  "vin": [
    {
      "txid": "1c0b7a6d31c2c0d0a7b3f1acebef9480d05ea900c38e7dc802f61520f0ea047e",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "sequence": 4294967294
    }
  ],
  "vout": [
    {
      "value": 0.09300000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 928bf76edac8a159f87e2fc580ea436d93431507",
        "hex": "0014928bf76edac8a159f87e2fc580ea436d93431507",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qj29lwmk6ezs4n7r79lzcp6jrdkf5x9g8e2pzf9"
        ]
      }
    }
  ]
}
```

### UTXOのタイムロック（OP_CLTVとOP_CSV）

## bitcoinrb によるビットコインスクリプトの処理

---

# 課題

1. P2PK，P2PKH，P2SH，P2WPKH，P2WPSHのoutputをもつトランザクションを作成
   してください。
2. P2PK，P2PKH，P2SH，P2WPKH，P2WPSHのUTXOをinputとするトランザクショ
   ンを作成してください。outputのタイプはP2WPKHとします。
3. 実際にアトミックスワップを行うトランザクションを作成し，アトミックスワップを実施してみてください。

## 1. P2PK，P2PKH，P2SH，P2WPKH，P2WPSHのoutputをもつトランザクションを作成してください。

### 回答例

P2WSH でマルチシグのoutput を持つトランザクションと、さらにそれを inputとしてアンロックするトラン
ザクションを構成しデプロイする bitcoinrb のプログラム例です

```ruby
require 'bitcoin'
require 'net/http'
require 'json'
include Bitcoin
include Bitcoin::Opcodes
Bitcoin.chain_params = :signet

HOST="localhost"
PORT=38332          # mainnetの場合は 8332
RPCUSER="hoge"      # bitcoin core RPCユーザ名
RPCPASSWORD="hoge"  # bitcoin core パスワード
FEE = 0.00002       # 手数料

# bitcoin core RPC を利用するメソッド
def bitcoinRPC(method, params)
    http = Net::HTTP.new(HOST, PORT)
    request = Net::HTTP::Post.new('/')
    request.basic_auth(RPCUSER, RPCPASSWORD)
    request.content_type = 'application/json'
    request.body = { method: method, params: params, id: 'jsonrpc' }.to_json
    JSON.parse(http.request(request).body)["result"]
end

# ワレットを生成/ロード
bitcoinRPC('createwallet', ['mywallet']])
bitcoinRPC('loadwallet', ['mywallet']])

# ビットコインアドレスを５つ生成する
me  =   bitcoinRPC('getnewaddress', [])
alice = bitcoinRPC('getnewaddress', [])
bob =   bitcoinRPC('getnewaddress', [])
carol = bitcoinRPC('getnewaddress', [])
david = bitcoinRPC('getnewaddress', [])
eve =   bitcoinRPC('getnewaddress', [])

# アドレスの公開鍵情報
pub_me  =   bitcoinRPC('getaddressinfo', [me])["pubkey"]
pub_alice = bitcoinRPC('getaddressinfo', [alice])["pubkey"]
pub_bob =   bitcoinRPC('getaddressinfo', [bob])["pubkey"]
pub_carol = bitcoinRPC('getaddressinfo', [carol])["pubkey"]
pub_david = bitcoinRPC('getaddressinfo', [david])["pubkey"]
pub_eve =   bitcoinRPC('getaddressinfo', [eve])["pubkey"]

# UTXOを確認する
utxos = bitcoinRPC('listunspent', [])
utxo_txid = utxos[0]["txid"]
utxo_vout = utxos[0]["vout"]
utxo_amount = utxos[0]["amount"]

# UTXOの amount が送金金額(0.001)+FEE より大きいことを確認する

utxo_amount > 0.001+FEE
=> true

# 送金金額
amount = 0.0002
# おつりを計算
change = utxo_amount - amount - FEE

# 6つ(5つ＋おつり)のoutputを持つトランザクションを作成する
tx = Bitcoin::Tx.new
outpoint = Bitcoin::OutPoint.from_txid(utxo_txid, utxo_vout)
tx.in <<  Bitcoin::TxIn.new(out_point: outpoint)

script_pubkey1 = Bitcoin::Script.parse_from_addr(alice)
script_pubkey2 = Bitcoin::Script.parse_from_addr(bob)
script_pubkey3 = Bitcoin::Script.parse_from_addr(carol)
script_pubkey4 = Bitcoin::Script.parse_from_addr(david)
script_pubkey5 = Bitcoin::Script.parse_from_addr(eve)
script_pubkey6 = Bitcoin::Script.parse_from_addr(me)



tx.out << Bitcoin::TxOut.new(value: (amount*(10**8)).to_i, script_pubkey: script_pubkey1)
tx.out << Bitcoin::TxOut.new(value: (amount*(10**8)).to_i, script_pubkey: script_pubkey2)
tx.out << Bitcoin::TxOut.new(value: (amount*(10**8)).to_i, script_pubkey: script_pubkey3)
tx.out << Bitcoin::TxOut.new(value: (amount*(10**8)).to_i, script_pubkey: script_pubkey4)
tx.out << Bitcoin::TxOut.new(value: (amount*(10**8)).to_i, script_pubkey: script_pubkey5)
tx.out << Bitcoin::TxOut.new(value: (change*(10**8)).to_i, script_pubkey: script_pubkey6)

# 作成したトランザクションに署名する
tx_hex = bitcoinRPC('signrawtransactionwithwallet', [tx.to_hex])

# 署名したトランザクションをブロードキャストする
txid = bitcoinRPC('sendrawtransaction', [tx_hex["hex"]])


############### P2WSH
# txid　の vout=4 をUTXOとして利用
amount= 0.0002

# マルチシグ redeem script
redeem_script = Bitcoin::Script.to_multisig_script(2, [pub_alice, pub_bob, pub_carol])
# redeem script の16進形式
redeem_script_hex = redeem_script.to_hex
=> "52210307f83f230d23c2f706f4108ecf6b8330b57369c0529b735e38f9c69fb9d826bf21034d18816344093cbe309beaf4fb1e86c1057c391ea7c85e1c050cb67f0d4d7e2a210260ba91b61f1a47a35f72b4a62880da13c101a2cf2fcd8e7a83fff4e3a0bda5b153ae"

# P2WSHアドレス
p2wsh_addr = Bitcoin::Script.to_p2wsh(redeem_script).to_addr

# P2WSHトランザクション
p2wsh_tx = Bitcoin::Tx.new
# input
outpoint = Bitcoin::OutPoint.from_txid(txid, 4)
p2wsh_tx.in <<  Bitcoin::TxIn.new(out_point: outpoint)
#output
p2wsh_tx.out << Bitcoin::TxOut.new(value: ((amount-FEE)*(10**8)).to_i , script_pubkey:  Bitcoin::Script.parse_from_addr(p2wsh_addr))

# トランザクションへの署名
p2wsh_tx_hex = bitcoinRPC('signrawtransactionwithwallet', [p2wsh_tx.to_hex])

# 署名したトランザクションをブロードキャストする
p2wsh_txid = bitcoinRPC('sendrawtransaction', [p2wsh_tx_hex["hex"]])


##################
# P2WSH のUTXOの使用

# AliceとBobの秘密鍵
priv_alice = bitcoinRPC('dumpprivkey', [alice])
priv_bob = bitcoinRPC('dumpprivkey', [bob])

# 署名鍵
keyAlice = Bitcoin::Key.from_wif(priv_alice)
keyBob = Bitcoin::Key.from_wif(priv_bob)

# redeem script の16進形式
redeem_script_hex = "52210307f83f230d23c2f706f4108ecf6b8330b57369c0529b735e38f9c69fb9d826bf21034d18816344093cbe309beaf4fb1e86c1057c391ea7c85e1c050cb67f0d4d7e2a210260ba91b61f1a47a35f72b4a62880da13c101a2cf2fcd8e7a83fff4e3a0bda5b153ae"
# redeem script の復元
redeem_script = Bitcoin::Script.parse_from_payload(redeem_script_hex.htb)

# アンロック対象トランザクションとUTXO
locked_tx = Bitcoin::Tx.parse_from_payload(bitcoinRPC('getrawtransaction',[p2wsh_txid]).htb)
p2wsh_utxo = locked_tx.out
utxo_vout = 0
utxo_value = p2wsh_utxo[utxo_vout].value    # satoshi

# アンロックトランザクションの構成（送金先はaliceとする）
p2wsh_tx = Bitcoin::Tx.new
# input
outpoint = Bitcoin::OutPoint.from_txid(p2wsh_txid, utxo_vout)
p2wsh_tx.in <<  Bitcoin::TxIn.new(out_point: outpoint)
#output (P2WPKH)
script_pubkey = Bitcoin::Script.parse_from_addr(alice)
p2wsh_tx.out << Bitcoin::TxOut.new(value: utxo_value-(FEE*(10**8)).to_i, script_pubkey: script_pubkey)

# アンロックトランザクションの署名対象のハッシュ値 sighash
sighash = p2wsh_tx.sighash_for_input(0, redeem_script, sig_version: :witness_v0, amount: utxo_value, hash_type: Bitcoin::SIGHASH_TYPE[:all])
# aliceとbobのsighasuへの署名
sigAlice = keyAlice.sign(sighash) + [Bitcoin::SIGHASH_TYPE[:all]].pack('C')
sigBob   = keyBob.sign(sighash) + [Bitcoin::SIGHASH_TYPE[:all]].pack('C')
# witness scriptの追加
p2wsh_tx.in[0].script_witness.stack << ""   # CHECKMULTISIGのバグ対応　NULLDUMMY　を入れる
p2wsh_tx.in[0].script_witness.stack << sigAlice
p2wsh_tx.in[0].script_witness.stack << sigBob
p2wsh_tx.in[0].script_witness.stack << redeem_script.to_payload
# 署名したトランザクションをブロードキャストする
p2wsh_txid = bitcoinRPC('sendrawtransaction', [p2wsh_tx.to_hex])

```

6.2, 6.3, 6.4.1~6.4.7 で説明

## 2. P2PK，P2PKH，P2SH，P2WPKH，P2WPSHのUTXOをinputとするトランザクションを作成してください。outputのタイプはP2WPKHとします。

### 回答例

6.4.8 で説明

## 3. 実際にアトミックスワップを行うトランザクションを作成し，アトミックスワップを実施してみてください。

### 回答例

## HTLCの実装（bitcoinrb)

### redeem script (一般化したロックスクリプト)

注意!:　(`OP_CSV`は，初期のビットコインスクリプトの仕様ではリザーブされていたオペコードを使用しているので，旧仕様のノードにリジェクトされないように `OP_DROP`でスタックから取り除いています)

```
OP_IF
    OP_SHA256 <Sのハッシュ値> OP_EQUALVERIFY 
    <Bobの公開鍵>
OP_ELSE
    <ロックするブロック数> OP_CSV 
    OP_DROP  
    <Aliceの公開鍵>
OP_ENDIF
OP_CHECKSIG
```

### unlocking script (Bobによるアンロックの場合）

```
<Bobの署名> 
<S> 
true
```

### unlocking script と redeem scriptの連接結果 (witness)

```
<Bobの署名> 
<S> 
true
------------連接--------------
OP_IF
    OP_SHA256 <Sのハッシュ値> OP_EQUALVERIFY 
    <Bobの公開鍵>
OP_ELSE
    <ロックするブロック数> OP_CSV 
    OP_DROP  
    <Aliceの公開鍵>
OP_ENDIF
OP_CHECKSIG
```

1. スタックに， `<Bobの署名>` ，`<S>`，true　が順に積まれます
2. true が適用され，`OP_IF` 側の処理が実行されます
3. `<S>` の`OP_SHA256` の結果と `<Sのハッシュ値>` が`OP_EQUALVERIFY` で比較されます
4. 等しければ，Bobの公開鍵による Bobの署名が検証され，成功すればロックが解除されます

```ruby
require 'bitcoin'
require 'net/http'
require 'json'
include Bitcoin::Opcodes

Bitcoin.chain_params = :signet

HOST="localhost"
PORT=38332          # mainnetの場合は 8332
RPCUSER="hoge"      # bitcoin core RPCユーザ名
RPCPASSWORD="hoge"  # bitcoin core パスワード

# bitcoin core RPC を利用するメソッド
def bitcoinRPC(method, params)
    http = Net::HTTP.new(HOST, PORT)
    request = Net::HTTP::Post.new('/')
    request.basic_auth(RPCUSER, RPCPASSWORD)
    request.content_type = 'application/json'
    request.body = { method: method, params: params, id: 'jsonrpc' }.to_json
    JSON.parse(http.request(request).body)["result"]
end

# AliceとBobのアドレス
addrAlice="tb1q92v4dxsz47zxs5rdu42q7nl4xsdlncmvswxr5f"
addrBob="tb1q9vml26m9vgm5nk3fk9v7cfkad7tlfgsgnahkfu"

# 秘密鍵（WIF形式）
privAlice='cVkvmDQ2TvRg1L1eLCfoAhYZpWAiaJyesyF2owMA9kUJj6mczJQP'
privBob='cUpy2Z19AC22MnGLNBfrNMZqrbz7v7rtL9UByzMoxqGC4v9SKtFf'

# 鍵オブジェクト(WIF形式の秘密鍵から生成）
keyAlice=Bitcoin::Key.from_wif(privAlice)
keyBob=Bitcoin::Key.from_wif(privBob)

# AliceのUTXOと残高を確認（とりあえず最初の Alice宛のUTXOを利用することにする）
utxos=bitcoinRPC('listunspent',[]).select{|x| x["address"]==addrAlice}
utxoAmount = utxos[0]["amount"]
utxoVout = utxos[0]["vout"]
utxoTxid = utxos[0]["txid"]
utxoScriptPubKey = utxos[0]["scriptPubKey"]
```

### 秘密情報はCarolが生成するものとします。

`<S>` ：秘密情報　

この説明では　"HTLC_test"　とします。

```ruby
secret='HTLC_test'
secret_hash=Bitcoin.sha256(secret)
```

#### script処理のテスト(OP_SHA256の検証)

```ruby
# <Sの OP_SHA256 ハッシュ値>
secret='HTLC_test'
secret_hash=Bitcoin.sha256(secret)

# scriptのテスト
ts=Bitcoin::Script.new << secret.bth << OP_SHA256 << secret_hash << OP_EQUAL
ts.run

# => true
```

#### redeem script

```ruby
# <ロックするブロック数> 10日間のブロック数（リトルエンディアン）
locktime = (6*24*10).to_bn.to_s(2).reverse.bth
# => "a005"

# redeem script
redeem_script = Bitcoin::Script.new << OP_IF << OP_SHA256 << secret_hash << OP_EQUALVERIFY << keyBob.pubkey.htb << OP_ELSE << locktime << OP_CSV << OP_DROP << keyAlice.pubkey.htb << OP_ENDIF << OP_CHECKSIG

# redeem scriptの内容の確認
redeem_script.to_h

=> 
{:asm=>
  "OP_IF OP_SHA256 996bf59473947d9906275f427ecb318371514db2ffb8e9d8517b5e45cb65e357 OP_EQUALVERIFY 03d66199f0dd6bbd161cd4a854cd238a4dbebf2d0cf1133180797e1270dac3e528 OP_ELSE 1440 OP_CSV OP_DROP 02f51aea0586248f9528b96d13fd155d06c394fb6dc5d790568537be68c75eaff7 OP_ENDIF OP_CHECKSIG",
 :hex=>
  "63a820996bf59473947d9906275f427ecb318371514db2ffb8e9d8517b5e45cb65e357882103d66199f0dd6bbd161cd4a854cd238a4dbebf2d0cf1133180797e1270dac3e5286702a005b2752102f51aea0586248f9528b96d13fd155d06c394fb6dc5d790568537be68c75eaff768ac",
 :type=>"nonstandard"}

# 秘密情報 Sのハッシュ値(16進数形式)
secret_hash.bth

# => "996bf59473947d9906275f427ecb318371514db2ffb8e9d8517b5e45cb65e357"
```

### HTLCロックトランザクションの scriptPubKey

P2WSHのscriptPubKeyは，以下の形式になる

```
0 <redeem scriptの SHA256ハッシュ>
```

Bitcoin::Script オブジェクトの to_payload メソッドでバイナリを得ることができるので，そのSHA256ハッシュをとる

```ruby
scriptPubKey_p2wsh = Bitcoin::Script.from_string("0 #{redeem_script.to_sha256}")

scriptPubKey_p2wsh.to_h

=> 
{:asm=>"0 1f607171e9d99056ca0c574ae258cc48e397066130d844754d2954afa6603d9c",
 :hex=>"00201f607171e9d99056ca0c574ae258cc48e397066130d844754d2954afa6603d9c",
 :type=>"witness_v0_scripthash",
 :req_sigs=>1,
 :addresses=>["tb1qras8zu0fmxg9djsv2a9wykxvfr3ewpnpxrvyga2d9922lfnq8kwqanhe8n"]}
```

### P2WSH アドレスの生成

```ruby
p2wshaddr = scriptPubKey_p2wsh.to_addr

=> "tb1qras8zu0fmxg9djsv2a9wykxvfr3ewpnpxrvyga2d9922lfnq8kwqanhe8n"
```

## AliceがHTLCロックトランザクションを作成

### AliceはBobからBobの公開鍵を得る

```ruby
pubkeyBob = keyBob.pubkey

=> "03d66199f0dd6bbd161cd4a854cd238a4dbebf2d0cf1133180797e1270dac3e528"
```

### AliceはCarolから秘密情報 `<S>` の OP_SHA256 ハッシュ値を得る

```ruby
secret_hash

=> "\x99k\xF5\x94s\x94}\x99\x06'_B~\xCB1\x83qQM\xB2\xFF\xB8\xE9\xD8Q{^E\xCBe\xE3W"
```

### HTLCロック・トランザクションの資金の確認

output (デポジット金額：0.01,手数料 0.0002)

```ruby
# 使用するUTXOの金額
utxoAmount
# HTLCでデポジットする金額
deposit =0.01
# 手数料
fee=0.0002
# お釣り
change= utxoAmount-deposit-fee

# それぞれの金額をSatoshiに変換
utxoAmount_satoshi = (utxoAmount * 100000000).to_i
deposit_satoshi = (deposit * 100000000).to_i
change_satoshi = (change * 100000000).to_i
```

### 未署名のHTLCロック・トランザクションの作成

```ruby
# トランザクションテンプレートの生成
tx = Bitcoin::Tx.new
# inputの作成
tx.in << Bitcoin::TxIn.new(out_point: Bitcoin::OutPoint.from_txid(utxoTxid, utxoVout))
# デポジット用　P2WSH outputの作成
tx.out << Bitcoin::TxOut.new(value: deposit_satoshi, script_pubkey:  Bitcoin::Script.parse_from_addr(p2wshaddr))
# おつり用のP2WPKH outputの作成
tx.out << Bitcoin::TxOut.new(value: change_satoshi , script_pubkey:  Bitcoin::Script.parse_from_addr(addrAlice))
```

### Alice によるHTLCロックトランザクションへのデジタル署名

#### 署名対象のsighashを計算

```ruby
# UTXOのロックを解除するために、UTXOのScript Public key を取得
utxo_scriptPubKey = Bitcoin::Script.parse_from_payload(utxoScriptPubKey.htb)

# sighashを作成
sighash = tx.sighash_for_input(0, utxo_scriptPubKey, sig_version: :witness_v0, amount: utxoAmount_satoshi)
```

#### Aliceの秘密鍵でHTLCロックトランザクションの署名を作成する

 最後に　SHIGHASH_TYPE を追加して指定することを忘れないようにする。SHIGHASH_TYPE はALL

```ruby
signature = keyAlice.sign(sighash) + [Bitcoin::SIGHASH_TYPE[:all]].pack('C')

signature.bth

=> "304402203e7545159094f33ad439771d50e6564c8a4098223fc570e86c0612f04fbfa1fd02203b81e0e4614032c27b7e3a1fdc4a904a2f716800255bce40a074597b4e51ccb401"
```

#### witness script の追加

witness script はスタックとして追加していく
`
<Aliceの署名>
<Aliceの公開鍵>
`

```ruby
# witness にAliceのsighash へ署名をプッシュする
tx.in[0].script_witness.stack << signature

# witness にAliceの公開鍵（バイナリ形式）をプッシュする
tx.in[0].script_witness.stack <<  keyAlice.pubkey.htb
```

#### 完成したHTLCロックトランザクション

```ruby
bitcoinRPC('decoderawtransaction',[tx.to_hex])

=> 
{"txid"=>"521682bd3a3a485c7825d0652bac0b9c9faec5695f0c969b9c4e8ecfc8597270",
 "hash"=>"30cfcbfa315484dbd9a370eb29dac2438d632600bfcb8b749a78dfa4381ebccd",
 "version"=>1,
 "size"=>234,
 "vsize"=>153,
 "weight"=>609,
 "locktime"=>0,
 "vin"=>
  [{"txid"=>"292e2badf9f8c6a453db38d3a38ecc039b56b5a78d3dddd7a8963f67446a5604",
    "vout"=>1,
    "scriptSig"=>{"asm"=>"", "hex"=>""},
    "txinwitness"=>
     ["304402203e7545159094f33ad439771d50e6564c8a4098223fc570e86c0612f04fbfa1fd02203b81e0e4614032c27b7e3a1fdc4a904a2f716800255bce40a074597b4e51ccb401",
      "02f51aea0586248f9528b96d13fd155d06c394fb6dc5d790568537be68c75eaff7"],
    "sequence"=>4294967295}],
 "vout"=>
  [{"value"=>0.01,
    "n"=>0,
    "scriptPubKey"=>
     {"asm"=>"0 1f607171e9d99056ca0c574ae258cc48e397066130d844754d2954afa6603d9c",
      "hex"=>"00201f607171e9d99056ca0c574ae258cc48e397066130d844754d2954afa6603d9c",
      "address"=>"tb1qras8zu0fmxg9djsv2a9wykxvfr3ewpnpxrvyga2d9922lfnq8kwqanhe8n",
      "type"=>"witness_v0_scripthash"}},
   {"value"=>0.0694,
    "n"=>1,
    "scriptPubKey"=>
     {"asm"=>"0 2a99569a02af8468506de5540f4ff5341bf9e36c",
      "hex"=>"00142a99569a02af8468506de5540f4ff5341bf9e36c",
      "address"=>"tb1q92v4dxsz47zxs5rdu42q7nl4xsdlncmvswxr5f",
      "type"=>"witness_v0_keyhash"}}]}
```

#### AliceによるHTLCロックトランザクションのブロードキャスト

```ruby
htcl_lockTx_txid = bitcoinRPC('sendrawtransaction',[tx.to_hex])
htcl_lockTx_txid

=> "521682bd3a3a485c7825d0652bac0b9c9faec5695f0c969b9c4e8ecfc8597270"
```

---------------------------------

## Bob によるHTCLアンロックトランザクションの作成

### Bob側のマシンの環境セットアップ

```ruby
require 'bitcoin'
require 'net/http'
require 'json'
include Bitcoin::Opcodes

Bitcoin.chain_params = :signet

HOST="localhost"
PORT=38332          # mainnetの場合は 8332
RPCUSER="hoge"      # bitcoin core RPCユーザ名
RPCPASSWORD="hoge"  # bitcoin core パスワード

# bitcoin core RPC を利用するメソッド
def bitcoinRPC(method, params)
    http = Net::HTTP.new(HOST, PORT)
    request = Net::HTTP::Post.new('/')
    request.basic_auth(RPCUSER, RPCPASSWORD)
    request.content_type = 'application/json'
    request.body = { method: method, params: params, id: 'jsonrpc' }.to_json
    JSON.parse(http.request(request).body)["result"]
end

# AliceとBobのアドレス
addrAlice="tb1q92v4dxsz47zxs5rdu42q7nl4xsdlncmvswxr5f"
addrBob="tb1q9vml26m9vgm5nk3fk9v7cfkad7tlfgsgnahkfu"

# 秘密鍵（WIF形式）
privAlice='cVkvmDQ2TvRg1L1eLCfoAhYZpWAiaJyesyF2owMA9kUJj6mczJQP'
privBob='cUpy2Z19AC22MnGLNBfrNMZqrbz7v7rtL9UByzMoxqGC4v9SKtFf'

# 鍵オブジェクト(WIF形式の秘密鍵から生成）
keyAlice=Bitcoin::Key.from_wif(privAlice)
keyBob=Bitcoin::Key.from_wif(privBob)
```

### アンロックのためにBobが知っている（べき）情報

* Aliceの公開鍵
* Bobの公開鍵
* 秘密情報 `<S>` (Carolから開示される）
* redeem script (Aliceからもらう）
* HTLCロックトランザクションの トランザクションID (Aliceからもらう）
  * HTLCロックトランザクションの scriptPubKey
  * HTLCロックトランザクションのP2WSHアドレス
  * アンロックの対象となるUTXO のvout
  * アンロックの対象となるUTXO の金額

```ruby
# 秘密情報
secret='HTLC_test'
# 秘密情報のハッシュ値
secret_hash=Bitcoin.sha256(secret)
# <ロックするブロック数> 10日間（リトルエンディアン）
locktime = (6*24*10).to_bn.to_s(2).reverse.bth
# redeem script
redeem_script = Bitcoin::Script.new << OP_IF << OP_SHA256 << secret_hash << OP_EQUALVERIFY << keyBob.pubkey.htb << OP_ELSE << locktime << OP_CSV << OP_DROP << keyAlice.pubkey.htb << OP_ENDIF << OP_CHECKSIG

# HTLCロックトランザクションの トランザクションID
htcl_lockTx_txid = "521682bd3a3a485c7825d0652bac0b9c9faec5695f0c969b9c4e8ecfc8597270"
# HTLCロックトランザクション
htlc_tx = bitcoinRPC('decoderawtransaction',[ bitcoinRPC('getrawtransaction',[htcl_lockTx_txid])])
# HTLCロックトランザクションの scriptPubKey
scriptPubKey_p2wsh = Bitcoin::Script.from_string("0 #{redeem_script.to_sha256}")
# HTLCロックトランザクションのP2WSHアドレス
p2wshaddr = scriptPubKey_p2wsh.to_addr
# アンロックの対象となるUTXO のvout
htcl_lockTx_vout=0
# アンロックの対象となるUTXO へのデポジット金額
deposit=0.01
# 手数料
fee=0.0002
# 報酬金額
reward = deposit-fee
# satoshi 変換
deposit_satoshi = (deposit * (10**8)).to_i
reward_satoshi = (reward* (10**8)).to_i
```

### HTLCをアンロックする未署名トランザクションの作成

```ruby
# トランザクションテンプレートの生成
tx = Bitcoin::Tx.new
# inputの作成
tx.in << Bitcoin::TxIn.new(out_point: Bitcoin::OutPoint.from_txid(htcl_lockTx_txid, htcl_lockTx_vout))
# 報酬用のP2WPKH outputの作成
tx.out << Bitcoin::TxOut.new(value: reward_satoshi, script_pubkey: Bitcoin::Script.parse_from_addr(addrBob))
```

### 署名対象のsighashを計算

```ruby
# sighashを作成
sighash = tx.sighash_for_input(0, redeem_script, sig_version: :witness_v0, amount: deposit_satoshi, hash_type: Bitcoin::SIGHASH_TYPE[:all])
```

### Bobの秘密鍵でHTLCロックトランザクションをアンロックするための署名を作成する

```ruby
# SHIGHASH_TYPE ALL
sigBob = keyBob.sign(sighash) + [Bitcoin::SIGHASH_TYPE[:all]].pack('C')
```

### witness scriptの追加

```ruby
tx.in[0].script_witness.stack << sigBob
tx.in[0].script_witness.stack << secret
tx.in[0].script_witness.stack << [1].pack("C")
tx.in[0].script_witness.stack << redeem_script.to_payload
```

### 完成したトランザクションの確認

```ruby
bitcoinRPC('decoderawtransaction',[tx.to_payload.bth])

=> 
{
  "txid": "87843211117d6b54eebffb1e5ef696a17c1d2fe1d25ea10b13e311b503d58a66",
  "hash": "dc480816a87c441ec82efc2c674f8c2d55609bae87f06a000f7dfca7d6c49379",
  "version": 1,
  "size": 282,
  "vsize": 132,
  "weight": 528,
  "locktime": 0,
  "vin": [
    {
      "txid": "521682bd3a3a485c7825d0652bac0b9c9faec5695f0c969b9c4e8ecfc8597270",
      "vout": 0,
      "scriptSig": {
        "asm": "",
        "hex": ""
      },
      "txinwitness": [
        "304402201f79915fcb5bbe7f3a3e695fe9fe15b12306279f6ef8d5e6aa7144ed8edceaa702205504a13316ee367f87fca6380772a59598473bd243a6bee2afb1052d947ee03801",
        "48544c435f74657374",
        "01",
        "63a820996bf59473947d9906275f427ecb318371514db2ffb8e9d8517b5e45cb65e357882103d66199f0dd6bbd161cd4a854cd238a4dbebf2d0cf1133180797e1270dac3e5286702a005b2752102f51aea0586248f9528b96d13fd155d06c394fb6dc5d790568537be68c75eaff768ac"
      ],
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 0.00980000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0 2b37f56b65623749da29b159ec26dd6f97f4a208",
        "hex": "00142b37f56b65623749da29b159ec26dd6f97f4a208",
        "address": "tb1q9vml26m9vgm5nk3fk9v7cfkad7tlfgsgnahkfu",
        "type": "witness_v0_keyhash"
      }
    }
  ]
}
```

## HTLC アンロックトランザクションのブロードキャスト

```ruby
tx.to_payload.bth
=> "01000000000101707259c8cf8e4e9c9b960c5f69c5ae9f9c0bac2b65d025785c483a3abd8216520000000000ffffffff0120f40e00000000001600142b37f56b65623749da29b159ec26dd6f97f4a2080447304402201f79915fcb5bbe7f3a3e695fe9fe15b12306279f6ef8d5e6aa7144ed8edceaa702205504a13316ee367f87fca6380772a59598473bd243a6bee2afb1052d947ee038010948544c435f7465737401017063a820996bf59473947d9906275f427ecb318371514db2ffb8e9d8517b5e45cb65e357882103d66199f0dd6bbd161cd4a854cd238a4dbebf2d0cf1133180797e1270dac3e5286702a005b2752102f51aea0586248f9528b96d13fd155d06c394fb6dc5d790568537be68c75eaff768ac00000000"

htcl_unlockTx_txid = bitcoinRPC('sendrawtransaction',[tx.to_payload.bth])
htcl_unlockTx_txid

=> "87843211117d6b54eebffb1e5ef696a17c1d2fe1d25ea10b13e311b503d58a66"
```

---

## 付録

### データ付きトランザクションの作成（OP_RETURN）

オペコード OP_RETURN を持つ金額 0 のoutput によってトランザクションに80バイトまでのデータを埋め込むことができます。

dataとして "https://github.com/blockchain-programming/book2021/blob/master/Chapter06.md" という　75 バイトの文字列をトランザクションに埋め込んでみます

Rubyで文字列を16進数に変換します

```ruby
text="https://github.com/blockchain-programming/book2021/blob/master/Chapter06.md"
hex=text.unpack("H*")[0]

=>"68747470733a2f2f6769746875622e636f6d2f626c6f636b636861696e2d70726f6772616d6d696e672f626f6f6b323032312f626c6f622f6d61737465722f4368617074657230362e6d64"

# 逆変換
[hex].pack('H*')

=>"https://github.com/blockchain-programming/book2021/blob/master/Chapter06.md"
```

OP_RETURN を持つトランザクションの作成

```
bitcoin-core.cli createrawtransaction '[ { "txid": "1c0b7a6d31c2c0d0a7b3f1acebef9480d05ea900c38e7dc802f61520f0ea047e", "vout": 0 } ]' '[{"data":"68747470733a2f2f6769746875622e636f6d2f626c6f636b636861696e2d70726f6772616d6d696e672f626f6f6b323032312f626c6f622f6d61737465722f4368617074657230362e6d64"},{"tb1qj29lwmk6ezs4n7r79lzcp6jrdkf5x9g8e2pzf9": 0.093}]'

02000000017e04eaf02015f602c87d8ec300a95ed08094efebacf1b3a7d0c0c2316d7a0b1c0000000000ffffffff0200000000000000004d6a4b68747470733a2f2f6769746875622e636f6d2f626c6f636b636861696e2d70726f6772616d6d696e672f626f6f6b323032312f626c6f622f6d61737465722f4368617074657230362e6d6420e88d0000000000160014928bf76edac8a159f87e2fc580ea436d9343150700000000
```

トランザクションの構造の確認

```json
bitcoin-core.cli decoderawtransaction 02000000017e04eaf02015f602c87d8ec300a95ed08094efebacf1b3a7d0c0c2316d7a0b1c0000000000ffffffff0200000000000000004d6a4b68747470733a2f2f6769746875622e636f6d2f626c6f636b636861696e2d70726f6772616d6d696e672f626f6f6b323032312f626c6f622f6d61737465722f4368617074657230362e6d6420e88d0000000000160014928bf76edac8a159f87e2fc580ea436d9343150700000000

{
  "txid": "d7708efbba353e9071824f2ad3237d14e14dedb7667861b1384989f0fa6b33f2",
  "hash": "d7708efbba353e9071824f2ad3237d14e14dedb7667861b1384989f0fa6b33f2",
  "version": 2,
  "size": 168,
  "vsize": 168,
  "weight": 672,
  "locktime": 0,
  "vin": [
    {
      "txid": "1c0b7a6d31c2c0d0a7b3f1acebef9480d05ea900c38e7dc802f61520f0ea047e",
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
      "value": 0.00000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "OP_RETURN 68747470733a2f2f6769746875622e636f6d2f626c6f636b636861696e2d70726f6772616d6d696e672f626f6f6b323032312f626c6f622f6d61737465722f4368617074657230362e6d64",
        "hex": "6a4b68747470733a2f2f6769746875622e636f6d2f626c6f636b636861696e2d70726f6772616d6d696e672f626f6f6b323032312f626c6f622f6d61737465722f4368617074657230362e6d64",
        "type": "nulldata"
      }
    },
    {
      "value": 0.09300000,
      "n": 1,
      "scriptPubKey": {
        "asm": "0 928bf76edac8a159f87e2fc580ea436d93431507",
        "hex": "0014928bf76edac8a159f87e2fc580ea436d93431507",
        "reqSigs": 1,
        "type": "witness_v0_keyhash",
        "addresses": [
          "tb1qj29lwmk6ezs4n7r79lzcp6jrdkf5x9g8e2pzf9"
        ]
      }
    }
  ]
}
```
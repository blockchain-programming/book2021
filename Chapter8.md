# 8章 演習

## 1. ビットコインの任意のブロックを選択し，そのブロックの Compact Block Filter を確認してみましょう。

Bitcoin Core v0.21.0 から -blockfilterindex=1 -peerblockfilters=1 オプションを指定して起動すると
Compact Block Filter が生成されます。

<details><summary>Compact Block Filterを有効にしてsignetに接続します。</summary><div>

    $ ./bitcoind -blockfilterindex=1 -peerblockfilters=1 -signet -daemon

ブロック`0000007e9e4eecfae813cbee670045622e2b77f3f7c0de6f0709fcabe1511f64`のフィルタデータを取得します。

    $ ./bitcoin-cli -signet getblockfilter 0000007e9e4eecfae813cbee670045622e2b77f3f7c0de6f0709fcabe1511f64
    {
    "filter": "42802a272755ec111b194022d69d58a3bd6d2bbcf20a6873a5368aa4becc288c6b931df2adef1fa496fc44273824af60a99d99d1c9ded7b8fda5f693f2e9c90d2021dc24f6933a80fca1fd4ae975800670a931a324aa65999284686ac7c18669345ea1d5f21e413d2b4f674d939838561f5d6aaa4bfab4a990865f3f78e68560096dbafd6fc1d230b0d98c8b7d3f3d95f9e0522bdfbb864bb125ccdd823432f92558f24838cacf69ff1552b02f9f",
    "header": "4a1b531d93579c77ce320478b404e3394ddac91cc5f454a150c8041f63c418a9"
    }

`filter`値が確認できます。

</div></details>

## ２．1 で選択したブロック内の任意のトランザクションのアウトプットの scriptPubKey がフィルタに含まれることを確認してみましょう。

1のブロックのトランザクション`e6cee8e593ea5ce28f4c753672eb613723420eef21d4e6d8eafd5003e0150c67`を確認し、

    $./bitcoin-cli -signet getrawtransaction e6cee8e593ea5ce28f4c753672eb613723420eef21d4e6d8eafd5003e0150c67 1
    {
        "txid": "e6cee8e593ea5ce28f4c753672eb613723420eef21d4e6d8eafd5003e0150c67",
        "hash": "56576d9d3bb3bcff3eba5e9f015936e968762bb45e3b3103ca87a65673edc114",
        "version": 2,
        "size": 222,
        "vsize": 141,
        "weight": 561,
        "locktime": 40701,
        "vin": [
            {
                "txid": "999fa1deb1178c90cfbb7bdba6b1dc996afdea2f81d2db559569b47a7b74bff6",
                "vout": 0,
                "scriptSig": {
                    "asm": "",
                    "hex": ""
                },
                "txinwitness": [
                    "304402207e7c1bd7464b76b175ac0edd59c368db93e7129636a322ad770b55744827d9b502203eeb1457a2ce5d6fd9169bed3d92f6527b268905bb474c53e889b427da01d52101",
                    "02ed2706ca300ffb362e6cb6d1ba6dd09838d6246249375469a64b7299ea66a31a"
                ],
                "sequence": 4294967294
            }
        ],
        "vout": [
            {
                "value": 0.10000000,
                "n": 0,
                "scriptPubKey": {
                    "asm": "0 4ba1307f3078561d0f6edd67c9d415391baaf32d",
                    "hex": "00144ba1307f3078561d0f6edd67c9d415391baaf32d",
                    "reqSigs": 1,
                    "type": "witness_v0_keyhash",
                    "addresses": [
                        "tb1qfwsnqles0ptp6rmwm4nun4q48yd64uedu2zxeh"
                    ]
                }
            },
            {
                "value": 11.49929926,
                "n": 1,
                "scriptPubKey": {
                    "asm": "0 7c45b5aab7f114d90e133ff3fdaf82270ee5ca4a",
                    "hex": "00147c45b5aab7f114d90e133ff3fdaf82270ee5ca4a",
                    "reqSigs": 1,
                    "type": "witness_v0_keyhash",
                    "addresses": [
                        "tb1q03zmt24h7y2djrsn8lelmtuzyu8wtjj2tyknlx"
                    ]
                }
            }
        ],
        "hex": "02000000000101f6bf747b7ab4699555dbd2812feafd6a99dcb1a6db7bbbcf908c17b1dea19f990000000000feffffff0280969800000000001600144ba1307f3078561d0f6edd67c9d415391baaf32dc6898a44000000001600147c45b5aab7f114d90e133ff3fdaf82270ee5ca4a0247304402207e7c1bd7464b76b175ac0edd59c368db93e7129636a322ad770b55744827d9b502203eeb1457a2ce5d6fd9169bed3d92f6527b268905bb474c53e889b427da01d521012102ed2706ca300ffb362e6cb6d1ba6dd09838d6246249375469a64b7299ea66a31afd9e0000",
        "blockhash": "0000007e9e4eecfae813cbee670045622e2b77f3f7c0de6f0709fcabe1511f64",
        "confirmations": 17,
        "time": 1622768989,
        "blocktime": 1622768989
    }

このトランザクションの2つのUTXOのscriptPubkeyが、フィルタに含まれていることを確認してみます。

Bitcoinのフィルタパラメータは以下のとおりです。

* フィルタに格納されている要素数N: フィルタの先頭にCompactSizeでエンコードされた状態で格納されています。
* 確率パラメータM: 784931
* ゴロム・ライス符号のbitパラメータP: 19
* SipHashの計算:
  * キー: フィルタが生成されたブロックのブロックハッシュの先頭16バイト
  * 値: scriptPubkey
  
ここでは、[bitcoinrb](https://github.com/chaintope/bitcoinrb) gemを使って確認します。
bitcoinrbでは、フィルタに要素が包含されているかどうか検証するためのクラス`Bitcoin::BlockFilter`が提供されていますが、
今回は、フィルタの処理の仕組みを理解しやすいよう、そのロジックを記載しています。

<details><summary>コードを見る</summary><div>
```ruby
require 'bitcoin'
require 'siphash'

P = 19      # ゴロム・ライス符号のbitパラメータ
M = 784931  # 確率パラメータ

block_hash = '641f51e1abfc09076fdec0f7f3772b2e62450067eecb13e8faec4e9e7e000000' # ビッグエンディアン表記
filter = '42802a272755ec111b194022d69d58a3bd6d2bbcf20a6873a5368aa4becc288c6b931df2adef1fa496fc44273824af60a99d99d1c9ded7b8fda5f693f2e9c90d2021dc24f6933a80fca1fd4ae975800670a931a324aa65999284686ac7c18669345ea1d5f21e413d2b4f674d939838561f5d6aaa4bfab4a990865f3f78e68560096dbafd6fc1d230b0d98c8b7d3f3d95f9e0522bdfbb864bb125ccdd823432f92558f24838cacf69ff1552b02f9f'
utxo1 = '00144ba1307f3078561d0f6edd67c9d415391baaf32d'
utxo2 = '00147c45b5aab7f114d90e133ff3fdaf82270ee5ca4a'

# ゴロム・ライス符号エンコードされたデータをデコードするメソッド
# @param [Bitcoin::BitStreamReader] bit_reader
def golomb_rice_decode(bit_reader)
  q = 0
  while bit_reader.read(1) == 1
    q +=1
  end
  r = bit_reader.read(P)
  (q << P) + r
end

# 要素数Nを取得します
n, filter_payload = Bitcoin.unpack_var_int([filter].pack('H*'))

# 検索したいscriptPubkeyのSipHashを計算し、ソートします。
key = [block_hash].pack('H*')[0...16] # ブロックハッシュの先頭16バイト

## SipHashを計算
utxo1_h = SipHash.digest(key, [utxo1].pack('H*'))
utxo2_h = SipHash.digest(key, [utxo2].pack('H*'))
utxo1_n = (utxo1_h * n * M) >> 64
utxo2_n = (utxo2_h * n * M) >> 64
## ソート
hashed_set = [utxo1_n, utxo2_n].sort

# フィルタのペイロードからBitStreamReaderを生成
bit_reader = Bitcoin::BitStreamReader.new(filter_payload)

# フィルタをデコードして要素の確認
value = 0 # 復元したフィルタ要素を保持する一時変数
n.times do
  delta = golomb_rice_decode(bit_reader) # 差分値をデコード
  value += delta # 差分値を加算することで、登録された要素のハッシュ値が復元される
  # 復元された要素のハッシュ値と等しいかチェック
  matched = hashed_set.find { |v| v == value }
  if matched
    puts "matched! utxo_n = #{matched}"
    hashed_set.delete(matched)
  end
end
```
</div></details>

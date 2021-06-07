# 12章 課題

## 任意のコインの量を決め，そのコインを秘匿するための Pedersen Commitment を作成してみましょう。

使用する 2 つのジェネレーター G, H は，以下とします。

* G：secp256k1 のジェネレーター
* H：次の（X, Y）座標をもつ点
（0x50929b74c1a04954b78b4b6035e97a5e078a5a0f28ec96d547bfee9ace803ac0, 0x31d3c6863973926e049e637cb1b5f40a36dac28af1766968c30c2313f3a38904）

[ecdsa](https://github.com/DavidEGrayson/ruby_ecdsa) gem を使うと以下のように計算できます。

```ruby
require 'ecdsa'
require 'securerandom'

group = ECDSA::Group::Secp256k1
H = ECDSA::Point.new(group, 0x50929b74c1a04954b78b4b6035e97a5e078a5a0f28ec96d547bfee9ace803ac0, 0x31d3c6863973926e049e637cb1b5f40a36dac28af1766968c30c2313f3a38904)

# コインの量
value = 1000000

# ブラインドファクターを生成
r = 1 + SecureRandom.random_number(group.order - 1)

# Pedersen Commitmentを計算
commitment = group.generator.multiply_by_scalar(r) + H.multiply_by_scalar(value)
puts ECDSA::Format::PointOctetString.encode(commitment, compression: true).unpack1('H*')
```

## ２．1 の Pedersen Commitment をインプットとして，そのコインの量を半分ずつもつ2つのPedersen Commitmentを作成してみましょう。

この時インプットとアウトプットのブラインドファクターをアウトプットのPedersen Commitment
からインプットのPedersen Commitment を差し引いた値が楕円曲線の無限遠点を指すように選択してください。

1のコードを元に、以下のような計算ができます。

```ruby
# valueの値を２つに分割
value1 = 700000
value2 = 300000

field = ECDSA::PrimeField.new(group.order)

# ２つのブラインドファクターを生成
r1 = 1 + SecureRandom.random_number(r - 1)
r2 = field.mod(r - r1)

# ２つのPedersen Commitmentを生成
commitment1 = group.generator.multiply_by_scalar(r1) + H.multiply_by_scalar(value1)
commitment2 = group.generator.multiply_by_scalar(r2) + H.multiply_by_scalar(value2)

# インプットのcommitmentから２つのcommitmentを差し引くと無限遠点を指す
sum = commitment + (commitment1 + commitment2).negate
puts sum.infinity?
```

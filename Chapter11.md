# 11章 課題

## 2つの鍵ペアを生成し，その2つの公開鍵を加算して集約公開鍵を作成してみましょう。

[ecdsa](https://github.com/DavidEGrayson/ruby_ecdsa) gem を使うと以下のように計算できます。

```ruby
require 'ecdsa'
require 'securerandom'

group = ECDSA::Group::Secp256k1

# 秘密鍵を生成
private_key_a = 1 + SecureRandom.random_number(group.order - 1)
private_key_b = 1 + SecureRandom.random_number(group.order - 1)

# 対応する公開鍵を計算
public_key_a = group.generator.multiply_by_scalar(private_key_a)
public_key_b = group.generator.multiply_by_scalar(private_key_b)

# 集約公開鍵を計算
public_key = public_key_a + public_key_b
puts ECDSA::Format::PointOctetString.encode(public_key, compression: true).unpack1('H*')
## これは両者の秘密鍵を加算して作った秘密鍵に対応する公開鍵と等しい
puts public_key == group.generator.multiply_by_scalar(private_key_a + private_key_b)
```
## ２．任意のメッセージデータに対して，1で作成した集約公開鍵に対して有効なSchnorr署名を作成しましょう。その際，2つの秘密鍵から個別に部分署名を作成して，それらを合算して署名を完成させてください。

1のコードの続きで、以下のように計算できます。

※ 計算内容を把握しやすいよう簡略化して書いたコードなので、プロダクションコードなどで利用する際は既存の暗号ライブラリを使用してください。

```ruby
# nonceの計算
## private_key1の署名に使用するnonce
k_a = 1 + SecureRandom.random_number(group.order - 1)
R_a = group.generator.multiply_by_scalar(k_a)
## private_key2の署名に使用するnonce
k_b = 1 + SecureRandom.random_number(group.order - 1)
R_b = group.generator.multiply_by_scalar(k_b)

# nonceの集約
R = R_a + R_b

# 署名対象のメッセージダイジェストを計算 = Hash(P || R || m)
message = 'Blockchain Technical Overview.'
digest = Digest::SHA256.digest(ECDSA::Format::PointOctetString.encode(public_key) +
                                 ECDSA::Format::PointOctetString.encode(R) + message)
digest = ECDSA.normalize_digest(digest, group.bit_length) % group.order

# 部分署名をそれぞれ計算
## private_key1の部分署名
s1 = (k_a + digest * private_key_a) % group.order
## private_key2の部分署名
s2 = (k_b + digest * private_key_b) % group.order

# 集約署名を計算
s = s1 + s2
# (R.x, s)が署名値

# 署名が有効かどうかは、sG - H(message) * public_key == R が成立するか検証
puts group.generator.multiply_by_scalar(s) + public_key.multiply_by_scalar(digest).negate == R
```

## ３．Rogue-Key攻撃を実際に行ってみましょう。2つの公開鍵A, Bを作成し，BからAを差し引いた公開鍵Cを作成し，AとCから集約公開鍵を計算し，それがBの秘密鍵と等しいことを確認してください。

1のコードを元にしたコードが以下です。

```ruby
# 公開鍵 C = B - Aを計算
public_key_c = public_key_b + public_key_a.negate

# 公開鍵Cを受け取ったAは、以下の集約公開鍵を計算
public_key = public_key_a + public_key_c

# この公開鍵は公開鍵Bと等しい
puts public_key == public_key_b
```
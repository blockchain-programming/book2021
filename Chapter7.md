# 7章 演習

## 1. ビットコインのDNSシードに問い合わせて到達可能なフルノードのIPを取得してみましょう。

Testnetのフルノードの問い合わせは、

    $ dig testnet-seed.bitcoin.jonasschnelli.ch

## ２．ビットコインのノードに接続し，P2Pメッセージ（version，verack）を送受信してハンドシェイクを行い，getaddr，addrメッセージを使ってピアから他のノードのアドレス情報を取得してみましょう。

Rubyの[bitcoin-p2p](https://github.com/azuchi/bitcoin-p2p) gem を使うと、対話的にノードとP2Pメッセージを送受信できます。
`bitcoin-p2p2`を利用する場合は、事前にこのgemをインストールする必要があります。

    $ gem install bitcoin-p2p

最初に接続先のノードのホストとネットワークを指定して、TCP接続を行います。以下ではsignetに接続したlocalhostのノードに接続しています。
`-h`が接続先のホスト（IP）で、`-n`がネットワーク（`mainnet` or `testnet` or `signet`）です。
ビットコインのノードは不正な振る舞いをするノードをBANする機能があるため、実験には自身のノードを利用するのをお勧めします。

    $ bitcoin-p2p -h localhost -n signet
    > connected! You can send version message.

TCP接続ができたら、ハンドシェイクを行ってみましょう。

`version`メッセージを作成

    > ver = Bitcoin::Message::Version.new
    => #<Bitcoin::Message::Version:0x00005590317410f0 @version=70013, @services=8, @timestamp=1611462693, @local_addr=#<Bitcoin::Message::NetworkAddr:0x0000559031738ae0 @time=1611462693, @ip_addr=#<IPAddr: IPv4:127.0.0.1/255.255.255.255>, @port=3...

作成した`version`メッセージを送信

    > send_message(ver)
    => send message data: 0a03cf4076657273696f6e00000000006700000093cb71427d110100080000000000000025f80c6000000000080000000000000000000000000000000000ffff7f00000195bd080000000000000000000000000000000000ffff7f00000195bd519f0f6807576b1c112f626974636f696e72623a302e362e302f0000000000

メッセージを送信すると、相手ノードから相手の`version`メッセージと`verack`メッセージが返ってきます

    => receive version. payload: {"version"=>70016, "services"=>1097, "timestamp"=>1611462696, "local_addr"=>{"time"=>nil, "ip_addr"=>#<IPAddr: IPv6:0000:0000:0000:0000:0000:0000:0000:0000/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff>, "port"=>0, "services"=>0}, "remote_addr"=>{"time"=>nil, "ip_addr"=>#<IPAddr: IPv6:0000:0000:0000:0000:0000:0000:0000:0000/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff>, "port"=>0, "services"=>1033}, "nonce"=>5555482496462444166, "user_agent"=>"/Satoshi:0.21.0/", "start_height"=>21843, "relay"=>true}

最後に、`verack`メッセージを作成し、送信します。

    > ack = Bitcoin::Message::VerAck.new
    => #<Bitcoin::Message::VerAck:0x00005590316342c0>
    > send_message(ack)
    => send message data: 0a03cf4076657261636b000000000000000000005df6e0e2

このメッセージ交換が終わるとハンドシェイクは完了です。

続いて、`getaddr`メッセージを作成して相手のノードが知るノードのIPリストを要求してみましょう。

    > getaddr = Bitcoin::Message::GetAddr.new
    => #<Bitcoin::Message::GetAddr:0x00005587bdf26ad0>
    > send_message(getaddr)

しばらく待つと、`addr`メッセージが返ってきます。

    => receive addr. {"addrs"=>[{"time"=>1621244309, "port"=>38333, "services"=>1033, "net"=>1, 
    "addr"=>#<IPAddr: IPv6:2001:19f0:6001:1c09:a109:47e7:4f61:c0bb/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff>}, ...

[Bit Nodes](https://bitnodes.io/)のようなアクティブなフルノードを掲載するサイトは、
このように`getaddr`/`addr` メッセージで受信したノードに対して、接続し`getaddr`/`addr` メッセージを交換する処理を繰り返し続けることで、
ノード情報を収集しています。

`stop`コマンドでツールは終了できます。

    > stop

他にもさまざまなな[P2Pメッセージ](https://en.bitcoin.it/wiki/Protocol_documentation#Message_types)が定義されているので、
いろんなメッセージの送受信を試してみてください。

## ３．イーサリアムのノードIDと同じように512 bitの公開鍵を5つ生成し，そのうち1つを選択し他の公開鍵を，選択した公開鍵と距離の近い順に，つまりノード間の距離が近い順にソートしてみましょう。

公開鍵の計算の`ecdsa` gemを使用すると、以下のように計算が可能です（下記ではハッシュ関数はKeccak-256ではなく一般的なSHA-256を使用しています）。

```ruby
require 'ecdsa'
require 'securerandom'
require 'digest'

group = ECDSA::Group::Secp256k1

# 5つの公開鍵を作成
public_keys = 5.times.map do
  private_key = 1 + SecureRandom.random_number(group.order - 1)
  public_key = group.generator.multiply_by_scalar(private_key)
  # ecdsa gemでは公開鍵の先頭1バイトにy座標の情報が付与されているためそれを除去
  ECDSA::Format::PointOctetString.encode(public_key)[1..-1]
end

# 1つ公開鍵を選択
selected = Digest::SHA256.hexdigest(public_keys.pop).to_i(16)

# selectedと距離の近い順にソート
sorted = public_keys.sort do |a, b|
  a_h = Digest::SHA256.hexdigest(a).to_i(16)
  b_h = Digest::SHA256.hexdigest(b).to_i(16)
  distance_a = a_h ^ selected
  distance_b = b_h ^ selected
  distance_a <=> distance_b
end

puts sorted.map {|x|x.unpack1('H*')}
```
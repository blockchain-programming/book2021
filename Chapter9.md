## 課題

（1） ［9.1.2］（ビットコインで，）自分宛ての現時点でのUTXO のリストを確認してみましょう。自分宛ての現時点でのUTXO のリストの確認は，listunspent コマンドで一覧を得ることができます。

（2） ［9.1.2］ビットコインのcoinbaseトランザクションを，btc.com などで観察してみましょう。

（3） ［9.3.1］Token Taxonomy Framework以外のトークン分類フレームワークを調査し，比較してみましょう。<br>
> ［参考］例えば，International Token Standardization Association（ITSA）のInternational Token Classification（ITC）フレームワークといったものがあります。

（4） ［9.3.2］ERC20の実装を調べてみましょう。<br>
> ［参考］残高を追跡するためのデータ構造と，引当金を追跡するためのデータ構造の2つのデータ構造が含まれていることがわかります。詳しくは「Mastering Ethereum」などを参照してください。

（5） ［9.3.2］自分独自のERC20トークンを発行してみましょう。<br>
> ［参考］ERC20トークンそのものは，約30行のSolidityコードで実装できます。ただし，セキュアコーディングなどによって，より複雑な実装になります。

## 解答の指針
(1) 
以下などを参考にしてください．<br>
https://qiita.com/osada/items/39c63a146c203f4dc751

(2) 
coinbaseトランザクション = トランザクション手数料がゼロのトランザクション<br>
であることを踏まえて，
btc.com などで任意のブロックを選択し，そのブロックに含まれる数多くのトランザクションのうち， トランザクション手数料 = 0 のTxがcoinbaseトランザクションです．（トランザクション手数料で昇順ソートすると検索・表示しやすいでしょう）

(3) 
Token Taxonomy Framework以外のトークン分類フレームワーク（およびそれに類するもの）には，以下のようなものがあります．
- International Token Standardization Association　http://my.itsa.global/
- クリプトファンドFabric Venturesの記事 “The Fabric Ventures Investment Thesis” の中の"Types of Tokens"の項目．<br>
https://medium.com/fabric-ventures/the-fabric-ventures-investment-thesis-6cd08684b467

(4) 
以下などを参考にしてください．<br>
https://qiita.com/kyrieleison/items/a5c049097c165cd792bf

(5) 
以下などを参考にしてください．<br>
https://qiita.com/amachino/items/8cf609f6345959ffc450

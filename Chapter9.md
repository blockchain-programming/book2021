## 9章 課題

1. ［9.1節］（ビットコインで，）自分宛ての現時点でのUTXO のリストを確認してみましょう。自分宛ての現時点でのUTXO のリストの確認は，`listunspent`コマンドで一覧を得ることができます。

2. ［9.1節］ビットコインのコインベース・トランザクションを，btc.com などで観察してみましょう。

3. ［9.3節］Token Taxonomy Framework以外のトークン分類フレームワークを調査し，比較してみましょう。<br>
> ［参考］例えば，International Token Standardization Association（ITSA）のInternational Token Classification（ITC）フレームワークといったものがあります。

4. ［9.3節］ERC20の実装を調べてみましょう。<br>
> ［参考］残高を追跡するためのデータ構造と，引当金を追跡するためのデータ構造の2つのデータ構造が含まれていることがわかります。詳しくは「Mastering Ethereum」などを参照してください。

5. ［9.3節］自分独自のERC20トークンを発行してみましょう。<br>
> ［参考］ERC20トークンそのものは，約30行のSolidityコードで実装できます。ただし，セキュアコーディングなどによって，より複雑な実装になります。

## 解答の指針
1. 以下などを参考にしてください．<br>
https://qiita.com/osada/items/39c63a146c203f4dc751

2. `coinbaseトランザクション = トランザクション手数料がゼロのトランザクション`
であることを踏まえて，
[btc.com](https://btc.com/) などで任意のブロックを選択し，そのブロックに含まれる数多くのトランザクションのうち， `トランザクション手数料 = 0` のトランザクションがcoinbaseトランザクションです．（トランザクション手数料で昇順ソートすると検索・表示しやすいでしょう）

3. Token Taxonomy Framework以外のトークン分類フレームワーク（およびそれに類するもの）には，以下のようなものがあります．
- International Token Standardization Association　http://my.itsa.global/
- クリプトファンドFabric Venturesの記事 “The Fabric Ventures Investment Thesis” の中の"Types of Tokens"の項目．<br>
https://medium.com/fabric-ventures/the-fabric-ventures-investment-thesis-6cd08684b467

4. [ERC-20 Token Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md) などを参考にしてください．

5. Truffle, OpenZeppelin の環境設定が完了している前提とします．

`contracts` フォルダの中に `MyToken.sol` ファイルを作り，以下のコードを記述します．

```MyToken.sol
pragma solidity ^0.4.18;                // コンパイル時に使用する Solidity コンパイラのバージョン
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract MyToken is StandardToken {
  string public name = "MyToken";       // トークンの名前
  string public symbol = "MTKN";        // トークンのシンボル名（英略称）
  uint public decimals = 18;            // 小数点の桁数

  function MyToken(uint initialSupply) public {
    totalSupply_ = initialSupply;
    balances[msg.sender] = initialSupply;
  }
}
```

記述した Solidity コードをコンパイルします．

```
$ truffle compile
```

次に，`MyToken` コントラクトをデプロイするためのマイグレーションファイルを作ります．`migrations` フォルダの中に　`2_deploy_my_token.js` というファイルを作り，以下のコードを記述します．

```javascript:2_deploy_my_token.js
const MyToken = artifacts.require('./MyToken.sol')

module.exports = (deployer) => {
  const initialSupply = 100e18          // トークン発行量（ここでは　100）
  deployer.deploy(MyToken, initialSupply)
}
```

参考: https://qiita.com/amachino/items/8cf609f6345959ffc450

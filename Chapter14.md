# 14章 ブロックチェーン特有のリスク

## 課題

1. ビットコインのブロックチェーンは，約10分に1回の頻度で1Mバイトのブロックが生成されます。2009年1月3日に最初のブロックが生成されてから，20年後の2029年1月2日までの間に生成されるブロックをすべて記録するためには，どれくらいの量のストレージが必要でしょうか?
1. 14.4節で取り上げた関連法規について，ブロックチェーンに関連する記述を法令検索(参考文献参照)から抜き出してください。
1. ブロックチェーン技術に関連したリスクが顕在化した事案について1つ取り上げ，事象と原因を説明してください。また，対策について考えてください。


## 1. ビットコインのブロックチェーンは，約10分に1回の頻度で1Mバイトのブロックが生成されます。2009年1月3日に最初のブロックが生成されてから，20年後の2029年1月2日までの間に生成されるブロックをすべて記録するためには，どれくらいの量のストレージが必要でしょうか?

### 回答例

生成されるブロックが常に1Mバイトのサイズになると仮定すると、1年間に生成されるデータ量は、

1Mバイト/10分 * 60分 * 24時間 * 365日 = 52,560Mバイト。

です。

これを20年間一定で発生すると、

52,560Mバイト/年 * 20年 = 1,051,200Mバイト

となります。大まかに1TBのストレージが必要になります。

### 発展課題

* 1TBのデータを実行速度が100Mbpsのネットワークでダウンロードすると、どれくらいの時間がかかるでしょうか?


## 2. 14.4節で取り上げた関連法規について，ブロックチェーンに関連する記述を法令検索(参考文献参照)から抜き出してください。

### 回答例

2021年5月時点の例です。

* 電子署名及び認証業務に関する法律（抜粋）

```
第二条　この法律において「電子署名」とは，電磁的記録（電子的方式，磁気的方式その他人の知覚によっては認識することができない方式で作られる記録であって，電子計算機による情報処理の用に供されるものをいう。以下同じ。）に記録することができる情報について行われる措置であって，次の要件のいずれにも該当するものをいう。
　一　当該情報が当該措置を行った者の作成に係るものであることを示すためのものであること。
　二　当該情報について改変が行われていないかどうかを確認することができるものであること。
２　この法律において「認証業務」とは，自らが行う電子署名についてその業務を利用する者（以下「利用者」という。）その他の者の求めに応じ，当該利用者が電子署名を行ったものであることを確認するために用いられる事項が当該利用者に係るものであることを証明する業務をいう。
３　この法律において「特定認証業務」とは，電子署名のうち，その方式に応じて本人だけが行うことができるものとして主務省令で定める基準に適合するものについて行われる認証業務をいう。

第三条　電磁的記録であって情報を表すために作成されたもの（公務員が職務上作成したものを除く。）は，当該電磁的記録に記録された情報について本人による電子署名（これを行うために必要な符号及び物件を適正に管理することにより，本人だけが行うことができることとなるものに限る。）が行われているときは，真正に成立したものと推定する。

第四条　特定認証業務を行おうとする者は，主務大臣の認定を受けることができる。
２　前項の認定を受けようとする者は，主務省令で定めるところにより，次の事項を記載した申請書その他主務省令で定める書類を主務大臣に提出しなければならない。
　一　氏名又は名称及び住所並びに法人にあっては，その代表者の氏名
　二　申請に係る業務の用に供する設備の概要
　三　申請に係る業務の実施の方法
３　主務大臣は，第一項の認定をしたときは，その旨を公示しなければならない。
```


* 資金決済に関する法律（抜粋）

```
第二条　この法律において「前払式支払手段発行者」とは，次条第六項に規定する自家型発行者及び同条第七項に規定する第三者型発行者をいう。

５　この法律において「暗号資産」とは，次に掲げるものをいう。ただし，金融商品取引法（昭和二十三年法律第二十五号）第二条第三項に規定する電子記録移転権利を表示するものを除く。
　一　物品を購入し，若しくは借り受け，又は役務の提供を受ける場合に，これらの代価の弁済のために不特定の者に対して使用することができ，かつ，不特定の者を相手方として購入及び売却を行うことができる財産的価値（電子機器その他の物に電子的方法により記録されているものに限り，本邦通貨及び外国通貨並びに通貨建資産を除く。次号において同じ。）であって，電子情報処理組織を用いて移転することができるもの
　二　不特定の者を相手方として前号に掲げるものと相互に交換を行うことができる財産的価値であって，電子情報処理組織を用いて移転することができるもの

７　この法律において「暗号資産交換業」とは，次に掲げる行為のいずれかを業として行うことをいい，「暗号資産の交換等」とは，第一号及び第二号に掲げる行為をいい，「暗号資産の管理」とは，第四号に掲げる行為をいう。
　一　暗号資産の売買又は他の暗号資産との交換
　二　前号に掲げる行為の媒介，取次ぎ又は代理
　三　その行う前二号に掲げる行為に関して，利用者の金銭の管理をすること。
　四　他人のために暗号資産の管理をすること（当該管理を業として行うことにつき他の法律に特別の規定のある場合を除く。）。

８　この法律において「暗号資産交換業者」とは，第六十三条の二の登録を受けた者をいう。
```

* 個人情報の保護に関する法律（抜粋）

```
第二条　この法律において「個人情報」とは，生存する個人に関する情報であって，次の各号のいずれかに該当するものをいう。
　一　当該情報に含まれる氏名，生年月日その他の記述等（文書，図画若しくは電磁的記録（電磁的方式（電子的方式，磁気的方式その他人の知覚によっては認識することができない方式をいう。次項第二号において同じ。）で作られる記録をいう。第十八条第二項において同じ。）に記載され，若しくは記録され，又は音声，動作その他の方法を用いて表された一切の事項（個人識別符号を除く。）をいう。以下同じ。）により特定の個人を識別することができるもの（他の情報と容易に照合することができ，それにより特定の個人を識別することができることとなるものを含む。）
　二　個人識別符号が含まれるもの
２　この法律において「個人識別符号」とは，次の各号のいずれかに該当する文字，番号，記号その他の符号のうち，政令で定めるものをいう。
一　特定の個人の身体の一部の特徴を電子計算機の用に供するために変換した文字，番号，記号その他の符号であって，当該特定の個人を識別することができるもの
二　個人に提供される役務の利用若しくは個人に販売される商品の購入に関し割り当てられ，又は個人に発行されるカードその他の書類に記載され，若しくは電磁的方式により記録された文字，番号，記号その他の符号であって，その利用者若しくは購入者又は発行を受ける者ごとに異なるものとなるように割り当てられ，又は記載され，若しくは記録されることにより，特定の利用者若しくは購入者又は発行を受ける者を識別することができるもの
９　この法律において「匿名加工情報」とは，次の各号に掲げる個人情報の区分に応じて当該各号に定める措置を講じて特定の個人を識別することができないように個人情報を加工して得られる個人に関する情報であって，当該個人情報を復元することができないようにしたものをいう。
一　第一項第一号に該当する個人情報　当該個人情報に含まれる記述等の一部を削除すること（当該一部の記述等を復元することのできる規則性を有しない方法により他の記述等に置き換えることを含む。）。
二　第一項第二号に該当する個人情報　当該個人情報に含まれる個人識別符号の全部を削除すること（当該個人識別符号を復元することのできる規則性を有しない方法により他の記述等に置き換えることを含む。）。
１０　この法律において「匿名加工情報取扱事業者」とは，匿名加工情報を含む情報の集合物であって，特定の匿名加工情報を電子計算機を用いて検索することができるように体系的に構成したものその他特定の匿名加工情報を容易に検索することができるように体系的に構成したものとして政令で定めるもの（第三十六条第一項において「匿名加工情報データベース等」という。）を事業の用に供している者をいう。ただし，第五項各号に掲げる者を除く。
```

## 3. ブロックチェーン技術に関連したリスクが顕在化した事案について1つ取り上げ，事象と原因を説明してください。また，対策について考えてください。

### 回答例（ヒント）

The DAO事件、Mt.GOX事件、MonaCoin（Block withholding attack）について調べてみましょう。




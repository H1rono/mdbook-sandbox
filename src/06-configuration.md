# Configuration

[General - mdBook Documentation](https://rust-lang.github.io/mdBook/format/configuration/general.html)

## 設定ファイル

[Usage #新しいドキュメントを作成](./03-usage.md#新しいドキュメントを作成)でも少し触れましたが、mdBookの設定は`book.toml`に記述します。以下はこのドキュメントの([`1640d5d`](https://github.com/H1rono/mdbook-sandbox/commit/1640d5d602b9ce07faa6e2b2c673f8b9a1f5ecf1)時点の)book.tomlです。

```toml
[book]
authors = ["H1rono"]
language = "ja"
multilingual = false
src = "src"
title = "H1rono sandbox"
description = "mdBookのテスト用のリポジトリです。"

[output.html]
git-repository-url = "https://github.com/H1rono/mdbook-sandbox"
git-repository-icon = "fa-github"
```

TOMLに関しては[TOML: Tom's Obvious Minimal Language](https://toml.io/en/), [toml-lang/toml: Tom's Obvious, Minimal Language](https://github.com/toml-lang/toml)を参照してください。

## 一般的な設定

`[book]`内に記述する設定項目です。([v0.4.28のソースコード](https://github.com/rust-lang/mdBook/blob/efb671aaf241b7f93597ac70178989a332fe85e0/src/config.rs#L397-L414))

項目名 | 内容
:-- | :--
`title` | ドキュメント全体のタイトル。HTMLでは`head`内の`title`要素に反映される
`authors` | ドキュメントの作者(複数)
`description` | ドキュメントの説明。HTMLでは`head`内の`meta name="description"`要素に反映される
`src` | ドキュメントのソース(`SUMMARY.md`など)が置いてあるディレクトリ名。デフォルトでは`"src"`
`language` | ドキュメントが記述されている基本言語。HTMLでは`html`要素の[`lang`属性](https://developer.mozilla.org/ja/docs/Web/HTML/Global_attributes/lang)に反映される。デフォルトでは`"en"`
`multilingual` | ドキュメントが複数言語で記述されているかどうか(詳細は調べていません)。`true`または`false`で、デフォルトでは`false`

設定例:

```toml
[book]
title = "Sample"
authors = ["H1rono"]
description = "てすと"
src = "docs"
language = "ja"
multilingual = false
```

> language関連に関して少し思ったことを書いておきます。
>
> そもそも、`language: String, multilingual: bool`だと`multilingual = true`の場合に"副"言語はなんなのかがはっきりしません。`language`を`Vec<String>`とかにしたらいいのではとも思ったんですが、こうすると複数個の`language`が与えられた時に各ページの`lang`属性をどうすればいいのかが定まりません。各ファイルごとに[YAMLフロントマター](https://publish.obsidian.md/help-ja/%E9%AB%98%E5%BA%A6%E3%81%AA%E3%83%88%E3%83%94%E3%83%83%E3%82%AF/YAML%E3%83%95%E3%83%AD%E3%83%B3%E3%83%88%E3%83%9E%E3%82%BF%E3%83%BC)で`lang`を記述して、book.tomlにはlanguageへの言及をなくせば全て解決するのではと思ったのですが、どうなんでしょうか。[ドキュメント](https://rust-lang.github.io/mdBook/index.html)にはYAMLフロントマターに関する記述はありません。[リポジトリのissue](https://github.com/rust-lang/mdBook/issues?q=is%3Aissue)では[146](https://github.com/rust-lang/mdBook/issues/146)で言及されていそうですが、私が英語に強くないので全体像が掴めませんでした。

## Rustのオプション

`[rust]`内に記述する設定項目です。([v0.4.28のソースコード](https://github.com/rust-lang/mdBook/blob/efb671aaf241b7f93597ac70178989a332fe85e0/src/config.rs#L456-L462))

項目名 | 内容
:-- | :--
`edition` | Playgroundで使用するデフォルトのRustエディション。デフォルトは`"2015"`

コードブロックごとにRustのエディションを編集することも可能です。

    ```rust,edition2019
    let x = 10;
    ```

設定例:

```toml
[rust]
edition = "2021"
```

## ビルドのオプション

`[build]`内に記述する設定項目です。([v0.4.28のソースコード](https://github.com/rust-lang/mdBook/blob/efb671aaf241b7f93597ac70178989a332fe85e0/src/config.rs#L429-L443))

項目名 | 内容
:-- | :--
`build-dir` | ビルド成果物を置くディレクトリ名。デフォルトでは`"book"`
`create-missing` | ビルド時に[SUMMARY.md](https://rust-lang.github.io/mdBook/format/summary.html)で記述されているが存在しないmdがある場合にそれを作成するかどうか。デフォルトでは`true`
`use-default-preprocessors` | デフォルトのプリプロセッサーが指定されたレンダラーに互換である場合、それを使用するかどうか。デフォルトでは`true`
`extra-watch-dirs` | `watch`および`serve`コマンドで監視される追加のディレクトリ群

[Usage](./03-usage.md)で触れましたが、CLIで`--build-dir`オプションが提供されています。このオプションはbook.tomlの`build-dir`オプションより優先されます。

設定例:

```toml
[build]
build-dir = "book"
create-missing = true
use-default-preprocessors = true
extra-watch-dirs = ["src"]
```

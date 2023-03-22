# Usage

- [Creating a Book - mdBook Documentation](https://rust-lang.github.io/mdBook/guide/creating.html)
- [Command Line Tool - mdBook Documentation](https://rust-lang.github.io/mdBook/cli/index.html)

## 新しいドキュメントを作成

[init - mdBook Documentation](https://rust-lang.github.io/mdBook/cli/init.html)

`mdbook init`コマンドで現在のディレクトリにドキュメント用のファイル構造を生成します。`mdbook init some/dir`のように生成するディレクトリを指定することも可能です。

```bash
$ mdbook init
$ mdbook init some/dir
```

これらのコマンドを実行すると、まずmdBook用に`.gitignore`ファイルを生成するかどうか`y/n`で尋ねられます。次のように`--ignore`オプションをつけていた場合は尋ねられることなく`.gitignore`が作られます。

```bash
$ mdbook init --ignore
```

`.gitignore`の内容は次のとおりです。

```
book
```

`book`はmdBookがMarkdownからドキュメントを作成する際に成果物が置かれるディレクトリです。

次に、ドキュメント全体のタイトルを尋ねられます。`--title="book title"`のようにオプションで指定していた場合は尋ねられません。

```bash
$ mdbook init --title="book title"
```

`.gitignore`の有無とドキュメント全体のタイトルが決まったらmdBookの設定ファイル(`book.toml`)とデフォルトのMarkdownが作成されます。コマンド終了後のファイル構造は以下のとおりです。

```
.
├── .gitignore
├── book
├── book.toml
└── src
    ├── SUMMARY.md
    └── chapter_1.md
```

各ファイル/フォルダの説明は以下のとおりです。

ファイル/フォルダ名 | 説明
:-- | :--
`.gitignore` | 前述のもの
`book` | ドキュメント生成時の成果物を置くフォルダ
`book.toml` | ドキュメントの設定ファイル
`src/SUMMARY.md` | ドキュメントのチャプター 一覧を記述するファイル
`src/chapter_1.md` | チャプターのサンプル

## ドキュメントをビルド

[build - mdBook Documentation](https://rust-lang.github.io/mdBook/cli/build.html)

`mdbook build`でドキュメントのビルドが行われます。`mdbook build some/dir`のようにディレクトリを指定すると、そのディレクトリにmdBookの設定ファイル`book.toml`があるものとしてビルドが行われます。

```bash
$ mdbook build
$ mdbook build some/dir
```

`--open`または`-o`オプションをつけると、ビルド後に成果物がブラウザで開かれます。

```bash
$ mdbook build -o
$ mdbook build some/dir --open
```

`--dest-dir path/to/dir`または`-d path/to/dir`のようにオプションを追加してディレクトリを指定すると、ビルドの成果物はそのディレクトリ内に配置されます。

```bash
$ mdbook build --dest-dir path/to/dir
$ mdbook build source/dir -o -d dest/dir
```

## 変更を検知して自動的にビルド

[watch - mdBook Documentation](https://rust-lang.github.io/mdBook/cli/watch.html)

`mdbook watch`コマンドでMarkdown等のファイルに変更がある度に自動的にビルドが行われるようになります。オプション等は`mdbook build`コマンドと同様です。

```bash
$ mdbook watch
$ mdbook watch source/dir --open --dest-dir dest/dir
```

このコマンドで監視されるファイルは`.gitignore`に含まれないもの全てです。例えば、`.gitignore`が次のように`mdbook init`後に生成されるものだとします。

```
book
```

この時、`mdbook watch`でビルドが行われると(特に指定していなければ)`book`フォルダ内に成果物が書き込まれて`book`フォルダ内で変更が発生しますが、`book`フォルダは監視対象に含まれないためこの変更による自動ビルドは行われません。

## 監視と同時にローカルサーバーを立てる

[serve - mdBook Documentation](https://rust-lang.github.io/mdBook/cli/serve.html)

`mdbook serve`コマンドではファイルの監視を開始し、また更新に伴って自動的にブラウザのページを更新させるHTTPサーバーを立てます。サーバーには`http://localhost:3000`でアクセスできます。

```bash
$ mdbook serve
```

このコマンドはあくまで開発用であり、本番のサーバーで常時実行するのに適しているわけではありません。

監視には`watch`と同様のオプションがあります。監視されるファイルの基準も`watch`コマンドと同様です。

```bash
$ mdbook serve source -o -d dest
```

`--port 8080`や`-p 8080`のようにオプションでサーバーのポート番号を指定することができます。また、`--hostname hostname`や`-n hostname`のようにオプションでサーバーのホスト名を指定することができます。例えば、次のコマンドでサーバーを立てると`http://127.0.0.1:8080`でアクセスできるようになります。

```bash
$ mdbook serve -p 8080 -n 127.0.0.1
```

## ビルド成果物を削除

[clean - mdBook Documentation](https://rust-lang.github.io/mdBook/cli/clean.html)

`mdbook clean`コマンドでビルドの成果物が削除されます。`mdbook clean some/dir`のように`book.toml`のあるディレクトリを指定することができます。

また、`--dest-dir dest/dir`や`-d dest/dir`のようにオプションで成果物を配置するディレクトリを指定することも可能です。

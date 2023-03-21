# Usage

- [Creating a Book - mdBook Documentation](https://rust-lang.github.io/mdBook/guide/creating.html)
- [Command Line Tool - mdBook Documentation](https://rust-lang.github.io/mdBook/cli/index.html)

## 新しいドキュメントを作成

[init - mdBook Documentation](https://rust-lang.github.io/mdBook/cli/init.html)

`mdbook init`コマンドで現在のディレクトリにドキュメント用のファイル構造を生成します。`mdbook init some/dir`のように生成するディレクトリを指定することも可能です。

これらのコマンドを実行すると、まずmdBook用に`.gitignore`ファイルを生成するかどうか`y/n`で尋ねられます。`--ignore`オプションをつけていた場合は尋ねられることなく`.gitignore`が作られます。`.gitignore`の内容は次のとおりです。

```
book
```

`book`はmdBookがMarkdownからドキュメントを作成する際に成果物が置かれるディレクトリです。

次に、ドキュメント全体のタイトルを尋ねられます。`--title="book title"`のようにオプションで指定していた場合は尋ねられません。

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
`src/SUMMARY.md` | ドキュメントのチャプター 一覧を記述するファイル
`src/chapter_1.md` | デフォルトのチャプター

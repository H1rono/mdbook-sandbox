# Preprocessor

- [Configuration - mdBook Documentation](https://rust-lang.github.io/mdBook/format/configuration/index.html)
    - [Preprocessors - mdBook Documentation](https://rust-lang.github.io/mdBook/format/configuration/preprocessors.html)
- [For Developers - mdBook Documentation](https://rust-lang.github.io/mdBook/for_developers/index.html)
    - [Preprocessors - mdBook Documentation](https://rust-lang.github.io/mdBook/for_developers/preprocessors.html)

## Preprocessorとは

markdownをHTMLにレンダリングする前にMarkdownを加工するものです。公式のドキュメントでは以下のようなことができる、と紹介されています。

- `links`: `{{ #playground }}`や`{{ #include }}`といった記述を適切な内容に置き換える。
    - これはmdBook独自に実装されている機能です。詳細は[mdBook-specific features - mdBook Documentation #Including files](https://rust-lang.github.io/mdBook/format/mdbook.html#including-files)を参照してください。
- `index`: README.mdをindex.mdにrenameして扱う。これによって、レンダリング時にREADME.mdの内容がindex.htmlに出力される。

組み込みのpreprocessorはbook.tomlの[`build.use-default-preprocessor`](https://rust-lang.github.io/mdBook/format/configuration/general.html#build-options)を設定することで使用/不使用を切り替えられます。([H1rono sandbox内での言及](./06-configuration.md#ビルドのオプション))

また、GitHubのwikiには[サードパーティー製プラグインのリスト](https://github.com/rust-lang/mdBook/wiki/Third-party-plugins)があります。

## Preprocessorの設定方法

preprocessorを設定する場合はbook.tomlに次のように追記します。

```toml
[preprocessor.foo]
command = "bar"
```

このように設定した場合、mdBookのビルド時に`bar`コマンドでpreprocessorが呼び出されます。`command`を指定しなかった場合のコマンド名は`mdbook-foo`となります。また、次のようにカスタムの設定を加えることができます。

```toml
[preprocessor.foo]
some-option = "hoge"
```

特定のレンダラーのみに対してpreprocessorが動作するように指定することも可能です。

```toml
[preprocessor.foo]
renderers = ["html"]
```

このように設定すると、`foo`preprocessorは`html`レンダラーのみに対して動作します。

## Preprocessorの実行順序

preprocessorが適用される順序は次のような設定で制御することができます。

```toml
[preprocessor.hoge]
after = ["fuga"]
```

or

```toml
[preprocessor.fuga]
before = ["hoge"]
```

## Preprocessorのコマンドと使われ方

`command`に設定された項目はシェルのコマンドとして扱われます。即ち、以下のような設定をすることも可能です。

```toml
command = "python3 a.py"
```

mdBookのビルド時、コマンドは **2度** 実行されます。実行の内容は以下のとおりです。

1. `{command} supports {renderer}`(`mdbook-foo supports html`など)でSTDINはなし
    - preprocessorが与えられた`renderer`に対応しているかどうかを確かめるために使われる
    - 対応している場合は`0`, 対応していない場合は非`0`のステータスコードを返す
2. `{command}`(`python3 foo.py`など)でstdinに`[context, book]`の配列(タプル-like)
    - `context`は`PreprocessorContext`型([ドキュメント](https://docs.rs/mdbook/latest/mdbook/preprocess/struct.PreprocessorContext.html), [ソースコード](https://github.com/rust-lang/mdBook/blob/efb671aaf241b7f93597ac70178989a332fe85e0/src/preprocess/mod.rs#L20-L36))
    - `book`は`Book`型([ドキュメント](https://docs.rs/mdbook/latest/mdbook/book/struct.Book.html), [ソースコード](https://github.com/rust-lang/mdBook/blob/efb671aaf241b7f93597ac70178989a332fe85e0/src/book/book.rs#L70-L84))
    - stdoutに **`Book`型** のJSONオブジェクトを出力してpreprocessorの加工結果とする

前述の通り`python3 fuga.py`のようにスクリプトをコマンドに指定することも可能です。そこで、ここではシェルスクリプトで引数とstdinの内容を確認してみます。↓のスクリプトをa.bashのようなファイル名で保存します。

```bash
#!/bin/bash

[ "$1" = "supports" ] && {
    echo $@ >&2
    exit 0
}
STDIN=`cat`
echo -n "$STDIN" | jq --indent 4 > ./dump.json
echo -n "$STDIN" | jq -c '.[1]'
```

※ このスクリプトでは[jq](https://github.com/stedolan/jq)を使用してJSONの整形、加工を行っています。実際に使用したファイルは[scripts/preprocessor-dump.bash](https://github.com/H1rono/mdbook-sandbox/blob/main/scripts/preprocessor-dump.bash)です。

このスクリプトは以下のような内容を実行しています。

1. 第一引数が`supports`の場合(=1度目の実行の場合)
    1. stderrに引数リストを出力(stdinへ出力してもコンソールには出ないため)
    2. ステータスコード`0`で終了(=これ以降は2度目の実行となる)
2. stdinの内容を変数`STDIN`に代入(stdinは`[context, book]`のような構造のJSON文字列)
3. インデント4マスで整形してdump.jsonに出力
4. 変数`STDIN`をJSONの配列として解析し、(0-indexで)1番目のオブジェクトを取り出してstdoutに出力(`book`オブジェクトを無加工で返す)

スクリプトができたら、次はmdbookのプロジェクト設定でそのスクリプトを呼び出すようにpreprocessorを追加します。book.tomlを次のように編集します。

```toml
[preprocessor.sample]
command = "bash scripts/preprocessor-dump.bash"
some-extra-config = "hoge"
```

設定ができたらビルドを行います。以降の出力結果はこのリポジトリ([H1rono/mdbook-sandbox](https://github.com/H1rono/mdbook-sandbox))の[`63510ea`](https://github.com/H1rono/mdbook-sandbox/tree/63510eafea20f29973cb227eacb042539a9802ed)時点で実験したものです。

**シェル**

```
$ mdbook build
2023-04-12 18:15:40 [INFO] (mdbook::book): Book building has started
supports html
2023-04-12 18:15:40 [INFO] (mdbook::book): Running the html backend
```

**dump.json**(でかいので一部省略)

```javascript
[
    {
        "root": "/Users/kh/Documents/lab/mdbook-sandbox",
        "config": {
            "book": {
                "authors": [
                    "H1rono"
                ],
                "description": "mdBookのテスト用のリポジトリです。",
                "language": "ja",
                "multilingual": false,
                "src": "src",
                "title": "H1rono sandbox"
            },
            "output": {
                "html": {
                    "git-repository-icon": "fa-github",
                    "git-repository-url": "https://github.com/H1rono/mdbook-sandbox"
                }
            },
            "preprocessor": {
                "sample": {
                    "command": "scripts/preprocessor-dump.bash",
                    "some-extra-config": "hoge"
                }
            }
        },
        "renderer": "html",
        "mdbook_version": "0.4.28"
    },
    {
        "sections": [
            {
                "Chapter": {
                    "name": "index",
                    "content": "# index\n\nこの本は[mdBook]のテスト用に作成されたものです。[mdBook]に関してやったこと/わかったことなどを書いていく予定です。\n\n## Contributing\n\nこの本に誤りがあれば、[Issueを作成](https://github.com/H1rono/mdbook-sandbox/issues/new/choose)するか[Pull Requestを作成](https://github.com/H1rono/mdbook-sandbox/compare)してください。質問等もIssueにお願いします。\n\n## License\n\nMIT Licenseです。 [リポジトリのLICENSEファイル](https://github.com/H1rono/mdbook-sandbox/blob/main/LICENSE)\n\n[mdBook]: https://github.com/rust-lang/mdBook\n",
                    "number": null,
                    "sub_items": [],
                    "path": "index.md",
                    "source_path": "index.md",
                    "parent_names": []
                }
            },
            {
                "Chapter": {
                    "name": "Introduction",
                    "content": "...",
                    "number": [
                        1
                    ],
                    "sub_items": [],
                    "path": "01-introduction.md",
                    "source_path": "01-introduction.md",
                    "parent_names": []
                }
            },
            ...
        ],
        "__non_exhaustive": null
    }
]
```

`context`部分と`book`部分をそれぞれ抜き出しておきます。

`context`

```javascript
{
    "root": "/Users/kh/Documents/lab/mdbook-sandbox",
    "config": {
        "book": {
            "authors": [
                "H1rono"
            ],
            "description": "mdBookのテスト用のリポジトリです。",
            "language": "ja",
            "multilingual": false,
            "src": "src",
            "title": "H1rono sandbox"
        },
        "output": {
            "html": {
                "git-repository-icon": "fa-github",
                "git-repository-url": "https://github.com/H1rono/mdbook-sandbox"
            }
        },
        "preprocessor": {
            "sample": {
                "command": "scripts/preprocessor-dump.bash",
                "some-extra-config": "hoge"
            }
        }
    },
    "renderer": "html",
    "mdbook_version": "0.4.28"
}
```

`book`

```javascript
{
    "sections": [
        {
            "Chapter": {
                "name": "index",
                "content": "# index\n\nこの本は[mdBook]のテスト用に作成されたものです。[mdBook]に関してやったこと/わかったことなどを書いていく予定です。\n\n## Contributing\n\nこの本に誤りがあれば、[Issueを作成](https://github.com/H1rono/mdbook-sandbox/issues/new/choose)するか[Pull Requestを作成](https://github.com/H1rono/mdbook-sandbox/compare)してください。質問等もIssueにお願いします。\n\n## License\n\nMIT Licenseです。 [リポジトリのLICENSEファイル](https://github.com/H1rono/mdbook-sandbox/blob/main/LICENSE)\n\n[mdBook]: https://github.com/rust-lang/mdBook\n",
                "number": null,
                "sub_items": [],
                "path": "index.md",
                "source_path": "index.md",
                "parent_names": []
            }
        },
        {
            "Chapter": {
                "name": "Introduction",
                "content": "...",
                "number": [
                    1
                ],
                "sub_items": [],
                "path": "01-introduction.md",
                "source_path": "01-introduction.md",
                "parent_names": []
            }
        },
        ...
    ],
    "__non_exhaustive": null
}
```

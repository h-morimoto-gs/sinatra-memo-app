
# メモアプリ

Sinatra で作ったシンプルなメモアプリです。メモは JSON ファイルに保存されます。

## 動作環境

- Ruby 4.0.6
- Sinatra 4.2

## セットアップ

```
$ git clone https://github.com/h-morimoto-gs/sinatra-memo-app.git
$ cd sinatra-memo-app
$ bundle install
```

## 起動方法

```
$ bundle exec ruby app.rb
```
## 機能

| メソッド | パス | 機能 |
| --- | --- | --- |
| GET | `/` | `/memos` へリダイレクト |
| GET | `/memos` | メモの一覧を表示 |
| GET | `/memos/new` | メモの新規作成フォームを表示 |
| POST | `/memos` | メモを新規作成 |
| GET | `/memos/:id` | メモの詳細を表示 |
| GET | `/memos/:id/edit` | メモの編集フォームを表示 |
| PATCH | `/memos/:id` | メモを更新 |
| DELETE | `/memos/:id` | メモを削除 |

## データの保存先

メモは `data/memos.json` に JSON 形式で保存されます。
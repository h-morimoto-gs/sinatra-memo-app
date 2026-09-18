# メモアプリ

Sinatra で作ったシンプルなメモアプリです。メモは PostgreSQL に保存されます。

## 動作環境

- Ruby 4.0.6
- Sinatra 4.2
- PostgreSQL 17.11

## セットアップ

```
$ git clone https://github.com/h-morimoto-gs/sinatra-memo-app.git
$ cd sinatra-memo-app
$ git checkout feature/postgresql
$ bundle install
```

## データベースの準備

PostgreSQL を起動した状態で、以下を実行してください。
`memo_app` データベースと `memos` テーブルが作成されます。

```
$ psql -d postgres -f db/schema.sql
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

メモは PostgreSQL の `memo_app` データベース内の `memos` テーブルに保存されます。
テーブル定義は `db/schema.sql` を参照してください。

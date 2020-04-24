# DockerでReact開発環境構築

## 構築の流れ
1. Dockerインストール
1. docker-composeインストール
1. 作業ディレクトリの作成
1. Dockerfile、docker-compose.ymlの作成
1. Dockerイメージのビルド
1. create-react-appとReactのインストール
1. コンテナの起動とReactの実行

## Dockerインストール

公式リファレンス参照  
http://docs.docker.jp/get-started/toc.html
  
インストール後、Docker Desktopを起動した状態にしておく。

## docker-compose
Docker composeは複数のコンテナをまとめて管理するためのツール。  
コンテナオーケストレーションツールKubernetes（k8s）の簡易版みたいなツール。  
公式リファレンス参照  
http://docs.docker.jp/get-started/toc.html


## 作業ディレクトリの作成
適当な場所で作業用ディレクトリを作成する。
Github等で管理する

## Dockerfile
作業ディレクトリにファイル名「Docker」（拡張子）を作成し、以下を記述する。  
```
# コンテナのベースとなるDockerイメージ
FROM node:8.16.0-alpine
# 作業ディレクトリ　※起動後ここがカレントになる
WORKDIR /usr/src/app

#-----------------------------------------------
# RUN ※ビルド時のみ実行するコマンド
#-----------------------------------------------
# npm の初回のみ、--saveオプションでpackage.jsonへ作成して追加
# create-react-app：Reactアプリを簡単に作成
RUN npm install --save prop-types
# prop-types：Reactの型指定
RUN npm install -g create-react-app

```

## docker-compose.ymlの作成

各コンテナの構成情報はdocker-compose.ymlファイルに記述します。
```
# docker-composeのバージョン
version: '3'
# 構築するサービス情報：１階層下にサービス単位で設定を記述
services:
  # [node]という名前のサービス ↓↓↓ここから
  node:
    build:
      #docker-compose.ymlがあるディレクトリに対するDockerfileのディレクトリを指定
      #この場合、docker-compose.ymlと同一ディレクトリのDockerfileを読み込む
      context: .

    # コンテナを起動させ続けるかどうかの選択
    tty: true

    # 環境変数を追加
    environment:
      - NODE_ENV=production

    # ローカルのディレクトリが接続（マウント）する作業ディレクトリを指定
    # コロン「:」の左側がホストのパス、右側がコンテナ内のパス
    # この場合、ホスト側のカレントディレクトリへコンテナの「/usr/src/app」をマウントする
    volumes:
      - "..:/usr/src/app"

    # コンテナ起動時（docker-compose up）で実行されるコマンド
    command: sh -c "cd docker-app && yarn start"

    # 外部に対して公開するポート番号
    # 左側（ホスト）がブラウザ側で指定するポート、右側（コンテナ）がコンテナ内のポート
    ports:
      - "3001:3000"
# [node]という名前のサービス  ↑↑↑ここまで

# 複数サービスを起動させる場合は、上記と同じような記述で各サービスの設定を記述する

```

## イメージのbuild
初回はダウンロードが発生するため、時間がかかる
```
$ docker-compose build
```
## react-create-appでアプリディレクトリ作成
```
$ docker-compose run --rm node sh -c 'create-react-app sample-project'
```
コマンドを実行したいだけなので、--rmオプションで使用したコンテナはコマンド実行後削除する


## コンテナ起動
```
docker-compose up
```
起動に少し時間がかかります。以下メッセージが表示されれば、ブラウザで接続可能です。※「node_1」部分は可変です。
```
$ docker-compose up
...
Compiled successfully!
node_1  |
node_1  | You can now view sample-project in the browser.
node_1  |
node_1  |   Local:            http://localhost:3000
node_1  |   On Your Network:  http://172.20.0.2:3000
node_1  |
node_1  | Note that the development build is not optimized.
node_1  | To create a production build, use yarn build.
node_1  |
```

ブラウザで接続  
http://localhost:3001/  
Reactの画面が表示されれば成功で、  
sample-project/src/App.jsを修正して保存するとリアルタイムで更新されます。

## コンテナから抜ける
ctrl + C でプロンプトに戻る

## コンテナ停止
```
$ docker-compose down
```
```
# コンテナ確認　起動中
$docker-compose ps
      Name                     Command               State    Ports
-------------------------------------------------------------------
docker-app_node_1   docker-entrypoint.sh sh -c ...   Exit 1

# コンテナ削除
$ docker-compose down
Removing docker-app_node_1 ... done
Removing network docker-app_default

# コンテナ確認　コンテナが削除されている
$ docker-compose ps
Name   Command   State   Ports
------------------------------

```

## 備考
```
docker-compose run --rm node sh -c "pwd"
docker-compose run node sh -c "pwd"
docker-compose run node sh -c "ls"
```


# DockerでReact開発環境構築
参考サイト
https://blog.web.nifty.com/engineer/2714

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

## 作業ディレクトリの作成
適当な場所で作業用ディレクトリを作成する。

## Dockerfile
作業ディレクトリにファイル名「Docker」（拡張子）を作成し、以下を記述する。  
```
FROM node:8.16.0-alpine
WORKDIR /usr/src/app
```
FROM：コンテナのベースとなるDockerイメージ
WORKDIR：コンテナ内の作業ディレクトリ

## docker-compose.ymlの作成

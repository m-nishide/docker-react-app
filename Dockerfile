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

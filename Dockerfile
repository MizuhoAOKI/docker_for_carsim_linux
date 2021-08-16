# last update: 2021.08.16

# ベースイメージ(ubuntu)を指定, 独自のイメージ名称(cpp_env)を設定.
FROM ubuntu:18.04 as ubunt1804image

# 環境変数: インストール時に対話形式の設定を行わない
ENV DEBIAN_FRONTEND=noninteractive

# C++環境構築 
RUN apt-get update && \
    apt-get install -y git build-essential cmake tree sudo vim
    # libeigen3-dev libboost-dev gdb vim

RUN mkdir workspace

# 環境設定ファイルのコピー
# COPY ./settings/* /root/

# Set region to jp
# RUN locale-gen ja_JP.UTF-8  
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
# ENV LC_ALL ja_JP.UTF-8
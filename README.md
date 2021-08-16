# DockerによるC++開発環境構築メモ
Dockerを使うと, 

- ✅　一度設定ファイルを用意すれば, 同じ開発環境を何度でも容易に構築できる
- ✅　環境にトラブルが生じたらコンテナ消して立ち上げ直せば解決する
- ✅　チームで同じ開発環境を共有できる
- ✅　VMより圧倒的に軽く, ホストPCと異なるOSを扱える
- ✅　最小限のファイルしかないのでアプリ間の干渉が起きにくく, ストレスフリー♪

## 構築環境の概要
※ Dockerfile, docker-compose.yml で設定を編集可能.

- OS(Base Image): Ubuntu 20:04 
- installs: 
    - git 
    - vim
    - build-essential 
    - cmake 
    - libeigen3-dev 
    - libboost-dev 
    - gdb 
- Image Name : cpp-env
- Container Name : cppdev


## Dockerとは
- [Dockerの概要](https://docs.docker.jp/get-started/overview.html)

## Dockerのinstall
- [Docker Desktop for mac](https://docs.docker.jp/docker-for-mac/install.html)
- [Docker Desktop for windows](https://docs.docker.jp/docker-for-windows/install.html)
- 動作確認:(出力例)
    ```
    $ docker -v
    Docker version 19.03.12, build 48a66213fe
    $ docker-compose -v
    docker-compose version 1.27.2, build 18f557f9
    ```
## 使い方 (基本編)
### コマンドラインから実行
参考: 
- https://qiita.com/yuzutarogo/items/8898377739b5c674743f
- https://qiita.com/wasanx25/items/d47caf37b79e855af95f

1. PCローカルの適当な場所にこのリポジトリをclone

    ``` 
    $ cd (作業ディレクトリ)
    $ git clone https://github.com/MizuhoAOKI/docker_cpp_env.git 
    ```

2. イメージをbuild, コンテナを生成
    ```
    $ cd docker_cpp_env
    $ docker-compose up -d
    ```
    ※ -d: コンテナをバックグラウンドで実行するオプション

3. コンテナの開始
    ```
    $ docker start cppdev
    ```
    ※ cppdevはコンテナの名称

4. コンテナの実行
    ```
    $ docker exec -it cppdev bash
    root@[コンテナID]:/workspace#
    ```
    - root権限でコンテナに入れる. 
    - コンテナ内/workspaceで作業すれば, ローカルPC側の(作業ディレクトリ)/docker_cpp_env/workspaceとデータが自動で同期する.
    
5. ソースコードのClone, C++プログラムの実行
    ```
    root@[コンテナID]:/workspace# git clone (例)https://github.com/kohonda/multi-task-MPC.git
    root@[コンテナID]:/workspace# mkdir build
    root@[コンテナID]:/workspace# cd build
    root@[コンテナID]:/workspace/multi-task-MPC/build# cmake ..
    root@[コンテナID]:/workspace/multi-task-MPC/build# make
    root@[コンテナID]:/workspace/multi-task-MPC/build# ./mpc_cgmres
    
    ...C++プログラム実行...
    
    ```
6. コンテナから出る, コンテナの停止
    ```
    root@[コンテナID]:/workspace/# exit
    $ docker stop cppdev 
    ```
    また次回立ち上げる時にはstart, execが必要.

## 状態の確認
- イメージを確認
    ``` 
    $ docker images 
    REPOSITORY                       TAG                 IMAGE ID            CREATED             SIZE
    cpp-env                          latest              e421cc616236        22 seconds ago      648MB
    ubuntu                           20.04               9140108b62dc        2 weeks ago         72.9MB
    ```
- コンテナを確認
    ``` 
    $ docker ps -a 
    CONTAINER ID        IMAGE                            COMMAND                  CREATED              STATUS                  PORTS               NAMES
    45e6085e0d4f        cpp-env                           "/bin/bash"             About a minute ago   Up About a minute                           cppdev
    ```

## リポジトリ構成
```
docker_cpp_dev
├── .git
├── .gitignore
├── Dockerfile
├── docker-compose.yml
└── workspace
```
- 作業ディレクトリ: workspace/
- 設定の変更にはDockerfile, docker-compose.ymlを編集する.

## 構築した環境のクリーニング
以下コマンドでコンテナを停止し, docker-compose upで作られたイメージ, コンテナ, ボリューム, ネットワークを全て消去する.
なお, コンテナ内と同期するPCのローカルデータ(永続ボリューム)は削除されない.

```
$ docker-compose down --rmi all --volumes --remove-orphans
```

## 使い方 (応用編)
### コンテナ上で, Visual Studio Codeを用いたC++デバッグを行う方法
参考:
- https://qiita.com/dbgso/items/6e2f317d6d13bdc387f8

1. VScodeの拡張機能をinstall
    - Remote-Containers
        - 上位互換のRemote Developmentを入れても良い.

2. docker-compose.ymlを含む階層のフォルダをVScodeから開く.
    ```
    $ cd docker_cpp_env
    $ mkdir workspace
    $ code .
    ```
    - codeコマンドのパスが通っていない時 
    -> https://qiita.com/naru0504/items/c2ed8869ffbf7682cf5c

3. 画面左下緑色のボタン(><)を押して, Reopen in Containerを選択
    - VSCodeでDebugを行うには, 必ず初めのbuildをVSCodeから行うことがポイント. 先にbash等でbuildしてしまうとうまくいかない.

4. もし設定ファイルを聞かれたらdocker-compose.ymlを選ぶ

5. コンテナ内でVScodeの拡張機能をinstall(自動)
    ※ .devcontainer/devcontainer.jsonのextentionに記述してあるので, VSCodeからコンテナ立ち上げると同時に自動でinstallされる.コンテナごとに入れる必要があるので注意.
    - C/C++
    - CMake
    - CMake Tools

6. 画面左下の(><)ボタンを押す -> Remote-Containers: Open Folder in Container -> workspace(作業フォルダ) を選んで開く

8. C++のソースコードをclone
    ``` 
    $ git clone (例)https://github.com/kohonda/multi-task-MPC.git
    ```

8. CMakeのプロジェクトとして認識させる
    リポジトリ直下にCMakeLists.txtがある場合, 
    ```
    $ cd multi-task-MPC
    $ mkdir build
    $ cd build
    $ cmake ..
    ```
    - この操作はコンテナを立ち上げた直後のみ行えば良い. 
    -> VSCodeのCMakeツールにbuildディレクトリの場所を覚えさせるのが目的.(指定しないとworkspace/直下にbuild/を作ってしまう.)
    - build/の場所が思い通りにならない場合: 
    -> workspace/.vscode/settings.jsonの内容を次のように記述して強制的に指定可能.
    ```
    {
    "cmake.sourceDirectory": "${workspaceFolder}/multi-task-MPC",
    "cmake.buildDirectory": "${workspaceFolder}/multi-task-MPC/build"
    }
    ```
<!--     - Shift + Command + P -> CMake Configuration を選択.
    - Locate で CMakeLists.txtを選択
    -> このとき, workspace/.vscode/settings.jsonが自動生成され, cmakeのソースが存在するフォルダ位置が記録される. -->

9. デバッグを実行
    公式の説明: 
    - https://vector-of-bool.github.io/docs/vscode-cmake-tools/debugging.html#quick-debugging
    - https://github.com/microsoft/vscode-cmake-tools/blob/develop/docs/debug-launch.md
    
    #### CMakeを用いたDebug
    - Shift + Command + P -> CMake: Select Variant -> Debugを選択
        - Debug, Release, MinSizeRel, RelWithDevInfoなど, コンパイルの指定は実行ファイルの用途に応じて使い分ける.
    <!--         - この場合, workspace/直下にbuildフォルダが作られることに注意. -->
    - 適当な実行ファイル内にBreakPointを設置.
    - Ctrl + F5 or VScode画面下バーの虫マークをClick!
    - launch.jsonで詳細設定ができるが, ファイルが存在しなくても動く.

10. デバッグ成功！
    - BreakPointにおける各種変数の値などが見られて便利！

<!--
### debugカスタマイズ用のフォルダ
- かなりいろいろな情報を参考にしつつそれなりに動くものを作ったが, むしろ作らずデフォルトで動かした方がよほど安定することに気づいた...
念のために残しておくが使い道は皆無.

- workspace/.vscode/settings.json
    ``` 
    {
        // 適切なリポジトリの名前に変更
        "cmake.sourceDirectory": "${workspaceFolder}/aoki_cgmres_cpp",
        "cmake.buildDirectory": "${workspaceFolder}/aoki_cgmres_cpp/build",

        "C_Cpp.default.configurationProvider": "ms-vscode.cmake-tools",
        "cmake.debugConfig": {
                "stopAtEntry": true,
            "MIMode": "gdb",
            "miDebuggerPath": "/usr/bin/gdb"
        }
    }
    ```                                

- workspace/.vscode/launch.json
    ``` 
    // launch.jsonでカスタマイズも可能. しかし, 単にデバッグを実行するだけなら必要ない.
    // [公式説明] https://vector-of-bool.github.io/docs/vscode-cmake-tools/debugging.html#quick-debugging
    // 使おうとしても, なぜか "miDebuggerPath": "usr/bin/gdb" についてのエラーが取れない.
    // 参考:
    // https://github.com/microsoft/vscode-cpptools/issues/4607
    // https://code.visualstudio.com/docs/cpp/pipe-transport#_docker-example

    {
        "version": "0.2.0",
        "configurations": [

            {
                "name": "(gdb) Launch",
                "type": "cppdbg",
                "request": "launch",
                // Resolved by CMake Tools:
                "program": "${command:cmake.launchTargetPath}",
                "args": [],
                "stopAtEntry": true, // falseから変更
                "cwd": "${workspaceFolder}",
                "environment": [
                    {
                        // add the directory where our target was built to the PATHs
                        // it gets resolved by CMake Tools:
                        "name": "PATH",
                        "value": "$PATH:${command:cmake.launchTargetDirectory}",
                    }
                ],
                "externalConsole": true,
                "MIMode": "gdb",
                "miDebuggerPath": "/usr/bin/gdb",
                "setupCommands": [
                    {
                        "description": "Enable pretty-printing for gdb",
                        "text": "-enable-pretty-printing",
                        "ignoreFailures": true
                    }
                ],
            }
        ]
    }

    ```
-->

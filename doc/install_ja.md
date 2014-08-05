# SHIRASAGI インストールマニュアル

※この文書のターゲットOSはCentOS 6.5/64bitです。

## 必要なPackagesのインストール (ImageMagick)

```
$ su -
$ yum -y install ImageMagick ImageMagick-devel
```

## MongoDBのインストール

```
$ vi /etc/yum.repos.d/CentOS-Base.repo

    ------ (以下を追加)
    [10gen]
    name=10gen Repository
    baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
    gpgcheck=0
    enabled=0
    ------

$ yum -y --enablerepo=10gen install mongo-10gen mongo-10gen-server
$ /sbin/service mongod start
$ /sbin/chkconfig mongod on
```

## Ruby (RVM)のインストール

```
$ curl -sSL https://get.rvm.io | sudo bash -s stable
$ source /etc/profile
$ rvm install 2.1.2
```

## SHIRASAGI本体のインストール

```
$ git clone -b stable --depth 1 https://github.com/shirasagi/shirasagi /var/www/shirasagi
$ cd /var/www/shirasagi
$ cp config/samples/* config/
$ bundle install
$ thin start -d
```

Access to http://localhost:3000/.mypage


## ふりがな機能のインストール

```
$ cd /usr/local/src
$ wget http://mecab.googlecode.com/files/mecab-0.996.tar.gz \
       http://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz \
       http://mecab.googlecode.com/files/mecab-ruby-0.996.tar.gz

$ cd /usr/local/src
$ tar xvzf mecab-0.996.tar.gz && cd mecab-0.996
$ ./configure --enable-utf8-only && make && make install

$ cd /usr/local/src
$ tar xvzf mecab-ipadic-2.7.0-20070801.tar.gz && cd mecab-ipadic-2.7.0-20070801
$ ./configure --with-charset=utf8 && make && make install

$ cd /usr/local/src
$ tar xvzf mecab-ruby-0.996.tar.gz && cd mecab-ruby-0.996
$ ruby extconf.rb && make && make install

$ echo "/usr/local/lib" >> /etc/ld.so.conf
$ ldconfig
```

## データベース操作

```
$ cd /var/www/shirasagi

# インデックスの作成
$ rake db:create_indexes

# 管理者ユーザーの作成
$ rake ss:user:create data='{ name: "Administrator", email: "sys@example.jp", password: "pass" }'

# サイトの作成
$ rake ss:site:create data='{ name: "Sample Site", host: "www", domains: "localhost:3000" }'
```

## サンプルデータ

```
# ユーザー、グループデータの登録
$ rake db:seed name=users site=www

# サイトデータの登録
$ rake db:seed name=demo site=www
```

## CMS管理

```
# 予約公開/非公開
$ rake cms:page:release

# 静的ページ書き出し
$ rake cms:page:generate site=www

# 静的ページ削除
$ rake cms:page:remove site=www
```

## 開発ツール

```
# Eggインストール
$ bin/egg install sample-egg -v 1.0.0

# Eggアンインストール
$ bin/egg uninstall sample-egg

# Egg作成
$ bin/egg pack sample-egg -v 1.0.0
```

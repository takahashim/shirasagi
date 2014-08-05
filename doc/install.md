# How to Install and Use

The target OS of this document is CentOS 6.5/64bit.

## Install Packages (ImageMagick)

```
$ su -
$ yum -y install ImageMagick ImageMagick-devel
```

## Install MongoDB

```
$ vi /etc/yum.repos.d/CentOS-Base.repo

    ------ (you add this part)
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

## Install Ruby (RVM)

```
$ curl -sSL https://get.rvm.io | sudo bash -s stable
$ source /etc/profile
$ rvm install 2.1.2
```

## Install SHIRASAGI

```
$ git clone -b stable --depth 1 https://github.com/shirasagi/shirasagi /var/www/shirasagi
$ cd /var/www/shirasagi
$ cp config/samples/* config/
$ bundle install
$ thin start -d
```

Access to http://localhost:3000/.mypage


## Install Furigana function

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

## setup DB

```
$ cd /var/www/shirasagi

# crate indexes
$ rake db:create_indexes

# create admin
$ rake ss:user:create data='{ name: "Administrator", email: "sys@example.jp", password: "pass" }'

# create site
$ rake ss:site:create data='{ name: "Sample Site", host: "www", domains: "localhost:3000" }'
```

## sample data

```
# add users and groups data
$ rake db:seed name=users site=www

# add site data
$ rake db:seed name=demo site=www
```

## CMS Management

```
# reservation open/close
$ rake cms:page:release

# generate static pages
$ rake cms:page:generate site=www

# remove static pages
$ rake cms:page:remove site=www
```

## Development Tools

```
# Install Egg
$ bin/egg install sample-egg -v 1.0.0

# Uninstall Egg
$ bin/egg uninstall sample-egg

# package Egg
$ bin/egg pack sample-egg -v 1.0.0
```

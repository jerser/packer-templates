#!/bin/bash

cat <<EOF | mysql -u root
create database typo3;
grant usage on *.* to typo3@localhost identified by 'typo3';
grant all privileges on typo3.* to typo3@localhost;
flush privileges;
EOF

curl -L http://get.typo3.org/introduction -o typo3_introduction.tar.gz
rm -rf /var/www/html
mkdir /var/www/typo3
tar zxf typo3_introduction.tar.gz -C /var/www/typo3
rm -f typo3_introduction.tar.gz
ln -s /var/www/typo3/`ls -tr /var/www/typo3 | tail -1` /var/www/html
chown -R apache.apache /var/www

cat >> /etc/httpd/conf/httpd.conf <<EOF

<Directory "/var/www/html">
  AllowOverride All
</Directory>

EOF

yum -y install fontconfig freetype bzip2
curl -L https://phantomjs.googlecode.com/files/phantomjs-1.9.1-linux-i686.tar.bz2 -o phantomjs.tar.bz2
mkdir phantomjs && tar xjf phantomjs.tar.bz2 --strip 1 -C phantomjs
rm -f phantomjs.tar.bz2
ln -sf `pwd`/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
curl -L https://github.com/n1k0/casperjs/tarball/1.0.2 -o casperjs.tar.gz
mkdir casperjs && tar xzf casperjs.tar.gz --strip 1 -C casperjs
rm -f casperjs.tar.gz
ln -sf `pwd`/casperjs/bin/casperjs /usr/local/bin/casperjs

cat > /tmp/123.js <<EOF
var casper = require('casper').create();

casper.start(
  'http://localhost/typo3/install/index.php?mode=123&step=1&password=joh316',
  function(){
    this.click('button[type="submit"]');
  }
);

casper.then(function(){
  this.fill('form', {
    "TYPO3_INSTALL[Database][typo_db_username]": "typo3",
    "TYPO3_INSTALL[Database][typo_db_password]": "typo3",
    "TYPO3_INSTALL[Database][typo_db_host]": "localhost"
  }, true);
});

casper.then(function(){
  this.click('#t3-install-form-db-select-existing');
  this.fill('form', {
    "TYPO3_INSTALL[Database][typo_db]": "typo3"
  }, true);
});

casper.then(function(){
  this.click('#systemToInstallIntroduction');
  this.click('button[type="submit"]');
});

casper.then(function(){
  this.fill('form', { "password": "joh316" }, true);
});

casper.then(function() {
  this.evaluateOrDie(function() {
    return (/Congratulations/).test(document.body.innerText);
  }, 'ERROR: Automatic setup failed!');
});

casper.run(function() {
  this.echo('SUCCESS: Automatic setup succeeded!').exit(0);
});
EOF

casperjs /tmp/123.js
rm /tmp/123.js

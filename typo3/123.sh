#!/bin/bash

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

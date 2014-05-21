ACM Ladder
==========

A level-based [ACM-ICPC][] training site inspired by the idea of [USACO
Training Program][usaco] and developed using [rails][] and
[twitter bootstrap][bootstrap].
[ACM-ICPC]: http://icpc.baylor.edu/
[usaco]: http://ace.delos.com/usacogate
[rails]: http://rubyonrails.org/
[bootstrap]: http://twitter.github.com/bootstrap/

Demo
----
[Nankai ACM Training Program](http://acm.nankai.edu.cn/ladder)

Getting Started[Rough Version]
---------------

### Clone the Project

    git clone git://github.com/leewings/ACM-Ladder.git

### Install Required Gems

    bundle install

### Change Secret Token

1. Get an unique secret token.

        rake secret

2. Modify `config/initializers/secret_token.rb.example` to set the token and
   save it to `config/initializers/secret_token.rb`.

### Configure

- `config/database.yml.example`

  Modify this example file according to your database configuration and save
  it to `config/database.yml`.

- `config/application.yml.example`

  Customize this example file according to your need and save it to
  `config/application.yml`.

### Setup Database

    rake db:setup

### Create `tmp` Directories

    rake tmp:create

### Start `delayed_job` Daemon

    script/delayed_job start

### Enjoy!

License
-------
ACM Ladder is released under the [MIT License][].
[MIT License]: http://opensource.org/licenses/MIT

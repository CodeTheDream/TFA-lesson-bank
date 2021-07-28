## UML Diagram of Database

- [Diagram](https://lucid.app/lucidchart/invitations/accept/inv_e7689d43-900f-4b9c-a535-3c7b44338c3c?viewport_loc=163%2C341%2C1696%2C881%2C0_0)

## Setting up for the tfa_lesson_bank application.

We will assume that everyone is running either mac or linux ubuntu. Windows users will run linux ubuntu under vagrant as for the class.

We will use Rails 6.x. For this version of Rails, you must install a current version of node.js, and you must also install yarn. We will also have to install the database postgresql, which will be our production database.
Ubuntu setup (including for Ubuntu under vagrant)

```bash
sudo apt-get update
sudo apt-get install npm
sudo npm install npm@latest -g
sudo npm cache-clean -f
sudo npm install -g n
sudo n stable
```

At this point, you will have installed the latest stable version of node.js. You should exit your command window and start a new one to get the right path statement. Then, to install yarn, you do the following:

```bash
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt install yarn
```

Note for vagrant users: In the slack channel, some additional instructions were provided so that yarn would work correctly in vagrant environments. First, edit your Vagrantfile in rails-ctd. Add the following lines just before the final end statement:

config.vm.provider "virtualbox" do |v|
v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
end

Once you have done so, you must exit your vagrant ssh and do vagrant halt. Then you must start a new git bash window running as administrator, and do vagrant up and vagrant ssh as before. You will have to do this each time you start vagrant, so that vagrant up is run as windows administrator, for yarn to work correctly because of yarn use of symlinks.

## Install and configure postgresql:

```bash
sudo apt-get install postgresql
sudo apt-get install postgresql-contrib
sudo apt-get install libpq-dev
/usr/lib/postgresql/10/bin/initdb -E UTF8 ~/postgres
```

Then do a whoami to know your current linux operating system ID. If you are running vagrant, it will be vagrant. Then do:

```bash
sudo -u postgres createuser your-linux-userid -s
sudo service postgresql start
```

You may need to open your pg_hba.conf file (often this is located at ~/../../etc/postgresql/11/main/pg_hba.conf) and change all **md5** and **peer** values to **trust**

## Installing and setting up the app

Clone this repository.

Back to the comand line:

```bash
cd tfa_lesson_bank
psql -U your-linux-userid postgres
create role tfa_lesson_bank with createdb login;
\q
rake db:create:all
rails db:migrate
rails db:migrate RAILS_ENV=test
```

**Note:** On Line 3, make sure to add `;` at the end of command. Confirmation message should look like `CREATED ROLE`

We use [searchkick](https://github.com/ankane/searchkick) to enable searching in ElasticSearch.

There are 2 methods to get ElasticSearch running. The first is to just install ElasticSearch and the second is to install Docker.

Installing ElasticSearch: [elasticsearch](https://www.thegeekstuff.com/2019/04/install-elasticsearch)

Installing Docker: [docker](https://www.tutorialspoint.com/docker/installing_docker_on_linux.html)

Next you need to start [elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/starting-elasticsearch.html)

```
./bin/elasticsearch
```

Once ElasticSearch is running Searchkick should be able to find it using the default port 9200
All the data we want to search through must be indexed to ElasticSearch

Log into the rails console

```
rails c
```

Index the Courses

```
Course.reindex
```

Quit the console

```
quit
```

## At this point you should be able to test the app.

The command 'rspec' should run the test suite with no errors or failures.  
You should be able to run the console with no errors.  
You should be able to run the server with no errors.  
Go to the browser and type http://localhost:3000/. Make a new account (sign up) and a confirmation message will be sent to your email. Click the confirmation link and login. (In development you must go into the rails console and run `u = User.last` then `u.confirm`)
You should be redirected to the landing page.  
**Note:** Staff accounts will need be created from `rails console` with a role of `admin`.

# MacOS setup:

## Clone app

Clone it

## Set up postgres

## How to Install [PostgreSQL](https://www.postgresql.org/)

### 0. Uninstall

If you've tried to install postgres before but failed, [remove postgres](https://stackoverflow.com/questions/8037729/completely-uninstall-postgresql-9-0-4-from-mac-osx-lion/9240197#9240197) first.

For Mac, to download postgres follow [this post](https://www.codementor.io/engineerapart/getting-started-with-postgresql-on-mac-osx-are8jcopb) or watch [this video](https://youtu.be/pf5jPUJAeU4) or read below.

### 1. Install PostgreSQL

Command Line

```bash
brew install yarn
brew install postgres
```

Once done, you can see post-install info whenever with

```
brew info postgres
```

### 2. Initialize Database Cluster

If you see this snippet from installation, skip this step.

```bash
...
Pouring postgresql-11.5_1.mojave.bottle.tar.gz
==> /usr/local/Cellar/postgresql/11.5_1/bin/initdb --locale=C -E UTF-8 /usr/local/var/postgres
...
```

If you don't see that snippet, initiate postgres database clusters with

```bash
initdb /usr/local/var/postgres
```

### 3. Start Postgres Server

To have launchd start postgresql now and restart at login:

```bash
pg_ctl -D /usr/local/var/postgres -l logfile start
brew services start postgresql
# OR
brew services restart postgresql
```

You may need to open your pg_hba.conf file (often this is located at ~/../../etc/postgresql/11/main/pg_hba.conf) and change all md5 values to trust

### 4. Create User

We create a user (aka role) with

```
createuser tfa_lesson_bank
```

### 5. Create Database

Create development and test databases

```bash
createdb -O[owner] -E[encoding] [database name]
createdb -Otfa_lesson_bank -Eutf8 tfa_lesson_bank_production
createdb -Otfa_lesson_bank -Eutf8 tfa_lesson_bank_development
createdb -Otfa_lesson_bank -Eutf8 tfa_lesson_bank_test
```

`-O` stands for **O**wner. Provide the user we just created.

`-E` stands for **E**ncoding. Use UTF-8.
Can also run if you already have rails setup

```
rails db:create
```

## How to Setup Rails

### 1. Install Bundler

Bundler is a gem for installing other gems lol

```
gem install bundler
```

### 2. Install other gems

Either command does the same thing

```
bundle
bundle install
```

### 3. Install Rails

Either download the latest or a certain version of Rails

```
gem install rails

```

## 4. Restart Terminal

This allows the Rails command to become available to use in the terminal

### 5. Create & Migrate Database

```
rails db:create
```

Now that we have the proper database created. Let's make some tables and rows.

```
rails db:migrate
rails db:migrate RAILS_ENV=test
```

`-E` stands for **E**ncoding. Use UTF-8.
Can also run if you already have rails setup

### 6. ElasticSearch

We use [searchkick](https://github.com/ankane/searchkick) to enable searching in ElasticSearch.

There are 2 methods to get ElasticSearch running. The first is to just install ElasticSearch and the second is to install Docker.

Installing ElasticSearch: [elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/brew.html)

Installing Docker: [docker](https://docs.docker.com/docker-for-mac/apple-m1/)

Next you need to start [elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/starting-elasticsearch.html)

```
brew services start elasticsearch
```

or

```
docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.11.2
```

Once ElasticSearch is running Searchkick should be able to find it using the default port 9200
All the data we want to search through must be indexed to ElasticSearch

Log into the rails console

```
rails c
```

Index the Courses

```
Course.reindex
```

Quit the console

```
quit
```

## At this point you should be able to test the app.

Before your run the command 'rspec' you must make sure that Elastic Search is running locally.

You can run this command to check if Elastic Search is running in your command line

```
curl localhost:9200
```

If Elastic Search is not running you can follow these steps:

```
brew services start elasticsearch
```

or

```
brew services restart elasticsearch
```

Once ElasticSearch is running Searchkick should be able to find it using the default port 9200
All the data we want to search through must be indexed to ElasticSearch

Log into the rails console

```
rails c
```

Index the Courses

```
Course.reindex
```

If you run everything without errors the command 'rspec' should run the test suite with no errors or failures.
You should be able to run the console with no errors.

You should be able to run the server with no errors.Go to the browser and type http://localhost:3000/. Make a new account (sign up) and a confirmation message will be sent to your email. Click the confirmation link and login. (In development you must go into the rails console and run `u = User.last` then `u.confirm`)
You should be redirected to the landing page.  
**Note:** Staff accounts will need be created from `rails console` with a role of `admin`.

# pressfrwrd.com


## Getting started

You need postgre sql, on mac you can install it like:

    $ brew install postgresql
    $ pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

### run tests

    $ cp config/database.yml.example config/database.yml
    $ bundle install
    $ bundle exec rake db:migrate
    $ bundle exec rake db:test:prepare
    $ bundle exec rake spec
    $ bundle exec rake cucmber


## Deployment on heroku:

### master/production branch:

Normally we develop on feature branch, we ask pull request to merge to master.
We deploy from master to staging, once good we merge from staging to production branch and we deploy from production branch to production.

Then we push to staging to staging repo's master with:

    $ git remote add staging git@heroku.com:pressfrwrd-staging.git
    $ git push staging master:master
    
Once staging is ok, we use github to merge staging to production then. We push to production with:

    $ git remote add production git@heroku.com:pressfrwrd.git
    $ git push production production:master

#### Create staging and prod instances

    $ heroku create pressfrwrd-staging --remote staging
    $ heroku create pressfrwrd --remote production
    $ git push staging master
    $ git push production master

#### Set environments:

    $ heroku config:set AWS_ACCESS_KEY_ID= --app pressfrwrd-staging
    $ heroku config:set AWS_SECRET_ACCESS_KEY= --app pressfrwrd-staging
    $ heroku config:set AWS_ACCESS_KEY_ID= --app pressfrwrd
    $ heroku config:set AWS_SECRET_ACCESS_KEY= --app pressfrwrd
    $ heroku config:set S3_BUCKET=pressfrwrd_staging_img --app pressfrwrd-staging
    $ heroku config:set S3_BUCKET=pressfrwrd_img --app pressfrwrd

#### Run migrations:

    $ heroku rake db:migrate --app pressrfwrd-staging

#### Administration

To make an user admin you have to do this:

    $ User.find_by(email:'mfazekas@szemafor.com').update(admin:true)



# pressfrwrd.com

Deployment on heroku:

0. Development/master branch:

Normally we develop on development branch, then we push to staging with:
    $ git remote add staging git@heroku.com:pressfrwrd-staging.git
    $ git push staging development:master
    
Once staging is ok, we use github to merge staging to master then. We push to production with:
    $ git remote add production git@heroku.com:pressfrwrd.git
    $ git push production master

1. Create staging and prod instances

    $ heroku create pressfwrd-staging --remote staging
    $ heroku create pressfwrd --remote production
    $ git push staging master
    $ git push production master

2. Set environments:

3. Run migrations:
    $ heroku rake db:migrate --app pressfwrd-staging
    

To run tests:

    $ cp config/database.yml.example config/database.yml
    $ bundle install
    $ bundle exec rake db:migrate
    $ bundle exec rake db:test:prepare
    $ bundle exec rspec spec/


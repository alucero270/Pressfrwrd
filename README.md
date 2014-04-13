# pressfrwrd.com

Deployment on heroku:

1. Create staging and prod instances

    $ heroku create pressfwrdfm-staging --remote staging
    $ heroku create pressfwrdfm --remote production
    $ git push staging master
    $ git push production master

2. Set environments:

    

To run tests:

    $ cp config/database.yml.example config/database.yml
    $ bundle install
    $ bundle exec rake db:migrate
    $ bundle exec rake db:test:prepare
    $ bundle exec rspec spec/


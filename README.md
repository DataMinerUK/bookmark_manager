# Bookmark Manager

This is a web app using [Sinatra](http://www.sinatrarb.com/). There is a [Postgresql](http://www.postgresql.org/) database implementation using [DataMapper](http://datamapper.org/). Units tests use [Rspec](http://rspec.info/). Features tests use [Capybara](http://jnicklas.github.io/capybara/). Mailer uses [Mailgun](https://mailgun.com). This was built following this [MakersAcademy Tutorial](https://github.com/makersacademy/course/tree/master/bookmark_manager)

## Getting Started

Sign up for a Mailgun account [here](https://mailgun.com) and get your API key. I work off a vagrant VM whose Vagrantfile you can find [here](https://github.com/DataMinerUK/MakersAcademy-VM). So when running this from the VM:

On the command line
```bash
vagrant up # This may take a while
vagrant ssh
cd /vagrant
cd [where_ever_happens_to_be]/bookmark_manager
export mailgun_api=[API_key]
bundle install
sudo -i -u postgres
createdb bookmark_manager_test
createdb bookmark_manager_development
exit
```
To check run the version locally
```bash
rackup -p4567 --host 0.0.0.0
```
and go to localhost:4567 on your machine.

### To deploy to Heroku

```bash
heroku login # Give email and password
heroku create
heroku addons:create heroku-postgresql:hobby-dev
heroku config:set mailgun_api=[API_key]
git push heroku master
heroku open
```

## Hard Lessons Learnt

* When deploying to Heroku the test group gems in the [Gemfile](https://github.com/DataMinerUK/bookmark_manager/blob/master/Gemfile) are not installed
* Pay special attention to  [data_mapper_setup.rb](https://github.com/DataMinerUK/bookmark_manager/blob/master/app/data_mapper_setup.rb) as DataMapper can be a pain to setup properly
* When using Postgres on Heroku you need
```ruby
env = ENV['RACK_ENV'] || 'development'
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/bookmark_manager_#{env}")
```
* Watch out when you validate confirmation of a table column in DataMapper. You have to validate every time you change the database, even if you are just updating an existing record. See the [User model](https://github.com/DataMinerUK/bookmark_manager/blob/master/app/models/user.rb#L21)
* Bcrypt has a weird [syntax](https://github.com/DataMinerUK/bookmark_manager/blob/master/app/models/user.rb#L28) for checking user password input to password digests in the database
* When using sinatra-flash don't forget to `register Sinatra::Flash` in your app
* Information security in software is of the utmost importance. Read about salted password hashing [here](https://crackstation.net/hashing-security.htm)
* Instead of changing constants in a class, use class variables. See [send_reset_email.rb](https://github.com/DataMinerUK/bookmark_manager/blob/master/lib/send_reset_email.rb#L5-L12)


# women-who-borrow

A web application built in Ruby on Rails which allows people to borrow books from each other.

The latest master branch will always be auto deployed here: https://book-swap-wwc.herokuapp.com

Rails version: 5.1.6

## Prerequisites:

- Ruby 2.5.1 or higher
- Postgres database

## Setting up the project

- clone the Github repository
- run `bundle install` to install all the necessary gems
- start your Postgres server with `pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`
- create & migrate the database by running `rails db:create db:migrate`
- run the Rails server `rails s`
- go to `localhost:3000` in your browser of choice and see the application working! :)
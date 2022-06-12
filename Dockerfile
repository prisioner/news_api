FROM ruby:3.0.4

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /app

COPY . .
RUN bundle install

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 3000

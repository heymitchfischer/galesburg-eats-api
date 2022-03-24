# syntax=docker/dockerfile:1
FROM ruby:3.0.3
RUN apt-get update -qq && apt-get install -y \
    postgresql-client

WORKDIR /galesburg_eats_api
COPY Gemfile /galesburg_eats_api/Gemfile
COPY Gemfile.lock /galesburg_eats_api/Gemfile.lock
RUN gem install bundler
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
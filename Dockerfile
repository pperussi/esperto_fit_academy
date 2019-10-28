FROM ruby:2.6.4
RUN apt-get update -qq && apt-get install -y postgresql-client 
RUN mkdir /espertofit_academy
WORKDIR /espertofit_academy
COPY Gemfile /espertofit_academy/Gemfile
COPY Gemfile.lock /espertofit_academy/Gemfile.lock
RUN bundle install
RUN rails db:setup
COPY . /espertofit_academy

# Add a script to be executed every time the container starts.
EXPOSE 4000

# Start the main process.

CMD ["rails", "server", "-b", "0.0.0.0"]

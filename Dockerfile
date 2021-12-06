FROM ruby:2.7.0
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /TFA-lesson-bank
COPY Gemfile /TFA-lesson-bank/Gemfile
COPY Gemfile.lock /TFA-lesson-bank/Gemfile.lock
RUN bundle install

ENV RAILS_ENV production

COPY . /TFA-lesson-bank
#RUN RAILS_ENV=production rails assets:precompile

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 8080 

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8080"]

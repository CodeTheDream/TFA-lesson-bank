FROM ruby:2.7.0
RUN echo $MASTER_KEY
RUN apt-get update -qq && apt-get install -y nodejs npm postgresql-client
RUN npm install -g yarn
WORKDIR /TFA-lesson-bank
COPY Gemfile /TFA-lesson-bank/Gemfile
COPY Gemfile.lock /TFA-lesson-bank/Gemfile.lock
RUN bundle install

ENV RAILS_ENV production

COPY . /TFA-lesson-bank
#RUN rails webpacker:compile
RUN rails assets:precompile

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 8080 

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8080"]

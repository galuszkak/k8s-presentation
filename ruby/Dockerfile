FROM ruby:2.5.1

LABEL author="Kamil Gałuszka <kamil@flyrlabs.com>"

RUN mkdir /app

COPY app.rb config.ru Gemfile Gemfile.lock /app/

WORKDIR /app

RUN bundle install

EXPOSE 80

CMD ["rackup", "-p", "80", "-o", "0.0.0.0"]
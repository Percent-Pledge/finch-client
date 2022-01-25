FROM ruby:2.7.5-buster

# ENV vars
ENV BUNDLER_VERSION=2.2.26

# Bundler likes having an ENV var set so I've set it up to also specify the version for the docker image
RUN gem install bundler -v ${BUNDLER_VERSION}

WORKDIR /app

COPY . ./

RUN bin/setup

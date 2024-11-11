FROM ruby:3.3-bullseye

# ENV vars
ENV BUNDLER_VERSION=2.5.23

# Bundler likes having an ENV var set so I've set it up to also specify the version for the docker image
RUN gem install bundler -v ${BUNDLER_VERSION}

WORKDIR /app

COPY . ./

RUN bin/setup

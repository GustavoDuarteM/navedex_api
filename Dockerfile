# A simple Dockerfile for a RoR application

FROM ruby:3.0.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /navedex_api

WORKDIR /navedex_api

ADD Gemfile /navedex_api/Gemfile
ADD Gemfile.lock /navedex_api/Gemfile.lock

RUN bundle install
ADD . /navedex_api
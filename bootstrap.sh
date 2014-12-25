#!/bin/sh

cd $(dirname $0)

#git submodule update --init --recursive

mkdir -p OJM

ruby ObjectJsonMapperGenerator/bin/make_ojm.rb -c example/data_service.yml -l swift -t ds -d OJM/


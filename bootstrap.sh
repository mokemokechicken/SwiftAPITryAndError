#!/bin/sh

cd $(dirname $0)

#git submodule update --init --recursive

mkdir -p OJM

ruby ObjectJsonMapperGenerator/bin/make_ojm.rb -c example/api.yml -l swift -t api -o OJM/api.swift


#!/bin/sh

cd $(dirname $0)

git submodule update --init --recursive

mkdir -p OJM

ruby ObjectJsonMapperGenerator/bin/make_ojm.rb -c example/qiita.yml -l swift -o OJM/ojm.swift


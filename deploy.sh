#!/usr/bin/env bash

ssh cloudview.joyent.us 'cd ~/domains/rvdh.de/web && git checkout . && git clean -f . && git pull && ./asset_versioning.rb'

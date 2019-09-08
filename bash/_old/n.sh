#!/bin/bash

export N_PREFIX=$HOME/.local
export N_CURRENT=$N_PREFIX/n/current
pathshift $N_CURRENT/bin
pathshift $HOME/node_modules/.bin
pathshift ./node_modules/.bin

# export NODE_PATH=$N_CURRENT/lib/node_modules

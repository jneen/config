#!/bin/bash

is-local || return 0

play() { ffplay -nodisp "$@" ;}

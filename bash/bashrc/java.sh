#!/bin/bash

is-mac && {
  export JAVA_HOME="$(/usr/libexec/java_home -v15)"
}

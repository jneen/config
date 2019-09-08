#!/bin/bash
exists ry && {
  export ry_prefix="$home/.local"
  eval "$(ry setup)"
}

exists noexec && export ruby_opt="-r $(noexec)"

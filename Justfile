#!/usr/bin/env just -f

build:
    nix build .#

format:
    just _format "*.nix" nixfmt
    just _format "*.yaml" yamlfmt
    just --unstable --fmt

_format glob +args:
    git ls-files '{{ glob }}' | xargs {{ args }}

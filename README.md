# Vaulty
[![Gem Version](https://badge.fury.io/rb/vaulty.svg)](https://badge.fury.io/rb/vaulty)
[![Build Status](https://travis-ci.org/playpasshq/vaulty.svg?branch=master)](https://travis-ci.org/playpasshq/vaulty)
[![Test Coverage](https://codeclimate.com/github/playpasshq/vaulty/badges/coverage.svg)](https://codeclimate.com/github/playpasshq/vaulty/coverage)
[![Code Climate](https://codeclimate.com/github/playpasshq/vaulty/badges/gpa.svg)](https://codeclimate.com/github/playpasshq/vaulty)
[![Issue Count](https://codeclimate.com/github/playpasshq/vaulty/badges/issue_count.svg)](https://codeclimate.com/github/playpasshq/vaulty)
[![Inline docs](http://inch-ci.org/github/playpasshq/vaulty.svg)](http://inch-ci.org/github/playpasshq/vaulty)
[![git.legal](https://git.legal/projects/3808/badge.svg?key=f71d4e011a263b65c8f7 "Number of libraries approved")](https://git.legal/projects/3808)

Vaulty is a CLI application that makes it easier to manage Vault.
Only tested on the generic backend!

## Project Status

```shell
NAME
    vaulty - Vault CLI on steriods

SYNOPSIS
    vaulty [global options] command [command options] [arguments...]

VERSION
    0.0.3

GLOBAL OPTIONS
    --help    - Show this message
    --version - Display the program version

COMMANDS
    add    - Add a new key/value to the given path, multiple "key:value" can be provided
    delete - Deletes everything under the path recursively
    help   - Shows a list of commands or help for one command
    remove - Removes a specific key under the path
    tree   - Represents the path as a tree
```

:include:vaulty.rdoc


ork-encryption
==============
[![Gem Version](https://badge.fury.io/rb/ork-encryption.png)](http://badge.fury.io/rb/rork-encryption)
[![Build Status](https://travis-ci.org/emancu/ork-encryption.png)](https://travis-ci.org/emancu/ork-encryption)
[![Code Climate](https://codeclimate.com/github/emancu/ork-encryption.png)](https://codeclimate.com/github/emancu/ork-encryption)
[![Coverage Status](https://coveralls.io/repos/emancu/ork-encryption/badge.png)](https://coveralls.io/r/emancu/ork-encryption)
[![Dependency Status](https://gemnasium.com/emancu/ork-encryption.png)](https://gemnasium.com/emancu/ork-encryption)

The ork-encryption gem provides encryption and decryption for Ork models.

## Dependencies

`ork-encryption` requires:

* Ruby 1.9 or later.
* `riak-client` to connect to **Riak**.
* `ork` 0.1.1 or later.

Install Dependencies using `dep` is easy as run:

    $ dep insatll

## Installation

Install [Riak](http://basho.com/riak/) with your package manager:

    $ brew install riak

Or download it from [Riak's download page](http://docs.basho.com/riak/latest/downloads/)

Once you have it installed, you can execute `riak start` and it will run on `localhost:8098` by default.

If you don't have `Ork-encryption`, try this:

    $ gem install ork-encryption

## Overview

Any object that gets saved with content-type 'application/x-json-encrypted'
the `Ork::Encryption::Serializers::Json` will take care of load or unload the data from **Riak**.

`Serializers::Json` stores the encrypted data wrapped in JSON encapsulation so
that you can still introspect the **Riak** object and see which version of
this gem was used to encrypt it.  As of version 0.0.1, this is now the only
supported serialization format for JSON data.

## Getting started

You must initialize the `Ork::Encryption` module before using it.
Initialization needs a _configuration hash_ with __key__ and __cipher__ to be used.
[See how to choose the configuration](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/openssl/rdoc/OpenSSL/Cipher.html#documentation)

```ruby
config = {
  cipher: 'AES-256-CBC',
  key:    'fantasticobscurekeygoesherenowty',
}

Ork::Encryption.init config
```

Then include the Ork::Encryption module in your Ork::Document class:

```ruby
class SomeDocument
  include Ork::Document
  include Ork::Encryption

  attribute :message
end
```

These documents will now be stored encrypted and also the **IV** used.

## Running the Tests

Adjust the variable to point to a test riak database. Default is `http://localhost:8098`

```bash
$ ORK_RIAK_URL='http://localhost:8198' rake
```


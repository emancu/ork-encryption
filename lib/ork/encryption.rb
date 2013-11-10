require_relative 'cipher'
require_relative 'errors'
require_relative 'serializers/json'

module Ork
  module Encryption
    VERSION = '0.0.1'

    def self.included(klass)
      raise NotAnOrkDocument unless klass.included_modules.include? Ork::Document
      klass.content_type Serializers::Json.content_type
    end


    # Initializes the module, setting a configuration and registering
    # the serializers into Riak API.
    #
    def self.init(config)
      Serializers::Json.register!

      encryption_config config
    end

    # Accessor for the general Encryptor config.
    #
    # config - When nil, it acts like a reader.
    #          When hash, it needs :key and :cipher
    #
    # Raises Ork::Encryption::MissingConfig when the config is incomplete.
    #
    def self.encryption_config(config = nil)
      return @encryption_config if config.nil?

      Ork::Encryption::Cipher.validate_config @encryption_config = config
    end

  end
end

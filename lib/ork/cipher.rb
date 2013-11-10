require 'openssl'

module Ork::Encryption

  # Implements a simple object that can either
  # encrypt or decrypt arbitrary data.
  #
  # Example:
  #   cipher = Ork::Encryption::Cipher.new config_hash
  #   cipher.encrypt stuff
  #   cipher.decrypt stuff
  #
  class Cipher

    # Creates a cipher that is prepared to encrypt/decrypt a blob.
    # @param [Hash] config the key/cipher/iv needed to initialize OpenSSL
    #
    def initialize(config = {})
      Cipher.validate_config @config = config
      @cipher = OpenSSL::Cipher.new @config[:cipher]
    end

    # Validates the configuration has all the required values to
    # encrypt and decrypt an object
    #
    # Note: if the configuration is invalid, an
    # `Ork::Encryption::MissingConfig` error is raised.
    #
    def self.validate_config(config)
      if config.nil? || ([:cipher, :key] - config.keys).any?
        raise MissingConfig,
          'Make sure to provide the full configuration to Ork::Encryption. ' +
          'Use Ork::Encryption.init(config_hash) to set the configuration ' +
          'or assert that Ork::Encryption::Cipher.new receives a non empty' +
          ' hash with :cipher and :key values.'
      end
    end

    def random_iv!
      self.iv = @cipher.random_iv
    end

    def iv=(iv)
      @config[:iv] = iv
    end

    # Encrypt stuff.
    # @param [Object] blob the data to encrypt
    def encrypt(blob)
      initialize_cipher_for :encrypt
      "#{@cipher.update blob}#{@cipher.final}"
    end

    # Decrypt stuff.
    # @param [Object] blob the encrypted data to decrypt
    def decrypt(blob)
      initialize_cipher_for :decrypt
      "#{@cipher.update blob}#{@cipher.final}"
    end

    private

    # This sets the mode so OpenSSL knows to encrypt or decrypt, etc.
    # @param [Symbol] mode either :encrypt or :decrypt
    def initialize_cipher_for(mode)
      @cipher.send mode
      @cipher.key = @config[:key]
      @cipher.iv  = @config[:iv]
    end

  end
end

module Ork::Encryption
  module Serializers

    # Implements the {Riak::Serializer} API for the purpose of
    # encrypting/decrypting Ork documents as JSON.
    #
    # @see Encryption
    class Json

      # The Content-Type of the internal format
      def self.content_type
        'application/x-json-encrypted'
      end

      # Register the serializer into Riak
      def self.register!
        Riak::Serializers[content_type] = self
      end

      # Serializes and encrypts the Ruby hash using the assigned
      # cipher and Content-Type.
      #
      # data - Hash representing persisted_data to serialize/encrypt.
      #
      def self.dump(data)
        json_attributes = data.to_json(Riak.json_options)

        encrypted_object = {
          iv:      Base64.encode64(cipher.random_iv!),
          data:    Base64.encode64(cipher.encrypt json_attributes),
          version: Ork::Encryption::VERSION
        }

        encrypted_object.to_json(Riak.json_options)
      end

      # Decrypts and deserializes the blob using the assigned cipher
      # and Content-Type.
      #
      # blob - String of the original content from Riak
      #
      def self.load(blob)
        encrypted_object = Riak::JSON.parse(blob)
        cipher.iv = Base64.decode64 encrypted_object['iv']
        decoded_data = Base64.decode64 encrypted_object['data']

        # this serializer now only supports the v2 (0.0.2 - 0.0.4) format
        Riak::JSON.parse(cipher.decrypt decoded_data)
      end

      private

      def self.cipher
        @cipher ||= Cipher.new(Ork::Encryption.encryption_config)
      end

    end
  end
end

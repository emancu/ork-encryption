require_relative 'helper'
require 'mocha/api'
# require 'json'

include(Mocha::API)


class Event
  include Ork::Document
  include Ork::Encryption

  attribute :name
end

config_hash = {
  cipher: 'AES-256-CBC',
  key:    'fantasticobscurekeygoesherenowty'
}

Protest.describe 'Ork::Encryption' do
  context 'include Ork::Encryption' do
    test 'raise an error if it is not a Ork::Document' do
      assert_raise Ork::Encryption::NotAnOrkDocument do
        class NotADocument
          include Ork::Encryption
        end
      end
    end

    test 'set @content_type' do
      assert_equal 'application/x-json-encrypted', Event.content_type
    end
  end

  context 'init' do
    test 'register the serializers on Riak API' do
      assert_equal Ork::Encryption::Serializers::Json,
                   Riak::Serializers['application/x-json-encrypted']
    end

    test 'raise an error if config is invalid' do
      assert_raise Ork::Encryption::MissingConfig do
        Ork::Encryption.init(cipher: 'AES-256-CBC')
      end
    end

    test 'encryption_config is set with the same config of Ork::Encryption' do
      Ork::Encryption.init config_hash

      assert_equal config_hash, Ork::Encryption.encryption_config
    end
  end

  context 'encrypt / decrypt' do
    Ork::Encryption.init config_hash

    class Event
      include Ork::Encryption # reload module
    end

    setup do
      @iv = 'an_iv_really_easy'
      OpenSSL::Cipher.any_instance.stubs(:random_iv).returns(@iv)

      cipher = Ork::Encryption::Cipher.new(config_hash)
      cipher.random_iv!

      @event = Event.create name: 'Encryption'
      @attributes = {'name' => 'Encryption', '_type' => 'Event'}
      @json_attributes = JSON.dump @attributes
      @encrypted_attributes = cipher.encrypt @json_attributes

      @raw_data = raw_data_from_riak @event
      @raw_data = JSON.parse @raw_data
    end

    teardown do
      OpenSSL::Cipher.any_instance.unstub(:random_iv)
    end

    test 'saving the object stores attributes encoded in Base64' do
      assert_equal Base64.encode64(@encrypted_attributes), @raw_data['data']
    end

    test 'saving the object stores the encrypted attributes' do
      assert_equal @encrypted_attributes, Base64.decode64(@raw_data['data'])
    end

    test 'the IV is stored with the encrypted data' do
      assert_equal Base64.encode64(@iv), @raw_data['iv']
    end

    test 'the IV is stored with the encrypted data' do
      assert_equal @iv, Base64.decode64(@raw_data['iv'])
    end

    test 'the VERSION of Ork::Encryption is stored with the encrypted data' do
      assert_equal Ork::Encryption::VERSION, @raw_data['version']
    end

    test 'loading an object decrypts the attributes' do
      assert_equal({name: 'Encryption'}, Event[@event.id].attributes)
    end

    private

    def raw_data_from_riak(object)
      url = "#{ENV['ORK_RIAK_URL']}" +
            "/buckets/#{object.class.bucket_name}/keys/#{object.id}"

      `curl -s -XGET #{url}`
    end

  end
end

require_relative 'helper'

Protest.describe 'Ork::Encryption::Cipher' do
  setup do
    config     = {
      cipher: 'AES-256-CBC',
      key:    'fantasticobscurekeygoesherenowty',
      iv:     'an_iv_really_easy'
    }

    @cipher = Ork::Encryption::Cipher.new config
    @text = "This is some nifty text."
    # this is the example text encrypted (binary string literals use UTF-8 in ruby 2.0
    @blob = "\xCA\x0F\x80\x9D&)lU\x97h\xC9\xAD\x16+\xBC\xAAQ\xD9\xC7C\x8F\xD7\xEFDoRoS\x0E\xEC\xD3\xA6"
    @blob = @blob.force_encoding('ASCII-8BIT')
  end

  test "convert text to an encrypted blob" do
    assert_equal @blob, @cipher.encrypt(@text), "Encryption failed."
  end

  test "convert encrypted blob to text" do
    assert_equal @text, @cipher.decrypt(@blob), "Decryption failed."
  end

  context "With missing parameter" do
    test "raise an error if key is missing" do
      assert_raise Ork::Encryption::MissingConfig do
        Ork::Encryption::Cipher.new(iv: 'iv', cipher: 'AES-256-CBC')
      end
    end

    test "raise an error if cipher is missing" do
      assert_raise Ork::Encryption::MissingConfig do
        Ork::Encryption::Cipher.new(key: 'key')
      end
    end
  end
end

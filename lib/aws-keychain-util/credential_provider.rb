require 'aws-sdk'
require 'keychain'
require 'aws-keychain-util'

module AwsKeychainUtil
  class CredentialProvider
    include Aws::CredentialProvider

    attr_reader :item, :keychain

    def initialize(item = 'AWS', keychain = nil)
      @item, @keychain = item, keychain
    end

    def credentials
      keychain = @keychain ? Keychain.open(@keychain) : AwsKeychainUtil.load_keychain
      item = keychain.generic_passwords.where(label: @item).first
      Aws::Credentials.new(item.attributes[:account], item.password)
    end
  end
end

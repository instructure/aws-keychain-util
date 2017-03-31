require 'aws-sdk-v1'
require 'keychain'
require 'aws-keychain-util'

module AwsKeychainUtil
  # class to automatically grab AWS credentials from your keychain
  class CredentialProvider
    include Aws::CredentialProvider

    attr_reader :item, :keychain

    def initialize(item = 'AWS', keychain = nil)
      @item = item
      @keychain = keychain
    end

    def credentials
      keychain = @keychain ? Keychain.open(@keychain) : AwsKeychainUtil.load_keychain
      item = keychain.generic_passwords.where(label: @item).first
      Aws::Credentials.new(item.attributes[:account], item.password)
    end
  end
end

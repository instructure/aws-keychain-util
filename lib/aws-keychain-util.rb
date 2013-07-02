require 'aws-keychain-util/credential_provider'

module AwsKeychainUtil
  PREFS_FILE = File.expand_path "~/.aws-keychain-util"

  def self.load_keychain
    keychain = if File.exist? PREFS_FILE
      prefs = JSON.parse(File.read(PREFS_FILE))
      Keychain.open(prefs['aws_keychain_name'])
    else
      Keychain.default
    end
    keychain
  end
end

module AwsKeychainUtil
  PREFS_FILE = File.expand_path "~/.aws-keychain-util"

  def self.load_keychain
    name = prefs['aws_keychain_name']
    name ? Keychain.open(name) : Keychain.default
  end

  def self.prefs
    if File.exist? PREFS_FILE
      JSON.parse(File.read(PREFS_FILE))
    else
      {}
    end
  end
end

# AWS Keychain Util

This gem provides a small command line utility that helps
manage AWS credentials in an OS X keychain, keeping them out
of your dotfiles.

This will create a keychain for you which automatically locks
after 5 minutes and on sleep, for some extra security for your
precious AWS secrets.

Once you've added your credentials, you can start a shell with
the credentials in the environment.

## Installation

To install:

    gem install aws-keychain-util

## Usage

To create your keychain:

    $ aws-creds init

Here you can choose a name for your new keychain, or use the
default 'aws'.

To add an item to your aws keychain:

    $ aws-creds add

This will prompt for a friendly name, the access key id,
and the secret access key.

To list items in the keychain:

    $ aws-creds ls

To show some saved credentials:

    $ aws-creds cat <name>

To start a shell with `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
set in the environment:

    $ aws-creds shell <name>

To automatically grab AWS credentials from your keychain when using
the aws-sdk gem, add the following code:

    AWS.config(:credential_provider => AwsKeychainUtil::CredentialProvider.new('<name>', 'keychain name'))

## Security

Unfortunately, when Keychain whitelists either the `aws-creds` script
or a ruby application that uses the CredentialProvider for aws-sdk,
it whitelists `ruby` as a whole. This means *any* ruby script will
be able to access your AWS credentials. We recommend that you either
do not whitelist your script at all (don't click "Always Allow"), or
use a dedicated keychain with an auto-lock interval of less than five
minutes. Keychains created with `aws-creds` will automatically be
configured to auto-lock at 5 minutes.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

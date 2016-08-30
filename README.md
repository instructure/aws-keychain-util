# AWS Keychain Util

*Note:* I've mostly moved on using [vaulted](https://github.com/miquella/vaulted)
for my SSH credential management. It also does cool things like managing
ssh-agents with only certain keys in them, so you don't accidentally leak
your keys to hosts that shouldn't have them. There probably won't be future
updates to AWS Keychain Util, unless someone else wants to take it over.

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
and the secret access key. This also prompts for an optional
MFA arn, which is necessary if you're going to use multifactor
auth with AWS.

To list items in the keychain:

    $ aws-creds ls

To show some saved credentials:

    $ aws-creds cat <name>

To start a shell with `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
set in the environment:

    $ aws-creds shell <name>

To emit the (bourne shell style) environment variable exports that 
you can source into your shell:

    $ aws-creds env <name>

If you want to load the credentials into your *current* shell, add a function
like this to your `.bashrc`:

    aws-shell() { eval "$(/usr/bin/env aws-creds env $@)"; }

Then, you can use `aws-shell <name>`. This can be slightly more convenient as
you keep shell history around.

To always load the given environment in your shell, add the following to
your .bashrc or .zshrc

    eval "$(aws-creds env <name>)"

To automatically grab AWS credentials from your keychain when using
the aws-sdk gem, add the following code:

    require 'aws-keychain-util/credential_provider'
    Aws.config[:credentials] = AwsKeychainUtil::CredentialProvider.new('<name>', 'keychain name')

To remove an item from your aws keychain:

    $ aws-creds rm <name>


## AWS Multi-Factor Authentication (MFA) 

To increase AWS security, it's possible to use MFA (multi-factor) authentication with the amazon APIs. 
Managing temporary credentials is a serious challenge, as by definition the credentials expire after a
fixed period of time.

You then need to associate a multifactor authentication device with the IAM user. 
[Amazon Directions for MFA Setup](http://docs.aws.amazon.com/IAM/latest/UserGuide/GenerateMFAConfig.html)

Configuring MFA into your IAM policies for API access is a complex process, the 
documentation for which is [Here](http://docs.aws.amazon.com/IAM/latest/UserGuide/MFAProtectedAPI.html#ExampleMFAforResource).

In order to do a multifactor authentication, you need to run:

    $ aws-creds mfa <name> <code>

Where `<code>` is the numeric code on your multifactor auth device. Then you just need to either open a
fresh shell for the `<name>` key or re-source your environment.

The tool also tracks mfa expiration, and automatically removes expired tokens when you open a new shell 
or source your env.


## AWS Assume Role credentials

It's also possible assume a role that specifies a set of permissions that you can use to access
AWS resources that you need for a limited time. The role can be in your own account or any other AWS account.

For information about how to create and configure Roles, see
 IAM Roles[Here](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use.html)

In order to configure a role run:

     $ aws-creds add-role <name>

Then to assume a role, you need to run:

    $ aws-creds assume-role <name> <role-name>
    
Then you just need to either open a fresh shell for the `<name>` key or re-source your environment.

The tool also tracks role expiration, and automatically removes expired tokens when you open a new shell 
or source your env.

## Open the Aws Console

Once you have assumed a role you can open the AWS Console in your web browser by running:

    $ aws-creds console <name>

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

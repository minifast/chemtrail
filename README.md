Chemtrail [![Gem Version](https://badge.fury.io/rb/chemtrail.png)](http://badge.fury.io/rb/chemtrail) [![Build Status](https://travis-ci.org/minifast/chemtrail.png)](https://travis-ci.org/minifast/chemtrail) [![Code Climate](https://codeclimate.com/github/minifast/chemtrail.png)](https://codeclimate.com/github/minifast/chemtrail)
==========

Chemtrail lets you build and test CloudFormation templates.


Origin
------

Gems like [cloud_formatter](https://github.com/songkick/cloud_formatter),
[cloud_builder](https://github.com/Optaros/cloud_builder) and
[cfndsl](https://github.com/howech/cfndsl) are pretty cool for building small
CloudFormation stacks.  A more complex stack involves references, which needs
an object hierarchy and testing.


Installation
------------

Add this line to your application's Gemfile:

    gem 'chemtrail'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chemtrail


Usage
-----

See the `examples/` directory for an example of test-driving the
[OpsWorks VPC](http://docs.aws.amazon.com/opsworks/latest/userguide/workingstacks-vpc.html)
CloudFormation template.

Listing all available templates in `lib/templates`:

    $ chemtrail list

Listing templates in a different path:

    $ chemtrail list --path lib/taco/panic

Building a template:

    $ chemtrail build crazy:cat:pants

Validating a template with Amazon (note that you will need to set the environment variables `AWS_REGION`, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_KEY`):

    $ chemtrail validate tangy:socks


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

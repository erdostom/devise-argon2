devise-argon2 [![Build Status](https://secure.travis-ci.org/erdostom/devise-argon2.png)][Continuous Integration]
=============

**A [devise-encryptable] password encryptor that uses [argon2]**

  * [Continuous Integration]

[Continuous Integration]: http://travis-ci.org/erdostom/devise-argon2 "Continuous integration @ travis-ci.org"

[argon2]: https://github.com/technion/ruby-argon2
[devise]: https://github.com/plataformatec/devise
[devise-encryptable]: https://github.com/plataformatec/devise-encryptable

## Usage

Assuming you have [devise] (>= 2.1) and the [devise-encryptable] plugin
set up in your application, add `devise-argon2` to your `Gemfile` and `bundle`:

    gem 'devise-argon2'

Then open up your [devise] configuration,`config/initializers/devise.rb` and configure your encryptor to be `argon2`:

    # config/initializers/devise.rb
    Devise.setup do |config|
      # ..
      config.encryptor = :argon2
      # ...
    end

It is also recommended to uncomment (or add) `config.pepper` with a random
string that will be used in addition to the per-user `password_salt` when hashing.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Released under MIT License.
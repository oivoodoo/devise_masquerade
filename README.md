# Devise Masquerade

It's a utility library for enabling functionallity like login as button for
admin.

If you have multi users application and sometimes you want to test functionally
using login of existing user without requesting the password, define login as
button with url helper and use it.

## Installation

Add this line to your application's Gemfile:

    gem 'devise_masquerade'

And then execute:

    $ bundle

## Usage

In the view you can use url helper for defining link:

    = link_to "Login As", masquerade_path(user)

Add into your application_controller.rb:

    ```ruby
    before_filter :masquerade_user!
    ```

Instead of user you can use your resource name admin, student or another names.

## Custom controller for adding cancan for authorization

    ```ruby
    class Admin::MasqueradesController < Devise::MasqueradesController
      def show
        authorize!(:masquerade, User)

        super
      end
    end
    ```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

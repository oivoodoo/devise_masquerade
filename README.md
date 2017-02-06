# Devise Masquerade
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/oivoodoo/devise_masquerade?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://secure.travis-ci.org/oivoodoo/devise_masquerade.png?branch=master)](https://travis-ci.org/oivoodoo/devise_masquerade)

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/oivoodoo/devise_masquerade)

[![endorse](https://api.coderwall.com/oivoodoo/endorsecount.png)](https://coderwall.com/oivoodoo)

[![Analytics](https://ga-beacon.appspot.com/UA-46818771-1/devise_masquerade/README.md)](https://github.com/oivoodoo/devise_masquerade)

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

In the model you'll need to add the parameter :masqueradable to the existing comma separated values in the devise method:

    devise :invitable, :confirmable, :database_authenticatable, :registerable, :masqueradable

Add into your application_controller.rb:

    before_action :masquerade_user!

Instead of user you can use your resource name admin, student or another names.

If you want to back to the owner of masquerade action user you could use
helpers:

    user_masquerade? # current user was masqueraded by owner?

    = link_to "Reverse masquerade", back_masquerade_path(current_user)

## Custom controller for adding cancan for authorization

    class Admin::MasqueradesController < Devise::MasqueradesController
      def show
        authorize!(:masquerade, User)

        super
      end
    end

## Custom url redirect after masquerade:

    class Admin::MasqueradesController < Devise::MasqueradesController
      def show
        authorize!(:masquerade, User)

        super
      end

      protected

      def after_masquerade_path_for(resource)
        "/custom_url"
      end
    end
    
#### Dont forget to update your Devise routes to point at your Custom Authorization Controller
in `routes.rb`:

    devise_for :users, controllers: { masquerades: "admin/masquerades" }


## You can redefine few options:

    Devise.masquerade_param = 'masquerade'
    Devise.masquerade_expires_in = 10.seconds
    Devise.masquerade_key_size = 16 # size of the generate by SecureRandom.urlsafe_base64
    Devise.masquerade_bypass_warden_callback = false
    Devise.masquerade_routes_back = false # if true, route back to the page the user was on via redirect_back

## Demo project

    cd spec/dummy
    rake db:setup
    rails server

And check http://localhost:3000/, use for login user1@example.com and
'password'

## Test project

    cd spec/dummy
    RAILS_ENV=test rake db:setup
    cd -
    rspec
    cucumber


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Devise Masquerade

 [![Gitter chat](https://badges.gitter.im/oivoodoo/devise_masquerade.svg)](https://gitter.im/oivoodoo/devise_masquerade?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Foivoodoo%2Fdevise_masquerade.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Foivoodoo%2Fdevise_masquerade?ref=badge_shield)

[![Build Status](https://secure.travis-ci.org/oivoodoo/devise_masquerade.svg?branch=master)](https://travis-ci.org/oivoodoo/devise_masquerade)

[![Maintainability](https://api.codeclimate.com/v1/badges/cf63d775dc014a7ebc03/maintainability)](https://codeclimate.com/github/oivoodoo/devise_masquerade/maintainability)

[Consulting](https://bitscorp.co)

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

```ruby
    = link_to "Login As", masquerade_path(user)
```

`masquerade_path` would create specific `/masquerade` path with query params `masquerade`(key) and `masqueraded_resource_class` to know
which model to choose to search and sign in by masquerade key.

In the model you'll need to add the parameter :masqueradable to the existing comma separated values in the devise method:

```ruby
    devise :invitable, :confirmable, :database_authenticatable, :registerable, :masqueradable
```

Add into your `application_controller.rb` if you want to have custom way on sign in by using masquerade token otherwise you can still
use only `masquerade_path` in your view to generate temporary token and link to make `Login As`:

```ruby
    before_action :masquerade_user!
```

or

```ruby
    before_action :masquerade!
```

`masquerade!` is generic way in case if you want to support multiple models on masquerade.

Instead of user you can use your resource name admin, student or another names.

If you want to back to the owner of masquerade action user you could use
helpers:

```ruby
    user_masquerade? # current user was masqueraded by owner?

    = link_to "Reverse masquerade", back_masquerade_path(current_user)
```

## Custom controller for adding cancan for authorization

```ruby
    class Admin::MasqueradesController < Devise::MasqueradesController
      def show
        super
      end

      protected

      def masquerade_authorize!
        authorize!(:masquerade, User)
      end

      # or you can define:
      # def masquerade_authorized?
      #   <has access to something?> (true/false)
      # end
    end
```

## Alternatively using Pundit

Controller:

```ruby
    class Admin::MasqueradesController < Devise::MasqueradesController
      protected

      def masquerade_authorize!
        authorize(User, :masquerade?) unless params[:action] == 'back'
      end
    end
```

In your view:

```erb
    <% if policy(@user).masquerade? %>
      <%= link_to "Login as", masquerade_path(@user) %>
    <% end %>
```

## Custom url redirect after masquerade:

```ruby
    class Admin::MasqueradesController < Devise::MasqueradesController
      protected

      def after_masquerade_path_for(resource)
        "/custom_url"
      end
    end
```

## Custom url redirect after finishing masquerade:

```ruby
    class Admin::MasqueradesController < Devise::MasqueradesController
      protected

      def after_back_masquerade_path_for(resource)
        "/custom_url"
      end
    end
```

## Overriding the finder

For example, if you use FriendlyId:

```ruby
    class Admin::MasqueradesController < Devise::MasqueradesController
      protected

      def find_masqueradable_resource
        masqueraded_resource_class.friendly.find(params[:id])
      end
    end
```

#### Dont forget to update your Devise routes to point at your Custom Authorization Controller
in `routes.rb`:

```ruby
    devise_for :users, controllers: { masquerades: "admin/masquerades" }
```

## You can redefine few options:

```ruby
    Devise.masquerade_param = 'masquerade'
    Devise.masquerade_expires_in = 10.seconds
    Devise.masquerade_key_size = 16 # size of the generate by SecureRandom.urlsafe_base64
    Devise.masquerade_bypass_warden_callback = false
    Devise.masquerade_routes_back = false # if true, route back to the page the user was on via redirect_back
    Devise.masquerading_resource_class = AdminUser
    # optional: Devise.masquerading_resource_class_name = 'AdminUser'

    # optional, default: masquerading_resource_class.model_name.param_key
    Devise.masquerading_resource_name = :admin_user

    Devise.masqueraded_resource_class = User
    # optional: Devise.masqueraded_resource_class_name = 'User'

    # optional, default: masqueraded_resource_class.model_name.param_key
    Devise.masqueraded_resource_name = :user

    # optional, default: masquerade_storage_method = :session
    # values: :session, :cache
    Devise.masquerade_storage_method = :session
```

## Demo project

    cd spec/dummy
    rake db:setup
    rails server

And check http://localhost:3000/, use for login user1@example.com and
'password'

## Troubleshooting

Are you working in development mode and wondering why masquerade attempts result in a [Receiving "You are already signed in" flash[:error]](https://github.com/oivoodoo/devise_masquerade/issues/58) message? `Filter chain halted as :require_no_authentication rendered or redirected` showing up in your logfile? Do you find that your `user_masquerade?` method is always returning false? Chances are that you need to enable caching:

    rails dev:cache

This is a one-time operation, so you can set it and forget it. Should you ever need to disable caching in development, you can re-run the command as required.

## Test project

    make test

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Foivoodoo%2Fdevise_masquerade.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Foivoodoo%2Fdevise_masquerade?ref=badge_large)

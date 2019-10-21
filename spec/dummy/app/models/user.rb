class User < ActiveRecord::Base
  devise :database_authenticatable, :validatable, :masqueradable
end

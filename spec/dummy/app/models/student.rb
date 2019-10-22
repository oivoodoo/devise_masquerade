class Student < ActiveRecord::Base
  devise :database_authenticatable, :validatable, :masqueradable
end

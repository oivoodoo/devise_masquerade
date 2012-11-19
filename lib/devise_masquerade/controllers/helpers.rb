module DeviseMasquerade
  module Controllers
    module Helpers
      def self.define_helpers(mapping)
        name = mapping.name

        class_eval <<-METHODS, __FILE__, __LINE__ + 1
          def masquerade_#{name}!
            return if params[:masquerade].blank?

            #{name} = #{name.to_s.classify}.find_by_masquerade_key(params[:masquerade])

            sign_in #{name} if #{name}
          end
        METHODS
      end
    end
  end
end

ActionController::Base.send(:include, DeviseMasquerade::Controllers::Helpers)

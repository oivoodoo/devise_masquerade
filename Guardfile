guard 'rspec', :cli => '--format documentation', :version => 2, :all_after_pass => false, :keep_failed => false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/.+\.rb$})
  watch(%r{^spec/support/.+\.rb$})
  watch(%r{^lib/(.+)\.rb$})                   { "spec" }
  watch(%r{^lib/devise_masquerade/(.+)\.rb$}) { "spec" }
  watch(%r{^lib/devise_masquerade/controllers/(.+)\.rb$}) { "spec" }
  watch('spec/spec_helper.rb')                { "spec" }
end

guard 'cucumber',:all_after_pass => false do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})           { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end


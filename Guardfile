guard 'rspec', :cli => '--format documentation', :version => 2, :all_after_pass => false, :keep_failed => false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/.+\.rb$})
  watch(%r{^spec/support/.+\.rb$})
  watch(%r{^lib/(.+)\.rb$})                   { "spec" }
  watch(%r{^lib/devise_masquerade/(.+)\.rb$}) { "spec" }
  watch(%r{^lib/devise_masquerade/controllers/(.+)\.rb$}) { "spec" }
  watch('spec/spec_helper.rb')                { "spec" }
end

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end


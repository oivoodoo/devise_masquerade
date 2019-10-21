release:
	bundle exec rake release
.PHONY: release

setup:
	cd spec/dummy && \
	bundle exec rails db:environment:set RAILS_ENV=test && \
	RAILS_ENV=test bundle exec rails db:setup
.PHONY: setup

rspec:
	bundle exec rspec
.PHONY: rspec

cucumber:
	bundle exec cucumber
.PHONY: cucumber

test: setup rspec cucumber

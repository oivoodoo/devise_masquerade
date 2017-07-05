setup:
	cd spec/dummy && \
	RAILS_ENV=test rake db:setup
.PHONY: setup

rspec:
	bundle exec rspec
.PHONY: rspec

cucumber:
	bundle exec cucumber
.PHONY: cucumber

test: setup rspec cucumber

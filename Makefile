prefix=bundle exec

check: ruby-lint rspec

ruby-lint:
	${prefix} rubocop app spec lib

rspec:
	${prefix} rspec --format progress

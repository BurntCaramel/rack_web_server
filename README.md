## Installation

```
gem install bundler
```

- http://bundler.io/

## Gemfile

```
source 'https://rubygems.org'
gem 'rack', '~> 2.0.1'
```

## Running

```
# Only has one response for all requests
ruby server_01_simple.rb

# Has different page content for certain paths
ruby server_02_pages.rb

# Sends the correct status code for not found pages
ruby server_03_status.rb

# Handles trailing slash redirects
ruby server_04_redirect.rb

# Handles static files from public
ruby server_05_files.rb
```
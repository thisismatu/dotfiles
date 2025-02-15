# Zed

Out of the box, [Zed](https://zed.dev/) is pretty good. I've installed only a few extensions and set up the keybindings to match my muscle memory. The settings are pretty much the same as in vscode, but with a few tweaks.

## Files

- [settings.json](./settings.json)
- [keymap.json](./keymap.json)
- [snippets](./snippets)

## Ruby on Rails

Ruby/rails was pretty easy to set up in Zed. Install the **Ruby** extension, a few gems and update the settings. https://zed.dev/docs/languages/ruby

Install gems:

```sh
gem install solargraph solargraph-rails rubocop rubocop-rails erb-formatter yard
```

### Terminal config

Mainly for when running `rails credentials:edit`:

```sh
export EDITOR="zed --wait"
```

To get the `erb-formatter` gem to work:

```sh
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

### Per project

Install gem documentation:

```
yard gems
```

When working in a non-tailwind project:

```json
"ERB": {
  "formatter": {
    "external": {
      "command": "erb-formatter",
      "arguments": [
        "--stdin",
        // "--tailwind-output-path", // Comment out if on non-tailwind project
        // "app/assets/builds/tailwind.css" // Generate this by running bin/rails tailwindcss:build
      ]
    }
  }
}
```

Add `.solargraph.yml` config file to project root:

```yml
---
include:
  - "**/*.rb"
  - "**/*.html.erb"
exclude:
  - spec/**/*
  - test/**/*
  - vendor/**/*
  - ".bundle/**/*"
require:
  - actioncable
  - actionmailer
  - actionpack
  - actionview
  - activejob
  - activemodel
  - activerecord
  - activestorage
  - activesupport
domains: []
reporters:
  - rubocop
  - require_not_found
formatter:
  rubocop:
    cops: safe
    except: []
    only: []
    extra_args: []
require_paths: []
plugins:
  - solargraph-rails
max_files: 5000
```

Add `.rubocop.yml` config file to project root:

```yml
inherit_gem:
  rubocop-rails-omakase: rubocop.yml
require: rubocop-rails
AllCops:
  NewCops: enable
  SuggestExtensions: false
```

[Omakase](https://github.com/rails/rubocop-rails-omakase) is a set of defaults for Rubocop. It's automatically included with new Rails 8 applications.

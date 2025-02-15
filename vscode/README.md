# Visual Studio Code

Out of the box, [Visual Studio Code](https://code.visualstudio.com/) is ok. It has required a lot more tweaking than Zed to get it to a point where I'm happy with it. Config files are synced to the cloud and not available in this repo.

## Ruby on Rails

The vscode setup that seems to be working right now is a mixed bag of extensions and gems. My idea is to do very littel in the project to get a similar experience in all rails projects with minimal setup. Reference articles: https://railsnotes.xyz/blog/vscode-rails-setup and https://github.com/castwide/solargraph/issues/87#issuecomment-1838595739

Install gems:

```bash
gem install solargraph solargraph-rails ruby-lsp ruby-lsp-rails rubocop rubocop-rails erb-formatter yard
```

Install the extensions:

- [Solargraph](https://marketplace.visualstudio.com/items?itemName=castwide.solargraph) - LSP for Ruby, maybe someday replaced by Ruby LSP
- [Ruby LSP](https://marketplace.visualstudio.com/items?itemName=Shopify.ruby-lsp) - LSP for Ruby
- [Stimulus LSP](https://marketplace.visualstudio.com/items?itemName=marcoroth.stimulus-lsp) - LSP for Stimulus
- [Rubocop](https://marketplace.visualstudio.com/items?itemName=misogi.ruby-rubocop) - Linter/formatter for Ruby
- [Ruby ERB::Formatter](https://marketplace.visualstudio.com/items?itemName=elia.erb-formatter) - Formatter for ERB
- [Rails Routes](https://marketplace.visualstudio.com/items?itemName=aki77.rails-routes) - Definition/completion for routes
- [Rails Partials](https://marketplace.visualstudio.com/items?itemName=aki77.rails-partial) - Definition/completion for partials
- [Rails DB Schema](https://marketplace.visualstudio.com/items?itemName=aki77.rails-db-schema) - Definition/completion for db schema
- [html-erb](https://marketplace.visualstudio.com/items?itemName=aki77.html-erb) - HTML intellisense in ERB
- [vscode-gemfile](https://marketplace.visualstudio.com/items?itemName=bung87.vscode-gemfile) - Get Ruby dock link when hovering gem

### Terminal config

Mainly for when running `rails credentials:edit`:

```sh
export EDITOR="code --wait"
```

To get the `erb-formatter` gem to work:

```sh
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

### Editor config

Tailwind intellisense to work in ERB files:

```json
"tailwindCSS.experimental.classRegex": ["\\bclass:\\s*'([^']*)'", "\\bclass:\\s*\"([^\"]*)\""],
"tailwindCSS.includeLanguages": {
  "ruby": "html",
  "erb": "html",
  "html": "html",
  "javascript": "javascript"
},
```

Get Emmet working in ERB files:

```json
"emmet.includeLanguages": {
  "erb": "html",
  "htlm.erb": "html"
},
```

General file associations:

```json
"files.associations": {
  "*.html": "html",
  "*.erb": "erb"
},
```

ERB and Ruby formatting:

```json
"[erb]": {
  "editor.defaultFormatter": "elia.erb-formatter",
  "editor.formatOnSave": true,
  "editor.rulers": [120],
  "files.insertFinalNewline": true
},
"[ruby]": {
  "editor.defaultFormatter": "misogi.ruby-rubocop",
  "editor.formatOnSave": true,
  "editor.formatOnType": true,
  "editor.insertSpaces": true,
  "editor.rulers": [120],
  "editor.semanticHighlighting.enabled": true,
  "editor.tabSize": 2,
  "files.insertFinalNewline": true,
  "files.trimFinalNewlines": true,
  "files.trimTrailingWhitespace": true
},
"erb-formatter.lineLength": 120,
"erb-formatter.commandPath": "$GEM_HOME/bin/erb-formatter"
```

### Terminal config

This is mainly for when running `rails credentials:edit`:

```sh
# .zshrc

export EDITOR="code --wait"
```

### Per project

Install gem documentation:

```
yard gems
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

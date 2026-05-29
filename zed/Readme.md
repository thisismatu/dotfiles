# Zed

My preferred editor.

## Laravel support

The current Zed config looks for our own Pint wrapper when formatting PHP files. To install it, run the commands below:

```sh
cp php-format /usr/local/bin/
chmod +x /usr/local/bin/php-format
```

In Zed config:

```json
"languages": {
  "PHP": {
    "formatter": {
      "external": {
        "command": "/usr/local/bin/php-format",
        "arguments": ["{buffer_path}"],
      },
    },
  },
}
```

For formatting Blade files, install it per project:

```sh
npm install --save-dev @shufo/prettier-plugin-blade prettier
```

Then in `.prettierrc`

```json
{
  "plugins": ["@shufo/prettier-plugin-blade"],
  "overrides": [
    {
      "files": ["*.blade.php"],
      "options": {
        "parser": "blade",
        "tabWidth": 4,
        "wrapAttributes": "force",
        "wrapAttributesMinAttrs": 3,
        "sortTailwindcssClasses": true,
        "indentInnerHtml": true
      }
    }
  ]
}
```

For blade formatting

## Nunjucks support

First, install the Nunjucks extension.

Then, per repo isntall these dependencies:

```sh
npm install --save-dev prettier prettier-plugin-jinja-template
```

Then, updated the prettier config:

```js
{
  plugins: ['prettier-plugin-jinja-template'],
  overrides: [
    {
      files: ['*.njk'],
      options: {
        parser: 'jinja-template'
      }
    }
  ]
}
```

Finally, in Zed config

```jsonc
// settings.json
"languages": {
  "Nunjucks": {
    "formatter": {
      "external": {
        "command": "prettier",
        "arguments": ["--stdin-filepath", "{buffer_path}"]
      }
    }
  },
}
```

To get Emmet working in Nunjucks files, install [my fork](https://github.com/thisismatu/emmet-njk/) as a dev extension or wait for [my PR](https://github.com/zed-extensions/emmet/pull/11) to get merged into the official extension.

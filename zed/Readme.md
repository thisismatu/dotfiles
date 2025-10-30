# Zed

My preferred editor.

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

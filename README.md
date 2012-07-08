# jQuery tag strip plugin

## The one-liner
  It strips tags from content you pass to it.

## Stripping options include
* Whitelist
* Blacklist
* Use any jQuery selector
* Remove tags or unwrap them, leaving behind child nodes.

## Examples

### Strip all tags, leaving content
```javascript
  $('<p>Some <em>html</em></p>').stripTags().html() == 'Some html'
```

### Whitelist
```javascript
  $('<p>Some <em>content</em></p>')
    .stripTags({ whitelist: ['p'] })
    .html() == '<p>Some html</p>'
```

### Blacklist
```javascript
  $('<p>Some <em>html</em></p>')
    .stripTags({ blacklist: ['p'] })
    .html() == 'Some <em>html</em>'
```

### Remove nodes
```javascript
  $('<p>Some <em>html</em></p>')
    .stripTags({ blacklist: ['em'], mode: 'remove' })
    .html() == '<p>Some </p>'
```

### Child selector
```javascript
  $('<p>Some <span class="outer">nested <span class="inner">spans</span></span></p>')
    .stripTags({ blacklist: ['span span'] })
    .html() == '<p>Some <span class="outer">nested spans</span></p>'
```

### Class selector
```javascript
  $('<p>Some <span class="outer">nested <span class="inner">spans</span></span></p>')
    .stripTags({ blacklist: ['.outer'] })
    .html() == '<p>Some nested <span class="inner">spans</span></p>'
```

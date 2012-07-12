# jQuery tag strip plugin

## The one-liner
  It strips tags from matched DOM elements or arbitrary content.

## Stripping options include
* Whitelist
* Blacklist
* Use any jQuery selector
* Remove tags or unwrap them, leaving behind child nodes.

## Examples

### jQuery selection API
Select all p tags and remove and all within except for bold tags.
```html
<p>ZOMG <i>foo</i> is <b>LOL</b>
```
After this
```javascript
  $('p').stripTags({ whitelist: ['b'] })
```
becomes
```html
<p>ZOMG foo is <b>LOL</b></p>
```
Tags are removed from the contents of the targeted tags, in this case 'p'.

Further options are documented below.

### Arbitrary content API
Accepts a HTML node object or string.

### Strip all tags, leaving content
```javascript
  $.stripTags('<p>Some <em>html</em></p>') == 'Some html'
```

### Whitelist
```javascript
  $.stripTags('<p>Some <em>content</em></p>', { whitelist: ['p'] })
    == '<p>Some html</p>'
```

### Blacklist
```javascript
  $.stripTags('<p>Some <em>html</em></p>', { blacklist: ['p'] }
    == 'Some <em>html</em>'
```

### Remove nodes
```javascript
  $.stripTags('<p>Some <em>html</em></p>', { blacklist: ['em'], mode: 'remove' })
    == '<p>Some </p>'
```

### Child selector
```javascript
  $.stripTags('<p>Some <span class="outer">nested <span class="inner">spans</span></span></p>',
    { blacklist: ['span span'] })
    == '<p>Some <span class="outer">nested spans</span></p>'
```

### Class selector
```javascript
  $.stripTags('<p>Some <span class="outer">nested <span class="inner">spans</span></span></p>',
    { blacklist: ['.outer'] })
    == '<p>Some nested <span class="inner">spans</span></p>'
```

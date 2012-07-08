( ($) ->
  $.fn.stripTags = (options) ->
    options = options || {}
    validOptions = [ 'whitelist', 'blacklist', 'mode' ]
    validModes = [ 'unwrap', 'remove' ]
    whitelist = options.whitelist || []
    blacklist = options.blacklist || []
    mode = options.mode || validModes[0]

    if whitelist.length > 0 && blacklist.length > 0
      throw TypeError("Only one option of whitelist, blacklist can be set")

    if validModes.indexOf(mode) < 0
      throw TypeError("invalid mode '" + mode + "'")
    for optionKey of options
      if validOptions.indexOf(optionKey) < 0
        throw TypeError("invalid option '" + optionKey + "'")

    subject = $('<div />').append(this.get())

    filterNode = (node) ->
      if mode == 'remove'
        node.remove()
      else
        node.replaceWith(node.html())

    filterableNodes = ->
      if whitelist.length
        # start with all nodes
        currentScope = subject.find('*')
        # exlude whitelisted nodes
        for selector in whitelist
          currentScope = currentScope.not(selector)
      else if blacklist.length
        # start with nothing
        currentScope = $()
        for selector in blacklist
          currentScope = currentScope.add( subject.find(selector) )
      else
        # filter all nodes
        currentScope = subject.find('*')
      currentScope

    while filterableNodes().length
      filterNode(filterableNodes().first())

    return subject
)(jQuery)

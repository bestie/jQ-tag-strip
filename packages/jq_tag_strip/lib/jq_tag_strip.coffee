( ($) ->
  whitelist = blacklist = subject = mode = null
  validOptions = [ 'whitelist', 'blacklist', 'mode' ]
  validModes = [ 'unwrap', 'remove' ]

  filterNode = (node) ->
    if mode == 'remove'
      node.remove()
    else
      node.replaceWith(node.html())

  nodesNotWhitelisted = ->
    # start with all nodes
    currentScope = subject.find('*')
    # exlude whitelisted nodes
    for selector in whitelist
      currentScope = currentScope.not(selector)
    currentScope

  blacklistedNodes = ->
    # start with nothing
    currentScope = $()
    for selector in blacklist
      currentScope = currentScope.add( subject.find(selector) )
    currentScope

  markNodesForFiltering = (scope) ->
    scope.attr('data-jq-tag-strip-target-node', true)

  getMarkedNodes = ->
    subject.find('[data-jq-tag-strip-target-node]')

  bothWhiteAndBlackListNotAllowed = ->
    if whitelist.length > 0 && blacklist.length > 0
      throw TypeError("Only one option of whitelist, blacklist can be set")

  modeMustBeValid = ->
    if validModes.indexOf(mode) < 0
      throw TypeError("invalid mode '" + mode + "'")


  invalidOptionsNotAllowed = (options) ->
    for optionKey of options
      if validOptions.indexOf(optionKey) < 0
        throw TypeError("invalid option '" + optionKey + "'")

  normalizeAndCheckOptions = (options) ->
    options = options || {}
    whitelist = options.whitelist || []
    blacklist = options.blacklist || []
    mode = options.mode || validModes[0]

    bothWhiteAndBlackListNotAllowed()
    modeMustBeValid()
    invalidOptionsNotAllowed(options)

  $.stripTags = (string, options) ->
    normalizeAndCheckOptions(options)
    subject = $('<div />').append(string)

    if whitelist.length > 0
      currentScope = nodesNotWhitelisted()
    else if blacklist.length > 0
      currentScope = blacklistedNodes()
    else
      currentScope = subject.find('*')

    markNodesForFiltering(currentScope)

    # jQuery.each cannot be used here as when unwrapping the html structure
    # is being changed and references to original subject are lost
    while (nodes = getMarkedNodes()).length > 0
      filterNode( nodes.first() )

    return subject.html()

  $.fn.stripTags = (options={}) ->
    this.each ->
      $this = $(this)
      $this.html( $.stripTags($this.html(), options) )

)(jQuery)

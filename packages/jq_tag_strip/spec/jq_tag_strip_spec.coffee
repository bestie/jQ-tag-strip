
describe "jQuery#strip_tags", ->
  html_content = stripped_content = null

  beforeEach ->
    html_content = "<p>Some <em>content</em></p>"
    stripped_content = "Some content"

  describe "by default", ->
    it "strips all tags from a html string", ->
      expect( $.stripTags(html_content) )
        .toEqual( stripped_content )

  describe "with a whitelist", ->
    it "strips tags not present in the white list at the top level", ->
      expect( $.stripTags("<p>a paragraph</p><div>and a div</div>", whitelist: ['p'] ) )
        .toEqual( "<p>a paragraph</p>and a div" )

    it "strips deeply nested tags", ->
      expect(
        $.stripTags("<p>a paragraph <b>bold text <em>emphasized text</em></b></p>",
          whitelist: ['b'] )
      ).toEqual("a paragraph <b>bold text emphasized text</b>")

    it "strips tags with arbitrary selectors", ->
      expect(
        $.stripTags('<p><span class="foo">foo</span><span class="bar">bar</span>',
          whitelist: ['span.foo'] )
      ).toEqual( '<span class="foo">foo</span>bar')

    describe "with a child selector", ->
      it "filters only the selected child nodes", ->
        expect(
          $.stripTags("<p><span>outer <span>inner</span></span></p>",
            whitelist: ['span > span'])
        ).toEqual( "outer <span>inner</span>")


  describe "with a blacklist", ->
    it "removes tags from the black list, leaving other tags behind", ->
      expect(
        $.stripTags("<p>a paragraph <b>bold text <em>emphasized text</em></b></p>",
          blacklist: ['em'] )
      ).toEqual("<p>a paragraph <b>bold text emphasized text</b></p>")

    describe "with a child selector", ->
      it "filters only the selected child nodes", ->
        expect(
          $.stripTags("<p><span>outer <span>inner</span></span></p>",
            blacklist: ['span > span'])
        ).toEqual( "<p><span>outer inner</span></p>")

  describe "with mode: remove option", ->
    it "removes nodes rather than unwrapping them", ->
      expect(
        $.stripTags('<p>paragraph <b>bold <em>emphasized</em></b></p>',
          blacklist: ['em'], mode: 'remove' )
      ).toNotContain('emphasized')

  describe "errors", ->
    describe "when both a blacklist and whitelist are passed", ->
      it "throws a TypeError", ->
        expect( ->
          $.stripTags( 'string',
            whitelist: ['stuff']
            blacklist: ['other stuff']
          )
        ).toThrow(TypeError("Only one option of whitelist, blacklist can be set"))

    describe "when an invalid option is passed", ->
      it "throws a TypeError", ->
        expect( -> $.stripTags( 'string', invalidOptionName: 'some value' ))
          .toThrow( TypeError("invalid option 'invalidOptionName'"))

    describe "when an invalid mode is passed", ->
      it "throws a TypeError", ->
        expect( -> $.stripTags( 'string', mode: 'invalid mode') )
          .toThrow( TypeError("invalid mode 'invalid mode'") )

describe "jQuery.fn#stripTags", ->

  it "strips the tags from the nodes HTML", ->
    node = $('<div><p>Node 1</p></div>')[0]
    strippedNode = $([node]).stripTags().first()
    expect( strippedNode.html() )
      .toEqual( 'Node 1' )

  it "uses the passed options", ->
    node = $('<div><p>Node 1</p></div>')[0]
    strippedNode = $([node]).stripTags(whitelist: 'p').first()
    expect( strippedNode.html() )
      .toEqual( '<p>Node 1</p>' )

  it "maintains chainability", ->
    node1 = $('<div>')[0]
    node2 = $('<div>')[0]
    expect( $([node1, node2]).stripTags().length ).toEqual( 2 )

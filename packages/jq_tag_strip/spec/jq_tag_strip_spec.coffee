
describe "jQuery#strip_tags", ->
  html_content = stripped_content = null

  beforeEach ->
    html_content = "<p>Some <em>content</em></p>"
    stripped_content = "Some content"

  it "returns a jQuery object for chainability", ->
    expect( $().stripTags().stripTags ).toBeDefined()

  describe "by default", ->
    it "strips all tags from a html string", ->
      expect( $(html_content).stripTags() )
        .notToContainHtmlTags()

    it "unwraps text nodes within the HTML leaving them in place", ->
      expect( $(html_content).stripTags().html() )
        .toEqual( stripped_content )

  describe "with a whitelist", ->
    it "strips tags not present in the white list at the top level", ->
      expect( $("<p>a paragraph</p><div>and a div</div>")
        .stripTags( whitelist: ['p'] ).html() )
        .toEqual( "<p>a paragraph</p>and a div" )

    it "strips deeply nested tags", ->
      expect( $(
        "<p>a paragraph <b>bold text <em>emphasized text<em></b></p>"
        ).stripTags( whitelist: ['b'] ).html()
      ).toEqual("a paragraph <b>bold text emphasized text</b>")

    it "strips tags with arbitrary selectors", ->
      expect( $('<p><span class="foo">foo</span><span class="bar">bar</span>')
        .stripTags( whitelist: ['span.foo'] ).html()
      ).toEqual( '<span class="foo">foo</span>bar')

  describe "with a blacklist", ->
    it "removes tags from the black list, leaving other tags behind", ->
      expect( $(
        "<p>a paragraph <b>bold text <em>emphasized text</em></b></p>"
        ).stripTags( blacklist: ['em'] ).html()
      ).toEqual("<p>a paragraph <b>bold text emphasized text</b></p>")

  describe "with mode: remove option", ->
    it "removes nodes rather than unwrapping them", ->
      expect( $('<p>paragraph <b>bold <em>emphasized</em></b></p>')
        .stripTags(blacklist: ['em'], mode: 'remove').html()
      ).toNotContain('emphasized')

  describe "errors", ->
    describe "when both a blacklist and whitelist are passed", ->
      it "throws a TypeError", ->
        expect( ->
          $().stripTags(
            whitelist: ['stuff']
            blacklist: ['other stuff']
          )
        ).toThrow(TypeError("Only one option of whitelist, blacklist can be set"))

    describe "when an invalid option is passed", ->
      it "throws a TypeError", ->
        expect( -> $().stripTags( invalidOptionName: 'some value' ))
          .toThrow( TypeError("invalid option 'invalidOptionName'"))

    describe "when an invalid mode is passed", ->
      it "throws a TypeError", ->
        expect( -> $().stripTags( mode: 'invalid mode') )
          .toThrow( TypeError("invalid mode 'invalid mode'") )


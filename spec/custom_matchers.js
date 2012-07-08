(function(){
  var htmlRegExp = /\<[a-z0-9='"\-\/ ]*\>/;

  beforeEach( function(){
    this.addMatchers({

      toContainHtmlTags: function(){
        var actual = this.actual;

        this.message = function(){
          return "Expected " + actual + " to conain HTML.";
        }

        return htmlRegExp.test( actual );
      },

      notToContainHtmlTags: function(){
        var actual = this.actual;

        this.message = function(){
          return "Expected " + actual + " not to contain HTML.";
        }

        return !htmlRegExp.test( actual );
      }

    });
  });
})()

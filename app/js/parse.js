
var Remarkable = require('remarkable'),
    katex = require('katex'),
    hljs = require('highlight.js'),
    latex_delim = /(@@@)([\S\s]*?)(@@@)/g,
    // instantiate markdown parser with highlighting
    md = new Remarkable({
      html: true,
      xhtmlOut: true,
      langPrefix: 'language-',
      typographer: true,
      highlight: function(str, lang) {
        var out = '';
        if (lang && hljs.getLanguage(lang)) {
          try {
            out = hljs.highlight(lang, str).value
          } catch(e) { console.log('hljs parse error:', e) }
        } else {
          try {
            out = hljs.highlightAuto(str).value;
          } catch(e) { console.log('hljs parse error:', e) }
        }
        return out;
      }
    });


function render(eq) {
  return katex.renderToString(
    eq.replace(/@@@/g,"").trim()
  );
}

function center(s) {
  return "<center>" + s + "</center>";
}

function parse(markdown) {

  var equations = markdown.match(latex_delim);

  // replace all TeX strings with rendered
  // latex results
  equations && equations.forEach(function(eq){
    // use katex to render latex string
    var rendered = eq.match(/displaystyle/) ?
                     center(render(eq))     :
                     render(eq);
    // replace latex with rendered
    markdown = markdown.replace(eq, rendered);

  markdown

  });

  return md.render(markdown);

}


module.exports = parse;
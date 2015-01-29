(function() {
  var filename, md;

  md = new Remarkable({
    html: true,
    xhtmlOut: true,
    langPrefix: 'language-',
    typographer: true,
    highlight: function(str, lang) {
      if (lang && hljs.getLanguage(lang)) {
        try {
          return hljs.highlight(lang, str).value;
        } catch (_error) {
          '';
        }
      }
      try {
        return hljs.highlightAuto(str).value;
      } catch (_error) {
        '';
      }
      return '';
    }
  });

  filename = window.location.hash.substr(1);

  $.get("posts/" + filename + ".md", function(raw, errortext) {
    var LaTeX, render;
    if (errortext === 'success') {
      LaTeX = raw.match(/(@@@)([\S\s]*?)(@@@)/g);
      render = function(eq) {
        return katex.renderToString(eq.replace(/@@@/g, "").trim());
      };
      if (LaTeX != null) {
        LaTeX.map(function(eq) {
          var rendered;
          if (eq.indexOf("displaystyle") !== -1) {
            rendered = "<center>" + (render(eq)) + "</center>";
          } else {
            rendered = render(eq);
          }
          return raw = raw.replace(eq, rendered);
        });
      }
      $('#rendered').html(md.render(raw));
      $('#rendered img').addClass('img-responsive');
      $('#rendered h1').addClass('v-center');
      return $('#viewsource').attr('href', "posts/" + filename + ".md");
    }
  });

}).call(this);

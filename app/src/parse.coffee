#
#
# Parse markedown + katex
#
#

md = new Remarkable 
    html:         true        # Enable html tags in source
    xhtmlOut:     true        # Use '/' to close single tags (<br />)
    langPrefix:   'language-'  # CSS language prefix for fenced blocks
    typographer:  true        # Enable smartypants and other sweet transforms
    highlight:  (str, lang) ->
        if (lang and hljs.getLanguage(lang))
          try
            return hljs.highlight(lang, str).value
          catch 
            ''
        try
          return hljs.highlightAuto(str).value
        catch 
          ''
        return ''

filename = window.location.hash.substr(1)

$.get "posts/#{filename}.md" , (raw, errortext) ->
  # If the markdown file exists
  if errortext is 'success'
    LaTeX = raw.match  /(@@@)([\S\s]*?)(@@@)/g 
    render = (eq) -> katex.renderToString eq.replace(/@@@/g,"").trim()
    LaTeX?.map (eq) -> 
      if eq.indexOf("displaystyle") != -1
        rendered = "<center>#{render(eq)}</center>"
      else
        rendered = render(eq)
      raw = raw.replace eq, rendered

    $('#rendered').html md.render raw
    $('#rendered img').addClass 'img-responsive'
    $('#rendered h1').addClass 'v-center'
    $('#viewsource').attr 'href', "posts/#{filename}.md"
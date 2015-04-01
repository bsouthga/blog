#
# markdown renderer for posts
#

Remarkable = require "remarkable"
katex = require "katex"
hljs = require "highlight.js"
cheerio = require "cheerio"

# delimiters used in markdown to
# indicate latex syntax
latex_delim = /(@@@)([\S\s]*?)(@@@)/g

# instantiate markdown parser with highlighting
md = new Remarkable
  html: true
  xhtmlOut: true
  langPrefix: "language-"
  typographer: true
  highlight: (str, lang) ->
    out = ""
    if lang and hljs.getLanguage lang
      try
        out = hljs.highlight(lang, str).value
      catch e
        console.log "hljs parse error:", e
    else
      try
        out = hljs.highlightAuto(str).value
      catch e
        console.log "hljs parse error:", e
    out

# render latex equations into html
render = (eq) ->
  katex.renderToString eq.replace(/@@@/g, "").trim()

# wrap string in center tags (for display math)
center = (s) -> "<div class=\"text-center display-math\">#{s}</div>"

# render markdown post into html with equations
module.exports = (markdown) ->

  equations = markdown.match latex_delim

  equations?.forEach (eq) ->
    rendered = if eq.match /displaystyle/
                 center render eq
               else
                 render eq
    markdown = markdown.replace eq, rendered

  html = md.render markdown

  # load rendered markdown into cheerio for easy traversal
  $ = cheerio.load html

  # link images to staic folder
  $("img")
    .each -> $(@).attr "src", "/static/images/#{$(@).attr("src")}"
    .addClass "inline-image"

  # grab sections from h2 tabs to insert into bootstrap affixed sidebar
  section_count = 0
  sections = []
  $("h2").each ->
    $n = $ @

    id = $n.text()
           .toLowerCase()
           .replace /[^a-z0-9]/g, " "
           .replace /\s+/g, "-"

    $n.attr 'id', id

    sections.push {
      id : $n.attr 'id'
      text : $n.html()
    }

  # return updated html
  return {
    html : $.root()
    title : $("h1").html()
    sections : sections
  }



#
# basic routing for bsouth.ga
#

express = require "express"
hb = require "handlebars"
_ = require "lodash"
fs = require "fs"
mkdown = require "./src/mkdown.coffee"

# load post and viz json
site_data = require "./full_site.json"

template = (f) -> hb.compile fs.readFileSync "views/#{f}.html", "utf8"

# compile templates when app starts
index = template "index"
post = template "post"
notfound = template "404"
bibliography = template "bibliography"
vizualization = template "vizualizations"
thoughts = template "thoughts"
main = template "main"

# prepare posts for serving
posts = fs.readdirSync "./posts/"
  .reduce (p_obj, p) ->
    # read in markdown source
    md = mkdown fs.readFileSync "./posts/#{p}", "utf-8"
    # add vendor scripts to options
    opts =
      title : md.title
      year : new Date().getUTCFullYear()
      source : p
      content : post { rendered : md.html }
    # compile template and minify
    p_obj[p.replace ".md", ""] = main opts
    p_obj
  # object to reduce posts into
  , {}

app = express()

# index page
app.get "/", (req, res) ->
  res.send main {
    content : index site_data
    year : new Date().getUTCFullYear()
  }

app.get "/bibliography", (req, res) ->
  res.send main {
    content : bibliography site_data
    year : new Date().getUTCFullYear()
  }

app.get "/vizualization", (req, res) ->
  res.send main {
    content : vizualization site_data
    year : new Date().getUTCFullYear()
  }

app.get "/posts", (req, res) ->
  res.send main {
    content : thoughts site_data
    year : new Date().getUTCFullYear()
  }

# blog posts
app.get "/posts/:id", (req, res) ->
  post = posts[req.params.id]
  if post then res.send post else res.redirect "/404"

# file not found template
app.get "/404", (req, res) ->
  res.status 404
  res.send notfound {}

# static folder for client side scripts
app.use "/static", express.static "#{__dirname}/static"

# static folder for client side scripts
app.use "/posts/source/", express.static "#{__dirname}/posts"

# default to homepage if other path entered
app.use (req, res, next) -> res.redirect "/"


# start server
server = app.listen 3000, ->
  host = server.address().address
  port = server.address().port
  console.log "listening at http://#{host}:#{port}"



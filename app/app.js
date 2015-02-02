

var express = require('express'),
    parse = require('./js/parse.js'),
    fs = require('fs'),
    _ = require('lodash'),
    handlebars = require('handlebars'),
    minify = require('html-minifier').minify,
    site_root = __dirname;


var post_template = handlebars.compile(
  fs.readFileSync('./views/post.html', 'utf-8')
);

var wrap = {
  '.css' : function(s) { return '<style>' + s + '</style>'},
  '.js' : function(s) { return '<script>' + s + '</script>'}
}

// files for injecting
var vendor = [
  "../bower_components/jquery/dist/jquery.min.js",
  "../bower_components/bootstrap/dist/js/bootstrap.min.js",
  "../bower_components/bootstrap/dist/css/bootstrap.min.css",
  "../bower_components/highlightjs/styles/docco.css",
  "./css/main.css"
]
.reduce(function(v, f) {
  var name = f.split('/').slice(-1)[0];
  var ext = name.match(/\.([\w]+$)/g);
  v[name.replace(/\./g, "_")] = wrap[ext](
    fs.readFileSync(f, 'utf-8')
  )
  return v;
}, {});



// prepare posts for serving
var posts = fs.readdirSync('./posts/')
  .reduce(function(p_obj, p) {

    // read in markdown source
    var md = fs.readFileSync(
      './posts/' + p, "utf-8"
    );

    // add vendor scripts to options
    var opts = _.extend({
      rendered : parse(md),
      title : "Test"
    }, vendor);

    // compile template and minify
    p_obj[p.replace('.md', "")] = minify(post_template(opts), {
      "minifyJS" : true,
      "minifyCSS" : true,
      "collapseWhitespace" : true
    });

    return p_obj;
  }, {});


var app = express();

app.get('/', function (req, res) {
  res.send('Hello World!')
})

app.get('/images/*', function (req, res) {
  var f = '.' + req.url;
  res.sendfile(f)
});

app.get('/lib/*', function (req, res) {
  var f = '.' + req.url;
  res.sendfile(f)
});

// blog post route
app.get('/p/*', function(req, res) {
  var post = posts[req.url.slice(3)];
  if (post) {
    res.send(post);
  } else {
    res.send('Dunno any post by that name...');
  }
})


var server = app.listen(3000, function () {

  var host = server.address().address
  var port = server.address().port

  console.log('Example app listening at http://%s:%s', host, port)

})


import * as express from 'express';
import { minify } from 'html-minifier';
import  * as uglify from 'uglify-js';
import { readFileSync, readFile, readdirSync } from 'fs';

const read = denodeify(readFile);
const port = process.env.PORT || 3000;


start().catch(err => {
  console.log(err.stack);
});


function denodeify<D, T>(
  fn: (data: D, cb: (err: Error, result: T) => void) => void
): (data: D) => Promise<T> {
  return function(data: D) {
    return new Promise((res, rej) => {
      fn.call(this, data, (e: Error, d: T) => e ? rej(e) : res(d));
    });
  };
}


async function loadPosts() {
  const postDir = './public/posts/';
  const posts = readdirSync(postDir);
  const postList = await Promise.all(posts.map(async (filename) => {
    const file = (await read(postDir + filename)).toString();
    return parsePostMetadata(filename, file);
  }));

  postList.sort((a, b) => {
    return (new Date(b.date)).getTime() - (new Date(a.date)).getTime();
  });

  return postList;
}


/**
 * TODO: move posts to db
 */

interface PostMetadata {
  date : string;
  subtitle : string;
  title : string;
  filename : string;
  content : string;
}



function parsePostMetadata(filename: string, post: string): PostMetadata {
  const [ __, metadataRaw, content  ] = post.split('---');
  const metadata = metadataRaw.split('\n').reduce((out, line) => {
    const [key, ...values] = line.split(':');
    out[key.replace(/\W/g, '').trim()] = values.join(':').trim();
    return out;
  }, {} as { [key: string]: string });

  return {
    date: metadata['date'],
    subtitle: metadata['subtitle'],
    title: metadata['title'],
    filename: filename.replace(/\.md$/, ''),
    content
  }
}


async function start() {
  const app = express();

  const loaded = await loadPosts();

  const postCache = loaded.reduce((o, l) => {
    o[l.filename] = l.content;
    return o;
  }, {} as { [key: string]: string });

  const posts = loaded.map(
    ({ date, subtitle, title, filename }) =>
    ({ date, subtitle, title, filename }));

  const assetFiles = [
    './public/vendor/github.css',
    './public/assets/frontend.css',
    './public/vendor/highlight.js',
    './public/assets/frontend.js'
  ];

  const assets = (await Promise.all(assetFiles.map(read)))
    .reduce((out, asset, index) => {
      const filename = assetFiles[index];
      const str = asset.toString();
      out[filename] = str;
      return out;
    }, { } as { [key: string]: string });

  /**
   *
   * build app on server startup
   *
   */
  const raw = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Ben Southgate</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.6.0/katex.min.css">
      <style>
        ${assets['./public/vendor/github.css']}
        ${assets['./public/assets/frontend.css']}
      </style>
    </head>
    <body>
      <script type="text/javascript">
        ${assets['./public/vendor/highlight.js']}
        ${assets['./public/assets/frontend.js']}
        ;Elm.Main.fullscreen();
        ;hljs.initHighlightingOnLoad();
      </script>
      <script>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

        ga('create', 'UA-54214517-1', 'auto');
        ga('send', 'pageview');

      </script>
    </body>
    </html>
  `;

  const index = minify(raw, {
    minifyCSS: true,
    minifyJS: true
  });


  app.use(express.static('public'));


  app.get('/api/post/:id', (req, res) => {
    const id: string = req.params.id;
    if (id in postCache)  return res.send(postCache[id]);
    return res.sendStatus(404);
  });


  app.get('/api/posts', (req, res) => {
    res.send(posts);
  });

  // TODO move to db
  const viz = require('./assets/graphics.json');

  app.get('/api/graphics', (req, res) => {
    res.send(viz);
  });

  app.get('/favicon.ico', (req, res) => {
    res.send('');
  })

  // GET method route
  app.get('*', (req, res) => {
    res.send(index);
  });


  app.listen(port, () => {
    console.log(`server listening at http://127.0.0.1:${port}/`);
  });
}


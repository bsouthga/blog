import * as express from 'express';
import { minify } from 'html-minifier';
import  * as uglify from 'uglify-js';
import { readFileSync, readFile, readdirSync } from 'fs';

const read = denodeify(readFile);


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


function loadPosts() {
  const postDir = './public/posts/';
  const posts = readdirSync(postDir);
  return Promise.all(posts.map(async (filename) => {
    const file = (await read(postDir + filename)).toString();
    return parsePostMetadata(filename, file);
  }));
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
    './public/frontend.css',
    './public/vendor/highlight.js',
    './public/frontend.js'
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
        ${assets['./public/frontend.css']}
      </style>
    </head>
    <body>
      <script type="text/javascript">
        ${assets['./public/vendor/highlight.js']}
        ${assets['./public/frontend.js']}
        ;Elm.Main.fullscreen();
        ;hljs.initHighlightingOnLoad();
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
  const viz = require('./visualizations.json');

  app.get('/api/visualizations', (req, res) => {
    res.send(viz);
  });

  app.get('/favicon.ico', (req, res) => {
    res.send('');
  })

  // GET method route
  app.get('*', (req, res) => {
    res.send(index);
  });


  app.listen(8080, () => {
    console.log('Example app listening on port 8080!')
  });
}


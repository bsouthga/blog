import * as express from 'express';
import { readFileSync, readFile, readdirSync } from 'fs';


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
  const read = denodeify(readFile)
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


  const index = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Ben Southgate</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.6.0/katex.min.css">
      <style>
        ${readFileSync('./public/frontend.css').toString()}
      </style>
    </head>
    <body>
      <script>
        ${readFileSync('./public/frontend.js').toString()}
        ;Elm.Main.fullscreen();
      </script>
    </body>
    </html>
  `;


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

  // GET method route
  app.get('*', (req, res) => {
    res.send(index);
  });


  app.listen(8080, () => {
    console.log('Example app listening on port 8080!')
  });
}


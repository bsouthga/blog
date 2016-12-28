import express = require('express');
import { readFileSync, readFile } from 'fs';

const app = express();
const frontend = readFileSync('./public/index.html').toString();


const postCache: { [key: string]: string } = {};
const notFound = new Set<string>();
app.get('/api/post/:id', (req, res) => {
  const id: string = req.params.id;

  if (id in postCache) {
    return res.send(postCache[id]);
  }

  if (notFound.has(id)) {
    return res.sendStatus(404);
  }

  try {
    postCache[id] = readFileSync('./public/md/' + id + '.md').toString();
    return res.send(postCache[id]);
  } catch (err) {
    notFound.add(id);
    return res.sendStatus(404);
  }
});

// GET method route
app.get('*', (req, res) => {
  res.send(frontend);
});

app.listen(8080, () => {
  console.log('Example app listening on port 8080!')
});
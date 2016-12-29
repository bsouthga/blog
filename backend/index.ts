import * as express from 'express';
import { readFileSync, readFile, readdirSync } from 'fs';


const app = express();
const postCache: { [key: string]: string } = {};
const notFound = new Set<string>();


const index = `
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Ben Southgate</title>
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


app.use('/public', express.static('public'))


app.get('/api/post/:id', (req, res) => {
  const id: string = req.params.id;
  if (id in postCache)  return res.send(postCache[id]);
  if (notFound.has(id)) return res.sendStatus(404);

  try {
    postCache[id] = readFileSync('./public/md/' + id + '.md').toString();
    return res.send(postCache[id]);
  } catch (err) {
    notFound.add(id);
    return res.sendStatus(404);
  }
});


// TODO move to db
const posts = [
  {
    "date": "01/04/2014",
    "subtitle": " A basic class for an easily subsetable dictionary using Python's <a href=\"http://docs.python.org/2/library/collections.html#namedtuple-factory-function-for-tuples-with-named-fields\">namedtuple</a> as keys for multidimensional indexing",
    "title": "Indexing with namedtuple",
    "filename" : "indexing-with-named-tuple"
  },
  {
    "date": "12/03/2013",
    "subtitle": "Investigating a few \"Pythonic\" ways to calculate gradients across given input colors",
    "title": "Color gradients with Python",
    "filename" : "color-gradients-with-python"
  },
  {
    "date": "10/01/2013",
    "subtitle": "Data analysis, LaTeX source generation, and pdf report compiling all in a single Stata .do file",
    "title": "Dynamic reports with \"StaTeX\"",
    "filename" : "dynamic-reports-with-statex"
  },
  {
    "date": "09/01/2013",
    "subtitle": "Random walk data generation and plotting in R<sup>3</sup>",
    "title": "10 million steps with R",
    "filename" : "10-million-steps-with-R"
  }
];

app.get('/api/posts', (req, res) => {
  res.send(posts);
});


// TODO move to db
const viz = [
  {
    "url": "http://gop.bsouth.ga",
    "title": "GOP Twitter Derby",
    "github": "https://github.com/bsouthga/gop-primary-twitter-fun",
    "image": "images/gop.png"
  },
  {
    "url" : "http://bsouthga.github.io/atlantic-income-charts/",
    "title": "Income + College Majors",
    "github": "https://github.com/bsouthga/atlantic-income-charts",
    "image": "images/atlantic-income.png"
  },
  {
    "url" : "http://datatools.urban.org/features/average-wages/",
    "title": "Wages and Employment Explorer",
    "github": "https://github.com/UI-Research/RockefellerWages",
    "image": "images/wages-and-employment.png"
  },
  {
    "url": "http://datatools.urban.org/features/childrens-health-coverage-at-risk/iframe_test.html",
    "github": "https://github.com/UrbanInstitute/child-insurance",
    "title": "Children’s Coverage: What Lies Ahead?",
    "image": "images/child-insurance.png"
  },
  {
    "url" : "http://www.theatlantic.com/business/archive/2015/03/laughter-in-fed-transcripts/388027/",
    "title": "Laughing All the Way to the Crash",
    "github": "https://github.com/bsouthga/funnyfed",
    "image": "images/funnyfed.png"
  },
  {
    "url" : "http://bsouthga.github.io/d3-exploder/",
    "title": "d3.geo.exploder",
    "github": "https://github.com/bsouthga/d3-exploder",
    "image": "images/d3-geo-exploder.png"
  },
  {
    "url" : "http://datatools.urban.org/features/mapping-americas-futures",
    "github": "https://github.com/UrbanInstitute/mapping-americas-futures",
    "title" : "Mapping America's Futures",
    "image" : "images/MAF.png"
  },
  {
    "url" : "http://datatools.urban.org/features/build-your-own-pension",
    "github": "https://github.com/UrbanInstitute/build-your-own-pension",
    "title" : "Build Your Own Pension Plan",
    "image" : "images/build-your-own-pension.png"
  },
  {
    "url" : "http://datatools.urban.org/Features/domestic-violence-data/dataviz/",
    "title" : "Vizualizing Gaps in Domestic Violence Data",
    "image" : "images/datadive.png"
  },
  {
    "url" : "http://datatools.urban.org/features/bsouthga/crimeplot/",
    "title" : "Crimes in US Cities",
    "image" : "images/crimeplot.png"
  },
  {
    "url" : "http://datatools.urban.org/features/everydayviolence/",
    "title" : "Gun Violence in Washington DC",
    "image" : "images/everydayviolence.png"
  },
  {
    "url" : "http://blog.metrotrends.org/2014/08/higher-minimum-wages-improve-economic-well-being-dc/",
    "title" : "Minimum Wage Meta-analysis",
    "image" : "images/metaanalysis.png"
  },
  {
    "url" : "http://datatools.urban.org/features/slepp/",
    "title" : "SLEPP Report Card",
    "image" : "images/slepp.png"
  }
];

app.get('/api/visualizations', (req, res) => {
  return res.send(viz);
});

// GET method route
app.get('*', (req, res) => {
  res.send(index);
});


app.listen(8080, () => {
  console.log('Example app listening on port 8080!')
});
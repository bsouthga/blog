import { minify } from "html-minifier";
import * as uglify from "uglify-js";
import * as fs from "fs";

const imagemin = require("imagemin");
const jpegtran = require("imagemin-jpegtran");
const pngquant = require("imagemin-pngquant");

interface PostMetadata {
  date: string;
  subtitle: string;
  title: string;
  filename: string;
  content: string;
}

const read = denodeify(fs.readFile);
const port = process.env.PORT || 3000;

build().catch(err => {
  console.log(err.stack);
});

function denodeify<D, T>(
  fn: (data: D, cb: (err: Error, result: T) => void) => void
): (data: D) => Promise<T> {
  return function<ThisType>(this: ThisType, data: D) {
    return new Promise((res, rej) => {
      fn.call(this, data, (e: Error, d: T) => (e ? rej(e) : res(d)));
    });
  };
}

async function loadPosts() {
  const postDir = "./public/posts/";
  const posts = fs.readdirSync(postDir);
  const postList = await Promise.all(
    posts.map(async filename => {
      const file = (await read(postDir + filename)).toString();
      return parsePostMetadata(filename, file);
    })
  );

  postList.sort((a, b) => {
    return new Date(b.date).getTime() - new Date(a.date).getTime();
  });

  return postList;
}

function parsePostMetadata(filename: string, post: string): PostMetadata {
  const [__, metadataRaw, content] = post.split("---");
  const metadata = metadataRaw.split("\n").reduce((out, line) => {
    const [key, ...values] = line.split(":");
    out[key.replace(/\W/g, "").trim()] = values.join(":").trim();
    return out;
  }, {} as { [key: string]: string });

  return {
    date: metadata["date"],
    subtitle: metadata["subtitle"],
    title: metadata["title"],
    filename: filename.replace(/\.md$/, ""),
    content
  };
}

async function build() {
  const loaded = await loadPosts();

  const postCache = loaded.reduce((o, l) => {
    o[l.filename] = l.content;
    return o;
  }, {} as { [key: string]: string });

  const posts = loaded.map(({ date, subtitle, title, filename }) => ({
    date,
    subtitle,
    title,
    filename
  }));

  const assetFiles = [
    "./public/vendor/github.css",
    "./public/assets/frontend.css",
    "./public/vendor/highlight.js",
    "./public/assets/frontend.js"
  ];

  const assets = (await Promise.all(
    assetFiles.map(read)
  )).reduce((out, asset, index) => {
    const filename = assetFiles[index];
    const str = asset.toString();
    out[filename] = str;
    return out;
  }, {} as { [key: string]: string });

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
        ${assets["./public/vendor/github.css"]}
        ${assets["./public/assets/frontend.css"]}
      </style>
    </head>
    <body>
      <script>
        /**
         * handle s3 redirects
         */
        if (location.hash.length > 0 && location.hash.substring(0, 2) === '#!') {
          history.pushState({}, '', location.hash.substring(2));
        }

        ;${assets["./public/vendor/highlight.js"]}
        ;${uglify.minify(assets["./public/assets/frontend.js"]).code}
        ;Elm.Main.fullscreen();
        ;hljs.initHighlightingOnLoad();


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

  if (!fs.existsSync("./public/api/")) fs.mkdirSync("./public/api/");
  if (!fs.existsSync("./public/api/post/")) fs.mkdirSync("./public/api/post/");

  await Promise.all(
    Object.keys(postCache).map(key => {
      return write(`./public/api/post/${key}`, postCache[key]);
    })
  );

  await write(`./public/api/posts`, JSON.stringify(posts));
  await write(
    `./public/api/graphics`,
    JSON.stringify(require("./assets/graphics.json"))
  );
  await write("./public/index.html", index);

  console.log(`optimizing images...`);
  await imagemin(["public/images/*.{jpg,png}"], "public/optimized", {
    use: [jpegtran(), pngquant({ quality: "65-80" })]
  });
}

function write(filename: string, data: any) {
  console.log(`writing file ${filename}...`);
  new Promise((res, rej) => {
    fs.writeFile(filename, data, err => (err ? rej(err) : res()));
  });
}

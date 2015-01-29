module.exports = (grunt) ->

  #
  # folder to copy distribution files to
  # when running 'grunt deploy'
  #
  deploy_path = '<deploy path>'

  #
  # Full build system steps
  #
  full_build = [
    'coffee'        # 1 : compile coffeescript
    'uglify:js'     # 3 : uglify urban js files
    'cssmin'        # 4 : uglify urban css files
    'processhtml'   # 6 : replace development <script> tags with dist
    'htmlmin'       # 7 : minify html
    'copy:dist'
  ]

  # Register configuration
  grunt.initConfig
    copy :
      setup :
        files : [
          {
            expand: true
            cwd : "bower_components/bootstrap/dist/"
            src: ['**']
            dest: 'app/lib/vendor/bootstrap/'
          },
          {
            expand: true
            cwd : "bower_components/jquery/dist/"
            src: ['**']
            dest: 'app/lib/vendor/jquery/'
          },
          {
            expand: true
            cwd : "bower_components/d3/"
            src: ['*.js']
            dest: 'app/lib/vendor/d3/'
          }
        ]
      dist : 
        files : [
          {
            expand: true
            cwd : "app/json/"
            src: ['**']
            dest: 'dist/json/'
          }
        ]

    uglify:
      options:
        mangle: true
      js:
        files:
          './dist/app.min.js' : [
            "./app/lib/vendor/d3/d3.min.js"
            "./app/lib/vendor/jquery/jquery.min.js"
            "./app/lib/vendor/bootstrap/js/bootstrap.min.js"
            './app/lib/main.js'
          ]
          './dist/post.min.js' : [
            "./app/lib/vendor/jquery/jquery.min.js"
            "./app/lib/vendor/katex/katex.min.js"
            "./app/lib/vendor/bootstrap/js/bootstrap.min.js"
            "./app/lib/vendor/remarkable/remarkable.min.js"
            "./app/lib/vendor/highlightjs/highlight.pack.js"
            "./app/lib/parse.js"
          ]
    coffee:
      compile:
        options :
          join : true
        files:
          # Concatenate all components and compile
          './app/lib/main.js': [
            #
            # Main Coffeescript file
            #
            './app/src/main.coffee'
          ]
          './app/lib/parse.js' : [
            './app/src/parse.coffee'
          ]

    watch:
      coffee :
        files: [
          './app/src/*.coffee'
        ],
        tasks : ['coffee']
      html :
        files : ['./app/index.html']
        tasks : ['coffee']
      css :
        files : ['./app/css/main.css']
        tasks : ['coffee']
      options :
        livereload : true
    browserSync:
      bsFiles:
        src : [
          './app/lib/main.js',
          './app/css/main.css',
          './app/index.html'
        ]
      options:
        watchTask: true
        server:
            baseDir: "./app/"
    processhtml :
      dist :
        files :
          './app/index_dist.html' : ['./app/index.html']
          './app/post_dist.html' : ['./app/post.html']
    htmlmin :
      dist :
        options :
          collapseWhitespace: true
        files :
          './dist/index.html' : './app/index_dist.html'
          './dist/post.html' : './app/post_dist.html'
    cssmin :
      dist :
        files :
          './app/css/deploy_styles.min.css' : [
            # user css files for deployment
            "./app/css/main.css"
          ]
          './dist/post.min.css' : [
            "./app/lib/vendor/bootstrap/css/bootstrap.min.css"
            "./app/lib/vendor/katex/katex.min.css"
            "./app/lib/vendor/highlightjs/styles/docco.css"
            "./app/lib/vendor/cm-serrif/cmun-serif.css"
            "./app/css/main.css"
          ]
          './dist/app.min.css' : [
            "./app/lib/vendor/bootstrap/css/bootstrap.min.css"
            "./app/lib/vendor/cm-serrif/cmun-serif.css"
            "./app/css/deploy_styles.min.css"
          ]


  libs = [
   'grunt-contrib-uglify'
   'grunt-contrib-watch'
   'grunt-contrib-coffee'
   'grunt-contrib-concat'
   'grunt-contrib-copy'
   'grunt-contrib-htmlmin'
   'grunt-contrib-cssmin'
   'grunt-browser-sync'
   'grunt-processhtml'
  ]

  grunt.loadNpmTasks(pkg) for pkg in libs

  # Coffee compiling, uglifying and watching in order
  grunt.registerTask 'default', [
    'coffee'
    'browserSync'
    'watch'
  ]

  # copy bower dependencies
  grunt.registerTask 'setup', [
    'copy:setup'
  ]

  # deploy distribution code
  grunt.registerTask 'deploy', full_build
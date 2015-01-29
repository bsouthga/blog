(function() {
  $(function() {
    var format;
    $('#sidebar').affix({
      offset: {
        top: 0
      }
    });
    format = function(date) {
      var d, formattedDate, m, y;
      formattedDate = new Date(date);
      d = formattedDate.getDate();
      m = formattedDate.getMonth() + 1;
      y = formattedDate.getFullYear();
      return "" + m + "/" + d + "/" + y;
    };
    return $.getJSON('json/full_site.json', function(data) {
      var $posts, $pubs, add_pubs, pub_list;
      $posts = $('#posts');
      $.each(data.post_list, function(i, post) {
        return $('<tr></tr>').html("<td class=\"date-cell\">" + (format(post.date)) + "</td><td></td>").append($("<td> <a href=\"/post.html#" + post.filename + "\"> " + post.title + " </a> <td>")).appendTo($posts);
      });
      $pubs = $('#pubs');
      pub_list = data.pub_list.indy.concat(data.pub_list.urban);
      add_pubs = function(i, pub) {
        return $('<div class="pub"></div>').append($("<span class=\"author\"> " + pub.authors + ", </span>")).append($("<a class=\"pub-link\" href=\"" + pub.link + "\"> " + pub.title + " </a>")).append($("<span class=\"publisher\"> (" + pub.org + ") </span>")).append($("<blockquote> " + pub.abstract + " </blockquote>")).appendTo($pubs);
      };
      $.each(pub_list.slice(0, 3), add_pubs);
      $('#more-pubs').click(function() {
        $(this).remove();
        return $.each(pub_list.slice(2), add_pubs);
      });
      return $("#content").scrollspy();
    });
  });

}).call(this);

$ ->

  $('#sidebar').affix({
    offset: {
      top: 0
    }
  })

  format = (date) ->
    formattedDate = new Date(date)
    d = formattedDate.getDate()
    m = formattedDate.getMonth() + 1
    y = formattedDate.getFullYear()
    "#{m}/#{d}/#{y}"

  $.getJSON 'json/full_site.json', (data) ->


    $posts = $('#posts')
    $.each data.post_list, (i, post) ->
      $('<tr></tr>')
        .html("<td class=\"date-cell\">#{format post.date}</td><td></td>")
        .append(
          $("<td>
              <a href=\"/post.html##{post.filename}\">
                #{post.title}
              </a>
            <td>")
        )
        .appendTo($posts)

    $pubs = $('#pubs')
    pub_list = data.pub_list.indy.concat data.pub_list.urban

    add_pubs = (i, pub) ->
      $('<div class="pub"></div>')
        .append(
          $("<span class=\"author\">
                #{pub.authors},
              </span>")
        )        
        .append(
          $("<a class=\"pub-link\" href=\"#{pub.link}\">
                #{pub.title}
              </a>")
        )
        .append(
          $("<span class=\"publisher\">
                (#{pub.org})
              </span>")
        )
        .append(
          $("<blockquote>
              #{pub.abstract}
            </blockquote>")
        )
        .appendTo($pubs)

    $.each pub_list[..2], add_pubs

    $('#more-pubs').click ->
      $(@).remove()
      $.each pub_list[2..], add_pubs





    $("#content").scrollspy()


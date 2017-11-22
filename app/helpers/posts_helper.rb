require 'date'

module PostsHelper

  # function to handle the recursive building of
  # replies
  def build_replies(responses, post, indent = 4)

    html = ''

    # For each of the responses in the collection build the html for it
    responses.each do |response|
      html = html + "<div style='margin-left:#{indent}%;' class='response'>"
      html = html + "<p>#{response.user.firstname + " " + response.user.surname }  </p>"
      html = html + "<p> #{display_date(@post.created_at)} </p>"
      html = html + "<p><strong>#{response.title}</strong></p><br>"
      html = html + "<p>#{response.text}</p><br>"

      html = html + "<p>  #{link_to('Reply', new_reply_path + post_path(@post) +
                                reply_path(response))}</p>"

      html = html + "</div>"

      # If this reply has responses, reccursivley call this function
      # to keep building html
      if response.responses.count > 0
        html = html + build_replies(response.responses, post, indent + 4)
      end
    end

    html.html_safe
  end

  # Convert the time to something a bit more readable
  def display_date(date)
    date.to_formatted_s(:short)
  end
end

module PostsHelper

  # function to handle the recursive building of
  # replies
  def build_replies(responses, post, html = '', indent = 5)

    # For each of the responses in the collection build the html for it
    responses.each do |response|
      html = html + "<div style='margin-left:#{indent}%;' class='response'>"
      html = html + "<p>#{response.user.firstname + " " + response.user.surname }  </p>"
      html = html + "<p><strong>#{response.title}</strong></p>"
      html = html + "<p>#{response.text}</p>"

      # Pre build the url - seperate it out of line below
      url = "/post/#{post}/reply/#{response.id}"

      html = html + "<p>  #{link_to 'Reply', new_reply_path + url}</p>"

      html = html + "</div>"

      # If this reply has responses, reccursivley call this function
      # to keep building html
      if(response.responses)
        indent = indent + 5
        html = build_replies(response.responses, post, html, indent)
      end
    end

    html.html_safe
  end
end

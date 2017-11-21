require 'date'

module PostsHelper

  # function to handle the recursive building of
  # replies
  def build_replies(responses, post, indent = 3)

    html = ''

    # For each of the responses in the collection build the html for it
    responses.each do |response|
      html = html + "<div style='margin-left:#{indent}%;' class='response'>"
      html = html + "<p>#{response.user.firstname + " " + response.user.surname }  </p>"
      html = html + "<p><strong>#{response.title}</strong></p><br>"
      html = html + "<p>#{response.text}</p><br>"

      # Pre build the url - seperate it out of line below
      url = "/post/#{post}/reply/#{response.id}"

      html = html + "<p>  #{link_to 'Reply', new_reply_path + url}</p>"

      html = html + "</div>"

      # If this reply has responses, reccursivley call this function
      # to keep building html
      if response.responses.count > 0
        html = html + build_replies(response.responses, post, indent + 3)
      end
    end

    html.html_safe
  end

  # Convert the time to something a bit more readable
  def display_date(date)
    date.to_formatted_s(:short)
  end
end

require 'date'

module PostsHelper

  # list of the unread posts.
  @unread_replies

  # The current post
  @current_post

  # Function to check if a post is unread
  def check_unread(reply)
    found = false

    @unread_replies.each do |r|
      if reply.id == r.id
        found = true
      end
    end
     found
  end

  # Function to update when the user has read this post
  # and replies. And store info about current post
  def mark_as_read(post)

    @current_post = post

    UnreadPost.update_record(@current_post, current_user.id)
  end

  # Function to calculate amount of unread posts
  def unread_posts(post)

    # Get the last known access of the user for this post
    unread = UnreadPost.where(post_id: post, user_id: current_user.id)

    # If there is no last access recorded, assume all are unread, else, get the amount
    # of posts created after the date of last access, and count them
    if unread.count == 0
      @unread_replies = Reply.where(post_id: post)
    else
      @unread_replies = Reply.get_last_access(post, unread[0].updated_at, current_user.id)
    end

    @unread_replies.count
  end

  # function to handle the recursive building of
  # replies
  def build_replies(responses, post, indent = 4)

    html = ''

    # For each of the responses in the collection build the html for it
    responses.each do |response|
      if check_unread(response)
        html = html + "<div style='margin-left:#{indent}%;' class='response-unread'>"
      else
        html = html + "<div style='margin-left:#{indent}%;' class='response'>"
      end

      html = html + "<p>#{response.user.firstname + " " + response.user.surname }  </p>"
      html = html + "<p> #{display_date(@post.created_at)} </p>"
      html = html + "<p><strong>#{response.title}</strong></p><br>"
      html = html + "<p>#{response.text}</p><br>"

      html = html + "<p>  #{link_to 'Reply', new_post_reply_path(@post.id) + reply_path(response) } </p>"

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

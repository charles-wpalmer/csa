module PostsHelper

  # function to handle the recursive building of
  # replies
  def build_replies(replies, post, html = '')
    html = '<table>
    <thead>
    <tr>
    <th>User</th>
    <th>Parent</th>
    <th>Post</th>
    <th>Title</th>
    <th>Text</th>
    <th colspan="3"></th>
    </tr>
  </thead>
    <tbody>'

    replies.each do |reply|
      html = html + "<tr>
      <td> + #{reply.user.firstname + " " + reply.user.surname } + </td>"
        if reply.parent
            html = html + "<td> #{reply.parent.title}</td>"
        else
            html = html + "<td> -- </td>"
        end
            html = html + "<td>#{reply.post.title}</td>"
      html = html + "<td>#{reply.title}</td>"
      html = html + "<td>#{reply.text}</td>"
      html = html + "<td>#{link_to 'Reply', new_reply_path}/post/#{post}/reply/#{reply.id}</td>"
      if(reply.responses)
        html = html + "<td>#{build_replies(reply.responses, html)}</td>"
      end
      html = html + "</tr>"
    end
    html = html + "</tbody>"
    html = html + "</table>"

    html.html_safe
  end
end

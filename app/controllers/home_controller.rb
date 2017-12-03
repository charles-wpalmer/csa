# Very simple controller to deal with the landing page
# @author Chris Loftus
class HomeController < ApplicationController
  skip_before_action :login_required

  def index
    @posts = @posts = Post.all
                          .limit(5)
                          .order("created_at DESC")
  end

end

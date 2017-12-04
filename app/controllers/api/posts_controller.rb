# Handles incoming user account HTTP JSON web service requests
# @author Charles Palmer
class API::PostsController < API::ApplicationController

  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts.json
  def index
    @posts = Post.all.order("created_at DESC")
  end

  # GET /posts/1.json
  def show
    @replies = Reply.get_by_post_id(params[:id])
  end

  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.json { render :show, status: :created, location: @post }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :post_count, :title, :text, :anonymous)
    end
end

# Handles incoming user account HTTP JSON web service requests
# @author Charles Palmer
class API::PostsController < API::ApplicationController
  before_action :set_current_page, except: [:index]
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts.json
  def index
    @posts = Post.paginate(page: params[:page],
                  per_page: params[:per_page])
        .order("created_at DESC")

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

  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.json { render :show, status: :ok, location: @post }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1.json
  def destroy

    # Double make sure the logged in user is the author before deleting,
    # should never be due to hiding delete button for other users
    if current_user.id == @post.user_id

      # Delete the post
      @post.destroy

      respond_to do |format|
        format.json { head :no_content }
      end

    else
      respond_to do |format|
        format.json { head :no_content }
      end
    end
  end

  # Set the current page for pagination
  def set_current_page
    @current_page = params[:page] || 1
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

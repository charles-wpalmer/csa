class PostsController < ApplicationController
  before_action :set_current_page, except: [:index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.paginate(page: params[:page],
                  per_page: params[:per_page])
        .order("created_at DESC")

  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @replies = Reply.get_by_post_id(params[:id])
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.post_count = 0

    respond_to do |format|
      if @post.save
        format.html {redirect_to(post_url(@post, page: @current_page),
                                 notice: 'Thread was successfully created.')}
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy

    # Double make sure the logged in user is the author before deleting,
    # should never be due to hiding delete button for other users
    if current_user.id == @post.user_id

      # Delete all the associated replies
      @post.replies.destroy_all

      # Delete all associated unread_posts
      @post.unread_posts.destroy_all

      # Delete the post
      @post.destroy

      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      end

    else
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Only the author can delete the post.' }
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

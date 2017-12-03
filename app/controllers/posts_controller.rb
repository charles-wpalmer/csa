class PostsController < ApplicationController
  before_action :set_current_page, except: [:index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.paginate(page: params[:page],
                  per_page: params[:per_page])
        .order("created_at DESC")
  end

  # GET /posts/1
  def show
    @replies = Reply.get_by_post_id(params[:id])

    # Set the @unread_replies, and mark post as read
    set_unread_posts(@post)
    mark_as_read(@post.id)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html {redirect_to(post_url(@post, page: @current_page),
                                 notice: 'Thread was successfully created.')}
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /posts/1
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /posts/1
  def destroy

    # Double make sure the logged in user is the author before deleting,
    # should never be due to hiding delete button for other users
    if current_user.id == @post.user_id

      # Delete the post
      @post.destroy

      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      end

    else
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Only the author can delete the post.' }
      end
    end
  end

  # Set the current page for pagination
  def set_current_page
    @current_page = params[:page] || 1
  end

  # Function to get the unread posts. Works by getting last access
  # and getting replies based upon that time.
  def set_unread_posts(post)

    unread = UnreadPost.where(post_id: post.id, user_id: current_user.id)

    if unread.count == 0
      @unread_replies = Reply.where(post_id: post.id)
    else
      @unread_replies = Reply.get_last_access(post.id, unread[0].updated_at, current_user.id)
    end
  end

  private
    # Function to update when the user has read a post
    # and replies. And store info about current post
    def mark_as_read(post)
      UnreadPost.update_record(post, current_user.id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :post_count, :title, :text, :anonymous)
    end
end

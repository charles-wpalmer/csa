class UnreadPostsController < ApplicationController
  before_action :set_unread_post, only: [:show, :edit, :update, :destroy]

  # GET /unread_posts
  # GET /unread_posts.json
  def index
    @unread_posts = UnreadPost.all
  end

  # GET /unread_posts/1
  # GET /unread_posts/1.json
  def show
  end

  # GET /unread_posts/new
  def new
    @unread_post = UnreadPost.new
  end

  # GET /unread_posts/1/edit
  def edit
  end

  # POST /unread_posts
  # POST /unread_posts.json
  def create
    @unread_post = UnreadPost.new(unread_post_params)

    respond_to do |format|
      if @unread_post.save
        format.html { redirect_to @unread_post, notice: 'Unread post was successfully created.' }
        format.json { render :show, status: :created, location: @unread_post }
      else
        format.html { render :new }
        format.json { render json: @unread_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unread_posts/1
  # PATCH/PUT /unread_posts/1.json
  def update
    respond_to do |format|
      if @unread_post.update(unread_post_params)
        format.html { redirect_to @unread_post, notice: 'Unread post was successfully updated.' }
        format.json { render :show, status: :ok, location: @unread_post }
      else
        format.html { render :edit }
        format.json { render json: @unread_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unread_posts/1
  # DELETE /unread_posts/1.json
  def destroy
    @unread_post.destroy
    respond_to do |format|
      format.html { redirect_to unread_posts_url, notice: 'Unread post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unread_post
      @unread_post = UnreadPost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unread_post_params
      params.require(:unread_post).permit(:user_id, :post_id, :unread)
    end
end

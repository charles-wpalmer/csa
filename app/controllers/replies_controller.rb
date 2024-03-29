class RepliesController < ApplicationController
  before_action :set_reply, only: [:show, :edit, :update, :destroy]

  # GET /replies
  # GET /replies.json
  def index
    @replies = Reply.all
  end

  # GET /replies/1
  # GET /replies/1.json
  def show
  end

  # GET /replies/new
  def new
    @reply = Reply.new

    # Get the title of the parent reply, as by default
    # should be the same, but can be changed
    if(params[:parent_id])
      parent = params[:parent_id]

      @reply.title = Reply.find(parent).title
    end

  end

  # GET /replies/1/edit
  def edit
  end

  # POST /replies
  # POST /replies.json
  def create
    @reply = Reply.new(reply_params)

    @reply.user_id = current_user.id

    # If no Parent reply, make the value 0
    if(@reply.parent_id == nil)
      @reply.parent_id = 0
    end

    respond_to do |format|
      if @reply.save

        # Update the last seen date of the unread_posts record, to prevent this
        # reply being counted as 'unseen'
        UnreadPost.update_record(@reply.id, current_user.id)

        @post = Post.find(@reply.post_id)

        format.html {redirect_to(post_url(@post, page: @current_page),
                                 notice: 'Reply was successfully created.')}
        format.json { render :show, status: :created, location: @reply }
      else
        format.html { render :new }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /replies/1
  # PATCH/PUT /replies/1.json
  def update
    respond_to do |format|
      if @reply.update(reply_params)
        format.html { redirect_to @reply, notice: 'Reply was successfully updated.' }
        format.json { render :show, status: :ok, location: @reply }
      else
        format.html { render :edit }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /replies/1
  # DELETE /replies/1.json
  def destroy
    @reply.destroy
    respond_to do |format|
      format.html { redirect_to replies_url, notice: 'Reply was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reply
      @reply = Reply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reply_params
      params.require(:reply).permit(:user_id, :parent_id, :post_id, :title, :text)
    end
end

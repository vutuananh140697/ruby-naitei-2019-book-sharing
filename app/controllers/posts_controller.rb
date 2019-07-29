class PostsController < ApplicationController
  before_action :logged_in_user, except: %i(index show)
  before_action :load_post, only: %i(show edit update destroy)
  before_action :correct_user, only: :destroy
  before_action :load_support

  def index
    @posts = Post.all
  end

  def show; end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: t("post_success") }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post,
          notice: t("update_success") }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url,
        notice: t("destroy_success")}
      format.json { head :no_content }
    end
  end

  private

  def post_params
    params.require(:post).permit :user_id, :title, :content, :book_id
  end

  def load_post
    @post = Post.find_by id: params[:id]

    return if @post
    flash[:warrning] = t "post_not_found"
    redirect_to root_path
  end

  def correct_user
    @post = current_user.posts.find_by id: params[:id]
    redirect_to root_url if @post.nil?
  end

  def load_support
    @support = Supports::Posts.new post: Post.all, param: params
  end
end

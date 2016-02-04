class PostsController < ApplicationController

  before_action :require_sign_in, except: :show
  before_action :authorize_user, except: [:show, :new, :create, :edit, :update]
  before_action :check_mod, only: [:edit, :update]

  def show
    @post = Post.find(params[:id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(post_params)
    @post.user = current_user

    if @post.save
      flash[:notice] = "Post was saved."
      redirect_to [@topic, @post]
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :new
    end
  end


  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.assign_attributes(post_params)


    if @post.save
      flash[:notice] = "Post was updated."
      redirect_to [@post.topic, @post]
    else
      flash.now[:alert] = "There was an error saving the post. Please try again. "
      render :edit
    end
  end

    def destroy
      @post = Post.find(params[:id])

      if @post.destroy
        flash[:notice] = "\"#{@post.title}\" was deleted successfully."
        redirect_to @post.topic
      else
        flash.now[:alert] = "There was an error deleteing the post."
        renders :show
      end
    end

    private
      def post_params
        params.require(:post).permit(:title, :body)
      end

      def authorize_user
        post = Post.find(params[:id])

        unless current_user == post.user || current_user.admin?
          flash[:alert] = "This is not your post. You must be the post owner or an admin to do that" #should say something different imho
          redirect_to [post.topic, post]
        end
      end

      def check_mod
        post = Post.find(params[:id])

        unless current_user == post.user || current_user.admin? || current_user.moderator?
          flash[:alert] = "This is not your post. You must be the post owner, a moderator, or an admin to do that" #should say something different imho
          redirect_to [post.topic, post]
        end
      end
end

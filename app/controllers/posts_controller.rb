class PostsController < ApplicationController

  def show
    @post = Post.find(params[:id])
    @topic = Topic.find(params[:topic_id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
    authorize! :create, Post, message: "You need to be a member to create a new post"
  end

 def create
  @topic = Topic.find(params[:topic_id])
  @post = current_user.posts.build(post_params[:post])
  @post.topic = @topic
  authorize! :create, @post, message: "You need to be signed up to do that"
  if @post.save
    flash[:notice] = "Post was saved."
    redirect_to [@post.topic, @post]
  else
    flash[:error] = "There was an error saving the post. Please try again."
    render :new
  end
end

def edit
   @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:id])
    authorize! :edit, @post, message: "You need to own the post to edit it."
  end

  def update
    @post = Post.find(params[:id])
    authorize! :update, @post, message: "You need to own the post to edit it."
    if @post.update_attributes(post_params[:post])
      redirect_to [@post.topic, @post]
      flash[:notice] = "Post was updated."
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :edit
    end
  end

private
def post_params
    params.require(:post).permit(:title, :body)
  end

end

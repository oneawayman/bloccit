class CommentsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    @comment = @post.comments
    @comment = current_user.comments.build(comment_params)
    @comment.post = @post

  authorize! :create, @comment, message: "You need to be signed up to do that"
  if @comment.save
      flash[:notice] = "Comment added"
      @comments = @post.comments
      redirect_to [@topic, @post]
  else
      flash[:error] = "There was an error saving the post. Please try again."
      render 'posts/show'
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    authorize! :destroy, @comment, message: "You need to own the comment to delete it."
    if @comment.destroy
      flash[:notice] = "Comment was removed."
      redirect_to [@topic, @post]
    else
      flash[:error] = "Comment couldn't be deleted. Try again."
      redirect_to [@topic, @post]
    end
  end


private
def comment_params
    params.require(:comment).permit(:body, :image)
  end

end


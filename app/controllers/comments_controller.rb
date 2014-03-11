class CommentsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.Posts.find(params[:post_id])
    @comment = @post.comments
    @comment = current_user.comments.build(comment_params)
    @comment.post = @post

  authorize! :create, @comment, message: "You need to be signed up to do that"
  if @comment.save
      flash[:notice] = "Comment added"
      redirect_to [@topic, @Post]
  else
      flash[:error] = "There was an error saving the post. Please try again."
      render 'posts/show'
    end
  end

private
def comment_params
    params.require(:comment).permit(:body, :image)
  end

end


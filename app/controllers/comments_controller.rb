class CommentsController < ApplicationController
  def new
    if params[:id].nil?
      redirect_to :controller => 'users', :action => 'index'
    else  
    	@comment = Comment.new
    	@photo = Photo.find_by_id(params[:id])
    	if @photo.nil?
    		flash[:error] = "Photo with ID #{params[:id]} does not exist!"
    	end
    end
  end

  def create
    @photo = Photo.find_by_id(params[:id])
    if params[:comment].nil?
      redirect_to :action => 'new', :id => params[:id]
    else
      @comment = Comment.new
      @comment.comment = params[:comment][:comment]
      @comment.photo_id = @photo.id
      @comment.user_id = session[:user_id]
      @comment.date_time = DateTime.now

      if @comment.save
          flash[:notice] = "Comment posted!" 
          redirect_to :controller => :photos, :action => :index, :id => @photo.user.id
      else
      	flash[:error] = "Your comment cannot be blank!"
      	redirect_to :action => :new, :id => @photo.id
       end
    end
  end

end

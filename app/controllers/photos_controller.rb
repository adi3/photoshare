class PhotosController < ApplicationController

  def index
  	@user = User.find_by_id(params[:id])
  	if @user != nil
  		@photos = @user.photos
  	end
  end

  def new
  	@photo = Photo.new
  end

  def create
    photo = params[:photo][:photo]

    if not Photo.image_file? photo
      flash[:error] = "You can only upload image files on here!"
      redirect_to :action => :new
      return
    end

  	if not params[:photo].nil?
	    @photo = Photo.new
	    @photo.user_id = session[:user_id]
	    @photo.date_time = DateTime.now
      @photo.file_name = Photo.get_unique_name photo

	    if @photo.save
        Photo.upload_file @photo.file_name, photo

        flash[:notice] = "A new photo has been added to your album!"
        redirect_to :controller => :photos, :action => :index, :id => session[:user_id]
	    else
	    	flash[:error] = "Error adding photo. Try once more!"
	    	redirect_to :action => :new
	     end
    else
    	flash[:error] = "You must choose a photo for uploading to initiate!"
    	redirect_to :action => :new
     end
  end

  def tag
    @photo = Photo.find_by_id(params[:id])
    if not @photo
      flash[:error] = "Invalid photo ID. Please try again.";
      redirect_to :action => :index, :id => session[:user_id]
      return
    end

    if session["user_id"].nil?
      flash[:error] = "You must be logged in to tag photos.";
      redirect_to :controller => :users, :action => :login
      return
    end
  end

  def post_tag
    @tag = Tag.new
    @tag.photo_id = params[:id]
    @tag.user_id = params[:tag][:user_id]
    @tag.left = params[:tag][:left]
    @tag.top = params[:tag][:top]
    @tag.width = params[:tag][:width]
    @tag.height = params[:tag][:height]

    if @tag.save
      flash[:notice] = "#{User.find_by_id(@tag.user_id).full_name} tagged!";
    else
      flash[:error] = @tag.errors.full_messages.first
    end

    redirect_to :action => :tag, :id => params[:id]
  end

  def search
    @p_result = Photo.find_by_query(params[:query])
    render :partial => "search"
  end

end



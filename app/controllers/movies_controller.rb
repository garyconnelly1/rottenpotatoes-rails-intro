class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end####

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
  
   @all_ratings = Movie.pluck(:rating).uniq
  
    
    @sort = params[:sort] ## Sort the movies based on the title.
    if @sort == 'title'
      @movies = Movie.order("title ASC")
    elsif @sort == 'release_date' ## Part 1 complete.
      @movies = Movie.order("release_date ASC")
    else
      @movies = Movie.all
    end
    
    params[:ratings].nil? ? @t_param = @all_ratings : @t_param = params[:ratings].keys
    @movies = Movie.where(rating: @t_param).order(@sort) ## Part 2 Complete.
    
    session[:ratings] = session[:ratings] || {'G'=>'','PG'=>'','PG-13'=>'','R'=>''} ## Trying session hash.
    @t_param = params[:ratings] || session[:ratings]
    session[:sort] = @sort
    session[:ratings] = @t_param 
    @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])
  end
  
 ###

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

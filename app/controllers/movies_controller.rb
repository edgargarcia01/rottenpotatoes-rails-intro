class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @movies = Movie.all
    @filtered_by_ratings = nil
    
    sessionState = false
    

    #sort
=begin
    if params[:sorted]
      @sorted = params[:sorted]
      session[:sorted] = params[:sorted]
    elsif session[:sorted]
      @sorted = session[:sorted]
      sessionState = true
    else
      @sorted = nil
    end
=end 

    
    #ratings filter
    if params[:ratings]
      @filtered_by_ratings = params[:ratings]
      #session[:ratings] = params[:ratings]
    #elsif session[:ratings]
      #@filtered_by_ratings = session[:ratings]
      #sessionState = true
    #elsif params[:ratings].nil?
      #@filtered_by_ratings = nil
      #session[:ratings] = nil
    else
      @filtered_by_ratings = @all_ratings
    end
    
    
    if sessionState
      flash.keep
      #redirect_to movies_path(:sorted=>session[:sorted],:ratings=>session[:ratings])
      redirect_to movies_path(:ratings=>session[:ratings])
    end
    
    #@movies = Movie.where(:rating => @filtered_by_ratings).order(@sorted)
    
    @movies = Movie.where(:ratings => @filtered_by_ratings)
  end

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

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
    #session stays throughout different requests
    #params is for one request only 
    #rails server -b 0.0.0.0
 
    @all_ratings = Movie.possibleRatings
    if params[:ratings]
        @ratings = params[:ratings]
        session[:ratings] = params[:ratings] 
    else 
        @ratings = session[:ratings]
    end 
      
    @ratings = Hash[@all_ratings.collect {|rating| [rating, 1]}] unless @ratings  
    chosenRatings = @ratings.keys
      
    if params[:sortby]
        session[:sortby] = params[:sortby]
        sortType = session[:sortby]
    else 
        sortType = ''
    end 
      
    if sortType == 'title'
        @title_hilite = 'hilite'
        @movies = Movie.where(rating: chosenRatings).order(:title)
    elsif sortType == 'release_date'
        @release_hilite = 'hilite'
        @movies = Movie.where(rating: chosenRatings).order(:release_date)
    else 
        @movies = Movie.where(rating: chosenRatings)
    end 
      
    if (session[:ratings] != params[:ratings]) || (session[:sortby] != params[:sortby])
        flash.keep
        redirect_to movies_path(:sortby => session[:sortby], :ratings => session[:ratings])
    end
    
    
    #if session[:sortby]
        #@movies = Movie.where(rating: chosenRatings).order(session[:sortby])
    #else 
        #@movies = Movie.where(rating: chosenRatings)
    #end 
        
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

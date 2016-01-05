class MoviesController < ApplicationController
  @@all_ratings = Movie.all_ratings
  @@filt = Movie.all_ratings
  def self.all_ratings
    @@all_ratings
  end
  def self.filt
    @@filt
  end
  def self.filt= (rankArr)
    @@filt = rankArr
  end
  
  def movie_params
    #debugger
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  #def index
  #  @movies = Movie.all  #original code
  #end
  
  def index
    #debugger
    if params["order"] != nil
      session["order"] = params["order"]
    end
    if params[:ratings] != nil 
      @@filt = params[:ratings].keys
      session["filt"] = @@filt
    else
      @@filt = session["filt"]
    end
    if session["order"] == "title"
      @movies = Movie.order(:title).where(rating: @@filt)
    elsif session["order"] == "release_date"
      @movies = Movie.order(:release_date).where(rating: @@filt)
    else
      @movies = Movie.where(rating: @@filt)
    end
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

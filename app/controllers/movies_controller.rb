class MoviesController < ApplicationController
  attr_accessor :all_ratings
  attr_accessor :filt
 
  def movie_params
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
    @all_ratings = Movie.all_ratings
    if @filtr == nil
      @filtr = Movie.all_ratings
    end
    if params["order"] != nil
      session["order"] = params["order"]
    #elsif session["order"] != nil
     # redirect_to movies_path("order" => session["order"])
      #return
    end
    if params[:ratings] != nil 
      @filtr = params[:ratings].keys
      session["ratings"] = params[:ratings]
    elsif session["ratings"] != nil
      @filtr = session["ratings"].keys
      redirect_to movies_path(:ratings => session["ratings"])
    end
    if session["order"] == "title"
      @movies = Movie.order(:title).where(rating: @filtr)
    elsif session["order"] == "release_date"
      @movies = Movie.order(:release_date).where(rating: @filtr)
    else
      @movies = Movie.where(rating: @filtr)
    end
  end
  
  def indexOld
    #debugger
    @all_ratings = Movie.all_ratings
    if @filtr == nil
      @filtr = Movie.all_ratings
    end
    if params["order"] != nil
      session["order"] = params["order"]
    end
    if params[:ratings] != nil 
      @filtr = params[:ratings].keys
      session["filtr"] = @filtr
    elsif session["filtr"] != nil
      @filtr = session["filtr"]
    end
    if session["order"] == "title"
      @movies = Movie.order(:title).where(rating: @filtr)
    elsif session["order"] == "release_date"
      @movies = Movie.order(:release_date).where(rating: @filtr)
    else
      @movies = Movie.where(rating: @filtr)
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

module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  def show
    @all_ratings = Movie.all_ratings
  end
end

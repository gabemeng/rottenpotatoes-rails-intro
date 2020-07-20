class Movie < ActiveRecord::Base
    
    def self.possibleRatings
        ['G', 'PG', 'PG-13', 'R']
    end 
    
    def self.with_ratings(chosenRatings)
        Movie.where(rating: chosenRatings)
    end 

 
end

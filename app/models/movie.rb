class Movie < ActiveRecord::Base
    def self.all_ratings
        Movie.unique.pluck(:rating)
    end
end

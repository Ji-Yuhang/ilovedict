#!/usr/bin/env ruby
#require "awesome_print"
require_relative "abstract_information"
class Weight
    attr_accessor :data, :last_index, :count, :will_index
    def initialize
        willCompute
    end

    def willCompute
        @will_index  = @last_index + @count * @count
    end
end

class HowToReview
    def initialize
        @reviewRecord = []
        @reviewList = []
    end
end

class AB < HowToReview
    
end

class Review
    def initialize
    end
    def push
    end
    def next
    end
    def test
    end
    
end

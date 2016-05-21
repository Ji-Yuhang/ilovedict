#!/usr/bin/env ruby

class Interval
  ARRAY = [1,2,3,4,5,6,7,8,14,21,56,84,168,336,336,672,672,1008]
  class << self
    def diff(range)
      raise "Interval::diff argument must is a object of Range" if range.class != Range
      ARRAY[range.min]
    end
  end
end

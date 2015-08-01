#!/usr/bin/env ruby
#require "awesome_print"

class AbstarctInfomation
    def initialize
    end
    def parse
    end
    def save
    end
end

class AnkiObject
end

class TextAnkiObject < AnkiObject
    attr_accessor :front :back :detail
end

class AnkiInformation < AbstarctInfomation
    def intialize
        @ankiObj = AnkiObject.new
    end
    end
    def parse

    end

    def save

    end
end





#!/usr/bin/env ruby
require "awesome_print"

require_relative "review"
require_relative "shanbay"

wordList = []
File.open("unknown.txt") do |io|
    io.each_line do |line|
        word = line.chomp
        wordList.push word
        break if wordList.size > 10
    end
end

collection = Model::Collection.new
wordList.each_with_index do |word, index|
    c = Model::Card.new
    c.cardId = index
    c.front = word
    data = Shanbay.shanbayword word
    next if data.nil? 
    pron = data["pron"]
    next if pron.nil?
    if !pron.empty?
        pron =  "\t [ " + pron + " ]"
        pron+= "\n"
    end


    c.back = pron + data["cn_definition"]["defn"]
    c.detail = data["en_definition"]["defn"]
    c.mp3 = data["us_audio"]
    collection.addCard c
end

#reviewRecords = collection.reviewRecords
strategy = Control::RandomReview.new
strategy.setCollection collection

show = View::ShowCard.new
show.review(strategy)


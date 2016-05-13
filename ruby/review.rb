#!/usr/bin/env ruby
require "awesome_print"
require "Qt"
module Model 
    class Card # view of information
        attr_accessor :cardId, :front, :back, :detail, :mp3
        def initialize
        end
    end

    class ReviewRecord # meta record of review
        attr_accessor :card, :cardId, :familiarity, :lastReviewTime, :historyReviewTime 
    end

    class Collection # collection of cards
        attr_accessor :cards, :reviewRecords
        def initialize
            @cards = []
            @reviewRecords = []
        end
        def addCard(card)
            @cards.push card
            record = ReviewRecord.new
            record.cardId = card.cardId
            record.familiarity = 0
            record.lastReviewTime = 0
            record.historyReviewTime = 0
            record.card = card
            @reviewRecords.push  record
        end
        def deleteCard(cardId)
        end
        def findCard(cardId)
            @cards[cardId]
        end
        def updateCard(cardId,card)
        end
    end
end

module Control
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
        attr_accessor :reviewRecords
        def initialize
            @reviewRecords = [] # record cycle
            @nextIndex = 0;
            
        end
        def setCollection(collection)
            @collection = collection
            @reviewRecords = collection.reviewRecords
            ap @reviewRecords
        end
        def nextRecord(currentCardId) # select highest important card to review
            if currentCardId.nil?
                #ap "next record of " + currentCardId.to_s
                nextIndex = 0
                #ap @reviewRecords.first
                return @reviewRecords.first
 
            else
                #ap "next record of " + currentCardId.cardId.to_s
            end
            if currentCardId == nil
                nextIndex = 0
                #ap @reviewRecords.first
                return @reviewRecords.first
            end
            min = @reviewRecords.first.familiarity;
            noChange = true
            @reviewRecords.each_with_index do |record, index|
                if min > record.familiarity
                    min = record.familiarity
                    @nextIndex = index
                    noChange = false
                end
            end
            @nextIndex = 0 if noChange
            #ap "min:"+min.to_s
            #ap "index:"+@nextIndex.to_s
            record = @reviewRecords[@nextIndex]
            return record
        end

        def saveRecord(currentCardId, feedback) # save user's feedback
            willindex = -1;
            @reviewRecords.each_with_index do |record,index|
                if record.cardId == currentCardId.cardId
                    willindex = index
                    break
                end
            end
            #ap "save " + willindex.to_s
            #ap currentCardId
            @reviewRecords[willindex].familiarity += 1 if willindex != -1
            if willindex != -1
                @reviewRecords[willindex].familiarity += feedback.to_i
                #ap @reviewRecords[willindex]
            end
            willindex
        end
        def saveAllRecord
        end
    end
    class RandomReview < HowToReview
    end
    class StrongWillReview < HowToReview # must remember all records
        def nextRecord(currentCardId)
        end
    end
    class TodayReview < HowToReview
    end
    class WeekReview < HowToReview
    end
    class MonthReview < HowToReview
    end
    class SeasonReview < HowToReview
    end
    class YearReview < HowToReview
    end
end

module View
    class ShowCard
        def initialize
            @app = Qt::Application.new(ARGV)
            @widget = Qt::Label.new
            @widget.resize 400, 300
        end
        def setReviewStrategy(strategy)
            @strategy = strategy
        end
        def review(strategy)
            setReviewStrategy strategy
            nextindex = nil
            loop {
                record = @strategy.nextRecord nextindex
                if record.nil?
                    ap "have finished today's review"
                    break
                end
                card = record.card
                ap card.front
                ap "0:Forget, 1:Hard, 2:Mid, 3:Easy, 4:Too Easy, 5:Never See"
                @widget.text = card.front
                @widget.show
                @app.processEvents
                feedback = gets
                save record, feedback
                nextindex = record

                @app.processEvents
            }
            #@app.exec
        end
        def next

        end
        def save(record, feedback)
            @strategy.saveRecord record, feedback
            puts record.card.back if record.card.back
            puts record.card.detail if record.card.detail
            if record.card.mp3.nil?
                system "mplayer " + record.card.mp3 + " >/dev/null 2>&1" if record
            end

        end

        def saveAll

        end
    end
end

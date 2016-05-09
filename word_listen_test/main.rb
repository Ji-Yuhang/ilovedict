#require_relative 'collins_to_memo'
require 'open-uri'
require 'json'
module ShanbayHttp
    def http_data(word)
        getwordui = "https://api.shanbay.com/bdc/search/?word=#{word}"
        open( getwordui) do |io|
            jsonstr =  io.read
            json = JSON.parse(jsonstr)
            data = json["data"]
            return data
        end
        return nil
    end
    def local_http_data(word)
        getwordui = "http://localhost/shanbayword/?word=#{word}"
        open( getwordui) do |io|
            jsonstr =  io.read
            #Iconv.conv('gbk','utf-8',result)
            json = JSON.parse(jsonstr)
            #data = json["data"]
            return json
        end
        return nil
    end
    module_function :http_data, :local_http_data
end

def parse_shanbay_data(data)
    cndef = data["cn_definition"]
    endef = data["en_definition"]
    word = data["content"]
    pron = data["pron"]
    printf word
    if !pron.empty?
        print  "\t [ " + pron + " ]"
        print "\n"
    end

    puts cndef["defn"]
    puts endef["defn"]

    audio = data["us_audio"]
    #system "mplayer " + audio + " >/dev/null 2>&1"
    exec("mplayer " + audio + " >/dev/null 2>&1") if fork.nil?

    #localmdeid = "/Users/jiyuhang/Documents/Anki/用户1/collection.media/#{word}.mp3"
    #    pid = fork { exec 'wget',audio,'-o',localmdeid }
    #    pid = fork{ exec 'afplay', localmdeid }

end

def source
  wordlist = []
  File.open '1.txt' do |io|
    io.each do |line|
      word = line.strip
      wordlist << word
    end
  end
  wordlist = wordlist[1..10]
end

def strategy
  [0,1,2,3,5,7,9,11,15,30,45,60,90,120,240,480]
end

class Queue
  attr_accessor :list, :strategy

  def initialize
    @index = -1 
    @list=[]
    @map = {}
    @strategyMap = {}
  end

  def list=(list)
    @list = list
    list.each_with_index do |key, index|
      @map[key] = index
      @strategyMap[key] = index
    end
  end

  def next
    @index += 1
  end

  def push

  end

  def show
    value = list[@index]
    data = ShanbayHttp::http_data value 
    audio = data["us_audio"]
    exec("mplayer " + audio + " >/dev/null 2>&1") if fork.nil?

    #puts "#{@map[value]}   #{value}"
    #parse_shanbay_data data
  end

  def score(v)
    current = list[@index]
    posit = @strategyMap[current] + strategy[v]
    @strategyMap[current] += strategy[v]
    list.insert @index + posit, current
  end

  private
    

end

def queue
end

def main
  queue = Queue.new
  queue.list = source
  queue.strategy = strategy

  #p queue.list
  
  while queue.next
    queue.show
    score = gets
    si =  score.to_i
    si = 1 if si == 0
    queue.score si
  end
   
end

if __FILE__ == $0
    main
end


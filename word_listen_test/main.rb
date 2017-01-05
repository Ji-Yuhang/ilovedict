#require_relative 'collins_to_memo'
if ENV['_system_name'] != "OSX"
  ENV['SSL_CERT_FILE'] ="C:\\OpenSSL-Win64\\bin\\PEM\\cacert.pem"
end
require 'open-uri'
require 'json'
require 'awesome_print'
require 'nokogiri'
require 'uri'
module ShanbayHttp
  $ShanbayCache = {}
  def http_data(word)
    return $ShanbayCache[word] if $ShanbayCache.include? word

    getwordui = URI.escape("https://api.shanbay.com/bdc/search/?word=#{word}")
    open( getwordui) do |io|
      jsonstr =  io.read
      json = JSON.parse(jsonstr)
      data = json["data"]
      $ShanbayCache[word] = data
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
  wordlist = File.read('collins_1_list_1.txt').split("\n").map(&:strip)[0..30]
  #ap wordlist
  return wordlist
  File.open 'collins_1_list_1.txt' do |io|
    io.each do |line|
      word = line.strip
      wordlist << word
    end
  end
  wordlist = wordlist.shuffle[1..10]
end

def strategy
  [0,1,2,3,5,7,9,11,15,30,45,60,90,120,240,480]
end

def videos(word)
  url = "http://dict.youdao.com/example/mdia/video/#{word}/#keyfrom=dict.main.sentence.mdia.video"
  doc = Nokogiri::HTML(open(url))
  videos = doc.css("a[class='play log-js']")
  videos.each do |video|
    href =  video['href']
    movieurls = href.scan /http.*docid=[-\d]*/
    #ap href
    movieurl =  movieurls.first
    ap movieurl
    exec("mplayer " + movieurl + " >/dev/null 2>&1") if fork.nil?
    gets
  end
end
def split_sentence(sentence)
  sentence.split.map{|c| d = c.downcase; d = d.strip; d = d.gsub /[^\w]/, ''}.select{|w| !w.empty?}
end
$existWords=[]
def audios(word)
  url = "http://dict.youdao.com/example/mdia/audio/#{word}/#keyfrom=dict.main.sentence.mdia.video"
  doc = Nokogiri::HTML(open(url))
  videos = doc.css("a[class='sp humanvoice humanvoice-js log-js']")
  videos.each do |video|
    href =  video['data-rel']
    movieurls = href.scan /http.*docid=[-\d]*/
    #ap href
    movieurl =  movieurls.first
    text= video.parent.text.strip
    words = split_sentence text
    words.each do |w|
      data = ShanbayHttp::http_data w 
      next if data.nil?
      next if data.empty?
      next if $existWords.include? w
      $existWords << w
      next if data["us_audio"].nil?
      exec("mplayer " + data["us_audio"] + " >/dev/null 2>&1") if fork.nil?
      gets
      ap data["content"]+"    " + data["pron"]
      #ap data["en_definitions"]
      ap data["definition"]
      gets

    end
    ap words
    ap movieurl
    exec("mplayer " + movieurl + " >/dev/null 2>&1") if fork.nil?
    gets
    ap text
    gets
    exec("mplayer " + movieurl + " >/dev/null 2>&1") if fork.nil?
    gets
  end
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
    exec("mplayer " + audio + " >/dev/null 2>&1") if fork.nil? if audio

    #puts "#{@map[value]}   #{value}"
    #parse_shanbay_data data
  end


  def show_answer
    current = list[@index]
    data = ShanbayHttp::http_data current 
    ap data["pron"] + "        " + data["content"]
    #ap data["cn_definition"]["defn"]
  end

  def score(v)
    current = list[@index]
    posit = @strategyMap[current] + strategy[v]
    list.insert @index + posit, current
    @strategyMap[current] += strategy[v]
    #audios current
    #p current
  end

  private
    

end



def main
  queue = Queue.new
  queue.list = source
  queue.strategy = strategy

  #p queue.list
  
  while queue.next
    queue.show

    ap "查看答案 Enter "
    gets
    queue.show_answer
    ap " 输入分数 [1..5] Enter"
    score = gets
    si =  score.to_i
    ap si
    #ap si.class
    si = 2 if si == 0
    queue.score si
  end
   
end

if __FILE__ == $0
    main
end


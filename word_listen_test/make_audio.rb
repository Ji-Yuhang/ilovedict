require 'open-uri'
require 'json'
require 'awesome_print'
require 'nokogiri'
require 'active_record'
require 'sqlite3'
require 'byebug'
require 'tempfile'
ActiveRecord::Base.establish_connection :adapter => "sqlite3",
:database => "./audio.sqlite3"
 
class Audio < ActiveRecord::Base
# word
# sentence
# url
# filename
# sentence_html
# blob
end

def get_all_words_from_collins(file)
  wordlist = []
  File.open "collins#{file}.txt" do |io|
    io.each do |line|
      word = line.strip
      wordlist << word
    end
  end
  wordlist
end

def audios(word)

  word.gsub! ' ', '%20'
  url = "http://dict.youdao.com/example/mdia/audio/#{word}"
  doc = Nokogiri::HTML(open(url))
  videos = doc.css("a[class='sp humanvoice humanvoice-js log-js']")
  videos.each do |video|
    href =  video['data-rel']
    movieurls = href.scan /http.*docid=[-\d]*/
    movieurl =  movieurls.first
    text= video.parent.text.strip

    filename = movieurl.scan(/[-\d]+/).first
    filename.gsub! /-/, '0'
    filename += ".mp3"

    ap text
    data = Audio.new
    data.word=word
    data.url=movieurl
    #next if Audio.where(word: word).size > 0
    data.filename=filename
    data.sentence=text
    #data.sentence_html=text
    temp = open(movieurl)
    mp3data = temp.read
    #exec("mplayer " + temp.path + " >/dev/null 2>&1") 
    data.audio_data = mp3data
    #ap data
    #ap movieurl
    #temp.unlink
    data.save!
  end
end

def main
  wordlist = get_all_words_from_collins 3
  number = 0
  all = wordlist.count
  wordlist.each do |word|
    number += 1
    audios word
    ap "#{number} / #{all}    => #{word}"
  end
end

main




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
  begin
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
  rescue
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

def play_audio(audio_data)
  t = Tempfile.new
  t.write audio_data
  t.close
  #exec("mplayer " + t.path + " >/dev/null 2>&1") if fork.nil?
  `mplayer #{t.path} >/dev/null 2>1`

end
def split_sentence(sentence)
  sentence.split.map{|c| d = c.downcase; d = d.strip; d = d.gsub /[^\w]/, ''}.select{|w| !w.empty?}
end

def cloze(sentence, wordlist)
  temp_sentence = sentence.clone
  sentence_words = split_sentence temp_sentence
  will_cloze_words = sentence_words.select do |word|
    wordlist.include? word
  end

  will_cloze_words.each do |word|
    temp_sentence.gsub! " "+word, " "+"_"*word.size  
    temp_sentence.gsub! " "+word.capitalize, " "+"_"*word.size  
    temp_sentence.gsub! word.capitalize, " "+"_"*word.size  
  end

  [temp_sentence,will_cloze_words]
end
def test_data
  wordlist = []
  wordlist += get_all_words_from_collins(4)
  wordlist += get_all_words_from_collins(3)
  #wordlist += get_all_words_from_collins(2)
  #wordlist += get_all_words_from_collins(1)
  count = Audio.count
  list = Audio.find rand(count)
  sentence = list.sentence
  audio =  list.audio_data

  s = cloze(sentence, wordlist)
  s1, s2 = s
  p s1
  originS2= s2
  #ap s2.join(",")
  play_audio audio
  ap "cloze ... "
  
  #w = gets
  while !s2.empty?
    w = gets
    w.strip!
    break if w =="Show"
    if w == "Help"
       ap `ruby /Users/jyd/vimrc/shanbay.rb #{s2[0]} only_english`
    end
    if s2.include? w
      s2.delete w
      wordlist.delete w
      ap "✓ " 
    else
      ap "x => #{w}" 
    end
    s = cloze(sentence, wordlist)
    s1, s2 = s
    p s1

    ap "cloze ... "
    play_audio audio
  end
  ap originS2
  ap sentence
  play_audio audio
end

test_data
#main




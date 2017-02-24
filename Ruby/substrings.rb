dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

def substring (string, dictionary)
  words = Hash.new
  string.downcase!
  
  dictionary.each do |word|
    if string.include?(word)
      words[word] = string.scan(word).length
    end
  end
  words
end

substring("below", dictionary)
class SpellCheck
  
  def initialize(language = 'en_US')
    
    @speller = Aspell.new(language)
    @speller.set_option("ignore-case", "true")
    @speller.suggestion_mode = Aspell::NORMAL    
    
  end
  
  def check_words(words)    
    words.select { |word| !@speller.check(word) }    
  end
  
  def suggestions(word)
    @speller.suggest(word)
  end
  
end

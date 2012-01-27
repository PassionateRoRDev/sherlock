class String

  def self.random(length)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    random_string = ""
    1.upto(length) { |i| random_string << chars[rand(chars.size-1)] }
    return random_string
  end

  def web_safe
    self.gsub(/([a-z])([A-Z])/, '\1_\2').downcase.gsub(/[^\w]/, '_').gsub(/_{2,}/, '_')
  end

end

require "greek_string/version"

class GreekString
  require 'json'
  require 'greek_string/letter'

  attr_reader :letters
  def initialize
    l = File.open('./data/gr_letters.json', 'r') { |f| f.read }
    @json = JSON.parse(l)
    @letters = []
    @res = []
    create_letter_objects
  end

  def create_letter_objects
    @json.each do |letter, obj|
      klass = letter.capitalize
      Object.const_set(klass, Class.new(GreekString::Letter) {})
      @letters << GreekString::Letter.const_get(klass).new(Hash[letter, obj])
    end
  end

  # returns all greek letters upper and lower case
  def all
    @json.flat_map {|letter,obj| obj["letters"]}
  end

  # possible values for args: vowel, consonants, double_consonants,
  # returns upper and lower case
  def find(type)
    res = @json.flat_map do |name, obj|
      if obj["type"] == type
        obj["letters"]
      end
    end
    res.compact
  end

  def find_lower_case
    find_key(@json, "lower")
  end

  def find_upper_case
    find_key(@json, "upper")
  end

  private

  # finds a given key in a nested hash and returns its string value.
  # Keeps on searching if value is a hash
  def find_key(hsh, key)
    hsh.each do |k, value|
      if k == key
        @res << value
        #require 'pry'; binding.pry
      elsif value.is_a? Hash
        find_key(value, key)
      end
    end
    @res
  end
end

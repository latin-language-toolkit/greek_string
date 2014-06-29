require "greek_string/version"

class GreekString
  require 'json'
  require 'greek_string/letter'
  require 'greek_string/container'

  def initialize
    l = File.open('./data/gr_letters.json', 'r') { |f| f.read }
    @json = JSON.parse(l)
    GreekString.initiate_container
    create_letter_objects
  end

  def letters
    GreekString.letters
  end

  private

  def self.initiate_container
    @letters = GreekString::Container.new
  end

  def self.letters
    @letters
  end

  def class_hierarchy
    GreekString::Letter
  end

  def create_letter_objects
    @json.each do |letter, obj|
      klass = class_hierarchy.const_set(letter.capitalize, Class.new(class_hierarchy))
      klass.new(Hash[letter, obj])
    end
    require 'pry'; binding.pry
  end
end

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
      klass = class_const(letter.capitalize)
      klass.new(Hash[letter, obj])
    end
    require 'pry'; binding.pry
  end

  def class_const(const)
    if class_hierarchy.const_defined?(const)
      class_hierarchy.const_get(const)
    else
      class_hierarchy.const_set(const, Class.new(class_hierarchy))
    end
  end

  def method_missing(meth, *args)
    res = letters.flat_map { |l| l.to_s(*args) if l.send(meth) }
    res.delete_if { |el| !el == true }
  end
end

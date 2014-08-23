require "greek_string/version"

class GreekString
  require 'json'
  require 'greek_string/letter'
  require 'greek_string/container'

  def initialize
    path = File.expand_path('../../data/gr_letters.json', __FILE__)
    l = File.open("#{path}", 'r') { |f| f.read }
    @json = JSON.parse(l)
    GreekString.initiate_container
    create_letter_objects
  end

  def all
    GreekString.all
  end

  def selection
    GreekString.selection
  end

  private

  def self.initiate_container
    @all = GreekString::Container.new
  end

  def self.all
    @all
  end

  def self.selection
    GreekString::Container.new(@all.to_a.clone)
  end

  def class_hierarchy
    GreekString::Letter
  end

  def create_letter_objects
    @json.each do |letter, obj|
      klass = class_const(letter.capitalize)
      klass.new(Hash[letter, obj])
    end
  end

  def class_const(const)
    if class_hierarchy.const_defined?(const)
      class_hierarchy.const_get(const)
    else
      class_hierarchy.const_set(const, Class.new(class_hierarchy))
    end
  end
end

class GreekString
  class Container
    require 'forwardable'
    extend Forwardable

    def_delegators :@container, :[], :<<, :each, :map

    def initialize
      @container = []
    end

    def letters
      @container.flat_map(&:letters)
    end

    def vowels
      @container.flat_map(&:vowel)
      self
    end

    def upper
      @container.map(&:upper)
    end

    def to_a
      @container
    end

  end
end

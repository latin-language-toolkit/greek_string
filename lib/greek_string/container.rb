class GreekString
  class Container
    require 'forwardable'
    extend Forwardable

    def_delegators :@container, :[], :<<, :each, :map, :flat_map

    def initialize
      @container = []
    end

    def to_a
      @container
    end

    def to_s(type)
      @container.flat_map(&type)
    end

  end
end

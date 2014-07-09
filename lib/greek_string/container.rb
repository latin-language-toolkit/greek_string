class GreekString
  class Container
    require 'forwardable'
    extend Forwardable

    def_delegators :@container, :[], :<<, :each, :map, :flat_map

    def initialize(letters=nil)
      @container = letters || []
    end

    def to_a
      @container
    end

    def to_s(*args)
      @container.flat_map { |letter| letter.to_s(args) }
    end

    def select_by_letter(*letters)
      letters.each do |letter|
        @container.select! { |l| l if l.kind_of?(GreekString::Letter.const_get(letter.to_s)) }
      end
      self.class.new(@container)
    end

    def select_by_type(*meths)
      meths.each do |meth|
        @container.select! { |l| l if l.send(meth) }
      end
      self.class.new(@container)
    end

    def select_by_string(*strings)
      strings.each do |string|
        @container.select! { |l| l if (l.upper == string || l.lower == string) }
      end
      self.class.new(@container)
    end
  end
end

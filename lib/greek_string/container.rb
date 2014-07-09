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

    def select_by_type(*meths)
      meths.each do |meth|
        @container.map! { |l| l if l.send(meth) }.flatten!
        @container.delete_if { |el| !el == true }
      end
      self.class.new(@container)
    end
  end
end

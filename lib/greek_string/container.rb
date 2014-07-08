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

    def method_missing(meth, *args)
      @container.map! { |l| l if l.send(meth) }.flatten!
      @container.delete_if { |el| !el == true }
      self.class.new(@container)
    end
  end
end

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

    def to_a
      @container
    end

    def to_s(type)
      @container.flat_map(&type)
    end

    def methods(meth)
      @container.map! do |letter|
        if letter.instance_variable_defined?("@" + meth.to_s)
          letter
        end
      end
      @container.compact
      self
    end

    def method_missing(meth)
      blk = Proc.new { methods(meth) }
      self.class.send(:define_method, meth, &blk)
    end

  end
end

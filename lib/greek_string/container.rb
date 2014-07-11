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

    def letter(*letters)
      letters.each do |let|
        @container.select! { |l| l if l.kind_of?(GreekString::Letter.const_get(let.to_s)) }
      end
    end

    def type(*types)
      types.each do |ty|
        @container.select! { |l| l if l.send(ty) }
      end
    end

    def string(*strings)
      strings.each do |str|
        @container.select! { |l| l if (l.upper == str || l.lower == str) }
      end
    end

    def method_missing(meth, *args)
      if meth.match(/^select_by_(.*)/)
        self.send($1, *args)
        self.class.new(@container)
      else
        super
      end
    end
  end
end

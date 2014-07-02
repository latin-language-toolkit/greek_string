class GreekString
  class Letter
    def initialize(letter_hsh)
      @hash = letter_hsh
      @inner_hsh = @hash[name]
      create_inst_var(@inner_hsh)
      create_class
    end

    def name
      @hash.keys[0]
    end

    def to_s(*args)
      res = []
      if args.empty?
        args << :lower
      end
      args.each do |type|
        res << self.send(type.to_sym)
      end
      res
    end

    private

    def create_inst_var(hsh)
      if hsh.is_a? Hash
        hsh.keys.each do |var|
          if var =~ /plain|diacritics/
            next
          else
            blk = Proc.new { hsh[var] }
            self.class.send(:define_method, var,  &blk)
            create_inst_var(hsh[var])
          end
        end
      end
    end

    def class_hierarchy
      GreekString::Letter.const_get(name.capitalize)
    end

    def class_const(const)
      if const == "Iota" && self.class.to_s == "GreekString::Letter::Omega"
        class_hierarchy.const_set(const, klass_body)
      elsif class_hierarchy.const_defined?(const)
        class_hierarchy.const_get(const)
      else
        class_hierarchy.const_set(const, klass_body)
      end
    end

    def create_class
      letter_types = { "plain" => @inner_hsh["plain"]}.merge(to_be_merged)
      letter_types.each do |type, hsh|
      klass = class_const(camel_case(type))
        GreekString.selection << klass.new(hsh, type)
      end
    end

    def to_be_merged
      @inner_hsh["diacritics"] || {}
    end

    def camel_case(string)
      string.split("_").map { |el| el.capitalize }.join
    end

    def klass_body
      Class.new(class_hierarchy) do
        def initialize(hash, type)
          @type = type
          create_type_inst_var
          create_inst_var(hash)
        end

        def create_type_inst_var
          separate_types.each do |dia|
            instance_variable_set("@#{dia}", true)
            self.class.class_eval("attr_reader :#{dia}")
          end
        end

        def separate_types
          diacritics = []
          if @type.match('_')
            diacritics = @type.split('_')
          end
          diacritics << @type
        end

        def method_missing(meth, *args)
          if meth.match(/^only_(.*)/)
            if $1 == @type
              send(@type, *args)
            else
              false
            end
          end
        end
      end
    end

    def method_missing(meth)
      false
    end
  end
end

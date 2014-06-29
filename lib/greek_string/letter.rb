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

    private

    def create_inst_var(hsh, outer_key=nil)
      if hsh.is_a? Hash
        hsh.keys.each do |var|
          if outer_key =~ /plain|diacritics/
            next
          else
            inst_var_name = create_inst_var_name(var, outer_key)
            instance_variable_set("@#{inst_var_name}", hsh[var])
            self.class.class_eval("attr_accessor :#{inst_var_name}")
            create_inst_var(hsh[var], var)
          end
        end
      end
    end

    def class_hierarchy
      GreekString::Letter.const_get(name.capitalize)
    end

    def create_class
      letter_types = { "plain" => @inner_hsh["plain"]}.merge(to_be_merged)
      letter_types.each do |type, hsh|
      klass = class_hierarchy.const_set(camel_case(type), klass_body)
        GreekString.letters << klass.new(hsh, type)
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
          instance_variable_set("@#{type}", true)
          create_inst_var(hash)
        end
      end
    end

    def create_inst_var_name(var, outer_key)
      if self.instance_variable_defined?("@" + var)
        outer_key + '_' + var
      else
        var
      end
    end

    def method_missing(meth)
      name = meth.to_s
      if name.match(/_/)
        names_array = name.split('_').sort
        names_array.each do |n|
          if n.match(/upper|lower/) && (names_array.last != n)
            names_array.delete(n)
            names_array.push(n)
          end
        end
        new_meth = names_array.join("_")
        self.send(new_meth)
      else
        super
      end
    end
  end
end

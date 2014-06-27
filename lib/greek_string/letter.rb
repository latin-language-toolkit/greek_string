class GreekString
  class Letter
    def initialize(letter_hsh)
      @hash = letter_hsh
      create_inst_var(@hash[name])
    end

    def name
      @hash.keys[0]
    end

    private

    def create_inst_var(hsh, outer_key=nil)
      if hsh.is_a? Hash
        hsh.keys.each do |var|
          inst_var_name = create_inst_var_name(var, outer_key)
          instance_variable_set("@#{inst_var_name}", hsh[var])
          self.class.class_eval("attr_accessor :#{inst_var_name}")
          create_inst_var(hsh[var], var)
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

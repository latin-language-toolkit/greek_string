class GreekString
  class Letter
    def initialize(letter_hsh)
      @hash = letter_hsh
      create_methods(@hash)
    end

    private

    def create_methods(hsh, outer_key=nil)
      if hsh.is_a? Hash
        hsh.keys.each do |meth|
          blk = Proc.new { hsh[meth] }
          method_name = create_method_name(meth, outer_key)
          self.class.send(:define_method, method_name, &blk )
          create_methods(hsh[meth], meth)
        end
      end
    end

    def create_method_name(meth, outer_key)
      if self.class.method_defined?(meth)
        outer_key + '_' + meth
      else
        meth
      end
    end
  end
end

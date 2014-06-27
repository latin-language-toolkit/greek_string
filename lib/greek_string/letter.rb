class GreekString
  class Letter
    def initialize(letter_hsh)
      @hash = letter_hsh
      create_methods(@hash[name])
    end

    def name
      @hash.keys[0]
    end

    def create_methods(hsh)
      if hsh.is_a? Hash
        hsh.keys.each do |meth|
          blk = Proc.new { hsh[meth] }
          self.class.send(:define_method, meth, &blk )
          create_methods(hsh[meth])
        end
      end
    end
  end
end

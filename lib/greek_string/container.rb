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

    def select_by_types(*args)
      args.each do |arg|
        select_by_type(arg)
      end
      self.class.new(@container)
    end

    def method_missing(meth, *args)
      if meth.match(/^select_by_(.*)/)
        self.send($1, *args)
        self.class.new(@container)
      else
        super
      end
    end

    def get_keys
      pairs = { asper: "shift-'", grave: "'", lenis: "shift-:", acute: ":", circumflex: "[", iota: "]"}
      res = {};
      @container.each do |letter|
        [:upper, :lower].each do |cas|
          keys = []
          types = letter.type.split('_')
          types.each do |t|
            pairs.each do |k, v|
              if t == k.to_s
                keys << v
              end
            end
          end
          keys << latin(letter, cas)
          new_key = keys.join('-')
          res[letter.to_s(cas)] = new_key
        end
      end
      res#.each_with_object({}) { |hsh, (k,v)| hsh[v] = k if v}
    end

    def write_to_file
      x = []
      get_keys.each { |k,v| x << "\"#{v}\" : \"#{k}\"" }
      x.uniq!
      File.open('./lib/greek_string/keys2.rb', 'w+') { |f| x.each {|el| f.write("#{el},\n" ) } }
    end

    def latin(letter, cas)
      l = letter.phoneme.gsub(/^h/i, "")
      if cas == :upper && l
        l.upcase!
      elsif cas == :lower
        l.downcase!
      end
      l
    end
  end
end

module Bio::BGZF
  
  class Reader
    include Bio::BGZF

    attr_reader :f

    def initialize(f)
      @f = f
      @cur_block = nil
    end

    def tell
      f.tell << 16
    end

    def read_block
      decompress_block(f)
    end

    def read_block_at(vo)
      block_offset = vo_block_offset(vo)
      data_offset = vo_data_offset(vo)
      f.seek(block_offset)
      block_data = decompress_block(f)
      if data_offset == 0
        return block_data
      else
        return block_data.slice(data_offset...block_data.size)
      end
    end

    def each_block
      if block_given?
        while b = read_block
          yield b
        end
      else
        enum_for(:each_block)
      end
    end

  end

end

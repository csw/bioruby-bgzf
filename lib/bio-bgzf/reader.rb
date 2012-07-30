module Bio::BGZF
  
  class Reader
    include Bio::BGZF

    attr_reader :f

    def initialize(f)
      @f = f
      @cur_block = nil
    end

    # Returns the reader's current virtual offset. Between
    # {#read_block} calls, the file position will always be at the
    # start of a block or at EOF, so the low 16 bits of the virtual
    # offset will always be zero.
    #
    # @return [Integer] virtual offset for current position
    def tell
      f.tell << 16
    end

    # Reads the BGZF block at the current position. Returns its
    # decompressed data.
    #
    # @return [String] decompressed block data
    def read_block
      decompress_block(f)
    end

    # Reads a portion of a BGZF block, starting from the given virtual
    # offset. If the offset is the start of a block (low 16 bits are
    # zero) the entire block's data will be returned. Otherwise, the
    # subset of the data starting at the given offset will be
    # returned.
    #
    # @param [Integer] vo virtual offset to start from
    # @return [String] decompressed block data
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

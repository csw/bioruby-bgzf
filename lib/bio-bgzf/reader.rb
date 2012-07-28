class BGZFReader
  attr_reader :f

  def initialize(f)
    @f = f
    @cur_block = nil
  end

  def vo_block_offset(vo)
    vo >> 16
  end

  def vo_data_offset(vo)
    vo & 0xFFFF
  end

  def tell
    f.tell << 16
  end

  def read_block
    BioBgzf.decompress_block(f)
  end

  def read_block_at(vo)
    block_offset = vo_block_offset(vo)
    data_offset = vo_data_offset(vo)
    block_data = BioBgzf.decompress_block_at(f, block_offset)
    if data_offset == 0
      return block_data
    else
      return block_data.slice(data_offset...block_data.size)
    end
  end
end

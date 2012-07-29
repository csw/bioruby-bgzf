module Bio::BGZF
  def vo_block_offset(vo)
    vo >> 16
  end
  module_function :vo_block_offset

  def vo_data_offset(vo)
    vo & 0xFFFF
  end
  module_function :vo_data_offset
end

module Bio::BGZF

  class FormatError < StandardError
  end

  class NotBGZFError < FormatError
  end

  def read_bgzf_block(f)
    hstart = f.read(12)
    return nil if hstart == nil # EOF?
    magic, gzip_extra_length = hstart.unpack('Vxxxxxxv')
    raise NotBGZFError, "wrong BGZF magic: #{sprintf('%08x', magic)}" unless magic == 0x04088B1F

    len = 0
    bsize = nil
    while len < gzip_extra_length do
      si1, si2, slen = f.read(4).unpack('CCv')
      if si1 == 66 and si2 == 67 then
        raise FormatError, "BC subfield length is #{slen} but must be 2" if slen != 2
        raise FormatError, 'duplicate field with block size' unless bsize.nil?
        bsize = f.read(2).unpack('v')[0]
        f.seek(slen - 2, IO::SEEK_CUR)
      else
        f.seek(slen, IO::SEEK_CUR)
      end
      len += 4 + slen
    end

    if len != gzip_extra_length then
      raise FormatError, "total length of subfields is #{len} bytes but must be #{gzip_extra_length}"
    end
    raise NotBGZFError, 'block size was not found in any subfield' if bsize.nil?

    compressed_data = f.read(bsize - gzip_extra_length - 19)
    crc32, input_size = f.read(8).unpack('VV')

    return compressed_data, input_size, crc32
  end
  module_function :read_bgzf_block

  def decompress_block(f)
    cdata, in_size, expected_crc = read_bgzf_block(f)
    return nil if cdata == nil
    data = unpack(cdata)
    if data.bytesize != in_size
      raise FormatError, "Expected #{in_size} bytes from BGZF block at #{pos}, but got #{data.bytesize} bytes!"
    end
    crc = Zlib.crc32(data, 0)
    if crc != expected_crc
      raise FormatError, "CRC error: expected #{expected_crc.to_s(16)}, got #{crc.to_s(16)}"
    end
    return data
  end
  module_function :decompress_block

end

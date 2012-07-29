require 'zlib'

module Bio::BGZF

  # Packs +str+ into a BGZF block using 
  # given compression +level+.
  def pack(str, level=Zlib::BEST_COMPRESSION)
    zs = Zlib::Deflate.new level, -15
    cdata = zs.deflate str, Zlib::FINISH
    zs.close

    crc32 = Zlib.crc32 str, 0
    isize = str.length

    bsize = cdata.length + 19 + XLEN

    array = [   ID1, 
                ID2, 
                 CM, 
                FLG, 
              MTIME, 
                XFL,
                 OS,
               XLEN,
                SI1,
                SI2,
               SLEN,
              bsize,
              cdata,
              crc32,
              isize
            ]

     array.pack('CCCCVCCvCCvva*VV')
  end
  module_function :pack
end

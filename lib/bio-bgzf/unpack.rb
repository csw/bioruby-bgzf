require 'zlib'

module Bio::BGZF
    # Unpacks compressed data, NOT a BGZF block.
    def unpack(str)
        zs = Zlib::Inflate.new(-15)
        zs.inflate(str)
    end
    module_function :unpack
end

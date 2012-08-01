module Bio::BGZF
  
  class Writer
    include Bio::BGZF

    attr_reader :f, :buf

    def initialize(f)
      @f = f
      @buf = ''
      if block_given?
        begin
          yield self
        ensure
          self.close
        end
      end
    end    

    def tell
      f.tell << 16
    end

    def write_buf
      if buf.size > 0
        raise "Buffer too large: #{buf.bytesize}" if buf.bytesize > MAX_BYTES
        block = pack(buf)
        f.write(block)
        @buf = ''
      end
    end

    def write(s)
      if s.bytesize > MAX_BYTES
        write_buf
        _each_slice(s) do |slice|
          write(slice)
        end
      else
        if (s.bytesize + buf.bytesize) > MAX_BYTES
          write_buf
        end
        buf << s
      end
    end

    def _each_slice(s)
      n = 0
      size = s.bytesize
      while true
        offset = n * MAX_BYTES
        break if offset >= size
        yield s.slice(offset, MAX_BYTES)
        n += 1
      end
    end

    def close
      write_buf
      f.close
    end
    
  end

end

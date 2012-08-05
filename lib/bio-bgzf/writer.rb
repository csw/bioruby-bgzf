require 'zlib'

module Bio::BGZF
  
  class Writer
    include Bio::BGZF

    attr_reader :f, :buf, :level

    # Return the virtual offset of the last {#write} call. This is a
    # hook for e.g. building an index on the fly.
    attr_reader :last_write_pos

    def initialize(f, level=2)
      @f = f
      @level = level
      @buf = ''
      @buf_write_pos = 0
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
        block = pack(buf, level)
        f.write(block)
        @buf = ''
        @buf_write_pos = tell
      end
    end

    # @api private
    def _cur_write_pos
      @buf_write_pos + buf.bytesize
    end

    def write(s)
      if s.bytesize > MAX_BYTES
        write_buf
        @last_write_pos = _cur_write_pos
        _each_slice(s) do |slice|
          write(slice)
        end
      else
        if (s.bytesize + buf.bytesize) > MAX_BYTES
          write_buf
        end
        @last_write_pos = _cur_write_pos
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

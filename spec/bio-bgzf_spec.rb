require 'rspec/expectations'
require 'bio-bgzf'
require 'tempfile'

describe Bio::BGZF do
  it "should be able to pack strings to BGZF blocks" do
    Bio::BGZF.should respond_to(:pack).with(1).argument
    Bio::BGZF.pack("asdfghjkl").should be_instance_of String
  end

  it "should be able to read BGZF blocks from a samtools file" do
    File.open("test/data/mm8.chrM.maf.gz") do |f|
      r = Bio::BGZF::Reader.new(f)
      r.each_block do |block, pos|
        block.size.should <= 65536
        pos.should.is_a? Integer
        Bio::BGZF::vo_data_offset(pos).should == 0
      end
    end
  end

  it "should be able to iteratively read BGZF blocks from stream" do
    str = ''
    1000.times { str += (Random.rand(26) + 65).chr }

    file = Tempfile.new 'bgzfstring'
    str.chars.each_slice(42).map(&:join).each do |s|
        file.write(Bio::BGZF.pack s)
    end
    file.flush
    file.rewind

    str2 = ''
    r = Bio::BGZF::Reader.new(file)
    r.each_block {|block| str2 += block }

    str2.should == str
  end
end

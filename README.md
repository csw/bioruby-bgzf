# bio-bgzf

[![Build Status](https://secure.travis-ci.org/csw/bioruby-bgzf.png)](http://travis-ci.org/csw/bioruby-bgzf)

This library provides support for the [BGZF][] (Blocked GZip Format)
in Ruby. BGZF, originally defined as part of the [SAM/BAM][]
specification, is used to compress record-oriented bioinformatics data
in a way that facilitates random access, unlike plain gzip. A BGZF
file consists of contatenated 64 KB blocks, each an independent gzip
stream. It can be decompressed in its entirety with gzip, but this
library enables random access using 'virtual offsets' as defined in
SAM/BAM.

A virtual offset is a 64-bit quantity, with a 48-bit block offset
giving the position in the file of the start of the block followed by
a 16-bit data offset giving a position within the file.

## Installation

```sh
    gem install bio-bgzf
```

## Usage

```ruby
    require 'bio-bgzf'

    File.open('example.gz') do |f|
      r = Bio::BGZF::Reader.new(f)
      while true do
        block_vo = r.tell
        block = r.read_block
        break unless block
      end
      block = f.read_block_at(block_vo)
    end
```

The API doc is online. For more code examples see the test files in
the source tree.
        
## Project home page

Information on the source tree, documentation, examples, issues and
how to contribute, see

  http://github.com/csw/bioruby-bgzf

The BioRuby community is on IRC server: irc.freenode.org, channel: #bioruby.

## Cite

If you use this software, please cite one of
  
* [BioRuby: bioinformatics software for the Ruby programming language](http://dx.doi.org/10.1093/bioinformatics/btq475)
* [Biogem: an effective tool-based approach for scaling up open source software development in bioinformatics](http://dx.doi.org/10.1093/bioinformatics/bts080)

## Biogems.info

This Biogem is published at [#bio-bgzf](http://biogems.info/index.html)

## Copyright

Copyright (c) 2012 Artem Tarasov and Clayton Wheeler. See LICENSE.txt
for further details.

[BGZF]: http://blastedbio.blogspot.com/2011/11/bgzf-blocked-bigger-better-gzip.html
[SAM/BAM]: http://samtools.sourceforge.net/SAM1.pdf



module FormatEps
  
  #
  # EPS file can mean several things:
  # - 'normal' Postscript file, starts with %!PS
  # 
  # - DOS EPS file; starts with the 30-byte long header:
  #   - 0-3 Must be hex C5D0D3C6 (byte 0=C5).
  #   - 4-7 Byte position in file for start of PostScript language code section.
  #   - 8-11 Byte length of PostScript language section.
  #   - 12-15 Byte position in file for start of Metafile screen representation.
  #   - 16-19 Byte length of Metafile section (PSize).
  #   - 20-23 Byte position of TIFF representation.
  #   - 24-27 Byte length of TIFF section.  
  #   - 28-29 Checksum of header (XOR of bytes 0-27). If Checksum is FFFF 
  #           then ignore it. 
  #
  def self.is_eps?(bytes)
    is_normal_eps?(bytes) || is_dos_eps?(bytes)
  end
  
  def self.is_normal_eps?(bytes)
    bytes[0..3] == "%!PS"
  end
  
  def self.is_dos_eps?(bytes)
    is_dos_eps_header?(bytes) && dos_eps_starts_with_ps?(bytes)  
  end
  
  def self.dos_eps_starts_with_ps?(bytes)
    offsets = bytes[4..7].unpack 'C*'
    offset = offsets[0] + (offsets[1] << 4) + (offsets[2] << 8) + (offsets[3] << 12)
    bytes[offset .. offset + 3] == '%!PS'
  end
  
  def self.is_dos_eps_header?(bytes)        
    bytes[0..3].unpack('C*') == [0xC5, 0xD0, 0xD3, 0xC6]        
  end
  
end

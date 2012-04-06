module FormatEps
  
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

require 'spec_helper'

describe FormatEps do
  
  it 'Should detect DOS EPS header' do
    bytes = File.open(fixture_file_path('sample_dos_eps.eps')).read
    FormatEps::is_dos_eps_header?(bytes).should be_true
  end
  
  it 'Should detect DOS EPS file' do
    bytes = File.open(fixture_file_path('sample_dos_eps.eps')).read
    FormatEps::is_dos_eps?(bytes).should be_true
  end      
  
  it 'Should detect EPS file' do    
    bytes = File.open(fixture_file_path('football_logo.eps')).read
    FormatEps::is_eps?(bytes).should be_true
  end
  
  
end
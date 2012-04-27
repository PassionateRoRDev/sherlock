Factory.define :file_asset do |f|
  f.path '123456789.bin'
  f.filesize 2048
  f.content_type 'application/binary'
  f.role :main
  f.association :user
end
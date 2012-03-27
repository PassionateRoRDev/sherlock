FactoryGirl.define do
  factory :footer do
    all_pages 1
    alignment 'left'
    border 0
    font_face 'arial'
    font_size 15
    font_color 'black'
    contents 'This is my footer'
    text_align 'center'
  end
end
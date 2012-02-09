# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :letterhead do
    all_pages false
    link true
    alignment "left"
    bgcolor "red"
    border true
    font_face "MyString"
    font_size 15
    font_color "blue"
    divider false
    divider_size 10
    divider_width 75
    divider_color "green"
    contents "This is my header"
    logo_path "logo.png"
    logo_alignment "left"
  end
end

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :letterhead do
    
    all_pages false
    link 'http://www.privateinvestigators.com'
    text_align 'left'
    bgcolor 'red'
    border true
    font_face "arial"
    font_size 15
    font_color "blue"
    
    divider_above true
    divider_size 2
    divider_width 75
    divider_color "green"
    
    contents "This is my header"
    logo_alignment "right"
    
    association :user
    
  end
end

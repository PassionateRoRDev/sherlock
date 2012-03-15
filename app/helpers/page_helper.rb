module PageHelper
  
  def body_class
    person_class = user_is_pi? ? 'pi' : 'client'
    "c-#{controller_name} a-#{action_name} user-#{person_class}"
  end
  
end
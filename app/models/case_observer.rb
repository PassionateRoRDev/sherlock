class CaseObserver < ActiveRecord::Observer

  observe Case

  def after_create(model)    
    Event.create( 
      :event_type => 'create',
      :event_subtype => 'case',
      :detail_i1 => model.id,
      :user_id    => model.author_id
    )
    KM.identify(model.author_id)    
    KM.record('created case', :case_id => model.id, :case_title => model.title )
  end
  
  def after_destroy(model)
    Event.create( 
      :event_type => 'delete',
      :event_subtype => 'case',
      :detail_i1 => model.id,
      :user_id    => model.author_id
    )
    KM.identify(model.author_id)    
    KM.record('deleted case', :case_id => model.id, :case_title => model.title )
  end  

end
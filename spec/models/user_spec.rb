require 'spec_helper'

describe User do
  it 'should be valid' do
    FactoryGirl.build(:user).should be_valid
  end

  it "should have link to a picture through blocks and cases" do    
    filename = 'sample_image1.bmp'   
    data = {
      :filepath           => fixture_file_path(filename),
      :original_filename  => filename
    }
    uploaded = Uploader.new(data)    
    picture = FactoryGirl.create(:picture, :uploaded_file => uploaded)
    author = picture.block.case.author
    author.pictures.should include(picture)
  end
  
#  it "should have videos through blocks and cases" do
#    block = FactoryGirl.create(:block)
#    video = FactoryGirl.create.build(:video, :block => block)
#    author = block.case.author
#    author.videos.should include(video)
#  end

  it 'can not view cases by default' do
    secret = FactoryGirl.create(:case)
    snoop = FactoryGirl.create(:user)
    snoop.can_view?( secret ).should == false
  end
  
  it 'is PI by default' do
    pi = FactoryGirl.create(:user)
    pi.pi?.should == true
  end
  
  it 'is a Client, if he has invitation token' do
    client = FactoryGirl.create(:user, :invitation_token => 'token')
    client.pi?.should == false
  end
  
  it 'is PI, if he has subscriptions linked' do
    pi = FactoryGirl.create(:user, :invitation_token => 'token')
    FactoryGirl.create(:subscription, :product_handle => 'free_trial', :user => pi)        
    pi.pi?.should == true
  end

  it 'can view cases when it is on the viewer list' do
    client = FactoryGirl.create(:user)
    info = FactoryGirl.create(:case, :viewers => [client])
    
    client.can_view?( info ).should == true
  end

  it 'can view cases when listed as the author' do
    author = FactoryGirl.create(:user)
    great_am_tale = FactoryGirl.create(:case, :author => author)

    author.can_view?( great_am_tale ).should == true
  end

  it 'will not see duplicate cases when a viewer and an author.' do
    author = FactoryGirl.create(:user)
    casework = FactoryGirl.create(:case, :author => author, :viewers => [author])
    casework.reload.viewers.should include author
    author.reload.should have(1).cases
  end
  
  it 'has a list of authored cases' do
    c = FactoryGirl.create(:case)
    c.author.authored_cases.should include(c)
  end
  
  it 'should have 0 clients initially' do
    investigator = FactoryGirl.create(:user)
    investigator.clients.should == []    
  end
  
  it 'should have 1 client added when asked to do so twice' do
    investigator = FactoryGirl.create(:user)
    client = FactoryGirl.create(:user, :email => 'client1@aol.com')
    investigator.add_client(client)
    investigator.add_client(client)
    investigator.clients.count.should == 1
  end
  
  it 'should return email as full name if first name and last name are blank' do
    user = FactoryGirl.create(:user, 
      :first_name => nil, 
      :last_name => nil, 
      :email => 'user@mail.com'
    )
    user.full_name.should == "user@mail.com"
  end
  
  it 'should return last name as full name if first name is blank' do
    user = FactoryGirl.create(:user, 
      :first_name => nil, 
      :last_name => 'Smith', 
      :email => 'user@mail.com'
    )
    user.full_name.should == "Smith"
  end
  
  it 'without the cases, should have 0 space usage reported' do
    user = FactoryGirl.create(:user)
    user.space_usage.should == 0
  end
  
  it 'should have empty space usage if has a case but without file assets' do
    c = FactoryGirl.create(:case)
    c.author.space_usage.should == 0
  end  
  
  it 'should have usage equal to the stored picture for one case with 1 pic' do
    
    filename = 'sample_image1.bmp'
    picture_path = fixture_file_path(filename)    
    block = FactoryGirl.create(:block)    
    data = {
      :filepath           => picture_path,
      :original_filename  => filename
    }
    uploaded = Uploader.new(data)    
    picture = FactoryGirl.create(:picture, :block => block, :uploaded_file => uploaded)    
    
    current_size = File.size(picture.full_filepath)
    
    block.case.author.space_usage.should == current_size + File.size(picture_path)
    
  end
  
  context "When having 3 subscription plans available" do    
    
    def init_plans
      [
        { :handle => :free_trial, :price => 0, :slug => nil },
        { :handle => :independent, :price => 9, :slug => 'h/1' },
        { :handle => :agency, :price => 29, :slug => 'h/2' },
        { :handle => :corporate, :price => 99, :slug => 'h/3' }
      ].each do |plan|
        FactoryGirl.create(:subscription_plan, 
          :chargify_handle  => plan[:handle], 
          :chargify_slug    => plan[:slug], 
          :price            => plan[:price])
      end    
    end
    
    before do        
      init_plans
      @pi = FactoryGirl.create(:user, :invitation_token => 'token')                  
    end
    
    it 'if the current subscription expired, PI can upgrade/renew using any plan' do               
      @pi.subscriptions << Subscription.create(
        :product_handle => 'agency', 
        :period_ends_at => Time.now - 1.month,
        :subscription_plan => SubscriptionPlan.find_by_chargify_handle(:agency)
      )    
            
      @pi.plans_to_upgrade.size.should == 3   
    end
    
    context "and the current subscription has not expired" do
      before do
        @pi.subscriptions << Subscription.create(
          :product_handle => 'agency', 
          :period_ends_at => Time.now + 1.month,     
          :subscription_plan => SubscriptionPlan.find_by_chargify_handle(:agency)
        )
      end
      
      it 'PI can upgrade to 1 plan' do           
        @pi.plans_to_upgrade.size.should == 1
      end    
      
      it 'PI can upgrade to Corporate plan' do           
        @pi.plans_to_upgrade.first.chargify_handle.to_sym.should == :corporate
      end    
      
    end
    
    
        
  end    
  
end


class LetterheadsController < ApplicationController
  
  before_filter :authorize_pi!
  
  before_filter :resolve_letterhead, :except => [ :new, :create ]
  
  # GET /letterheads
  # GET /letterheads.json
  #def index
  #  @letterheads = Letterhead.all

  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.json { render :json => @letterheads }
  #  end
  #end

  # GET /letterheads/1
  # GET /letterheads/1.json
  def show    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @letterhead }
    end
  end

  # GET /letterheads/new
  # GET /letterheads/new.json
  def new
    
    if current_user.letterhead
      return redirect_to edit_letterhead_path(current_user.letterhead) 
    end
    
    @letterhead = Letterhead.new(
      :all_pages  => true,      
      :font_color => :black,
      :font_size  => 20,
      :divider_color  => :black
    )

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @letterhead }
    end
  end

  # GET /letterheads/1/edit
  def edit    
  end

  # POST /letterheads
  # POST /letterheads.json
  def create
            
    params = handle_logo_upload_for_create
    
    @letterhead = Letterhead.new(params[:letterhead])
    @letterhead.user = current_user    
    
    respond_to do |format|
      if @letterhead.save
        format.html { redirect_to dashboard_path, :notice => 'Letterhead was successfully created.' }
        format.json { render :json => @letterhead, :status => :created, :location => @letterhead }
      else
        format.html do
          @letterhead.logo = nil
          flash[:alert] = 'Letterhead could not be created'
          render 'new'
        end
        format.json { render :json => @letterhead.errors, :status => :unprocessable_entity }
      end
    end
  end
    
  # PUT /letterheads/1
  # PUT /letterheads/1.json
  def update
    
    params[:upload] ||= {}
    image = params[:upload]['logo']        
    
    respond_to do |format|
      if @letterhead.update_attributes(params[:letterhead])
    
        update_logo(image) if image          
        
        format.html { redirect_to edit_letterhead_path(@letterhead), 
                      :notice => 'Letterhead was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render "edit" }
        format.json { render :json => @letterhead.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /letterheads/1
  # DELETE /letterheads/1.json
  def destroy
    
    @letterhead.destroy
    
    respond_to do |format|
      format.html { redirect_to cases_path }
      format.json { head :ok }
    end
  end
  
  private
  
  def resolve_letterhead
    @letterhead = current_user.letterhead || redirect_to(cases_path)
  end    
  
  def init_logo(image)
    Logo.new(
      :user           => current_user,
      :uploaded_file  => image
    )
  end
  
  def handle_logo_upload_for_create    
    params[:upload] ||= {}
    image = params[:upload]['logo']    
    if image
      params[:letterhead][:logo] = init_logo(image)
    end        
    params
  end
  
  def update_logo(image)    
    logger.debug 'Updating the logo'
    if @letterhead.logo
      @letterhead.logo.uploaded_file = image
      @letterhead.logo.save
    else
      @letterhead.logo = init_logo(image)      
    end            
  end
  
end

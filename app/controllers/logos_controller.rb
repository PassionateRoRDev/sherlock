class LogosController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :authorize_pi!
  
  before_filter :resolve_logo, :except => [ :index, :new, :create ]
  
  # GET /logos
  # GET /logos.json
  def index
    @logos = current_user.logos.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @logos }
    end
  end

  # GET /logos/1
  # GET /logos/1.json
  def show    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @logo }
    end
  end

  # GET /logos/new
  # GET /logos/new.json
  def new
    @logo = Logo.new      

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @logo }
    end
  end

  # GET /logos/1/edit
  def edit    
  end

  # POST /logos
  # POST /logos.json
  def create
        
    params[:upload] ||= {}
    image = params[:upload]['logo']    
    params[:logo][:uploaded_file] = image if image
        
    @logo = Logo.new(params[:logo])
    @logo.user = current_user    
    
    respond_to do |format|
      if @logo.save
        format.html { redirect_to dashboard_path, :notice => 'Logo was successfully created.' }
        format.json { render :json => @logo, :status => :created, :location => @logo }
      else
        format.html do
          flash[:alert] = 'Logo could not be created'
          render "new"
        end
        format.json { render :json => @logo.errors, :status => :unprocessable_entity }
      end
    end
  end
    
  # PUT /logos/1
  # PUT /logos/1.json
  def update
    
    params[:upload] ||= {}
    image = params[:upload]['logo']    
    params[:logo][:uploaded_file] = image if image
        
    respond_to do |format|
      if @logo.update_attributes(params[:logo])                
        format.html { redirect_to edit_logo_path(@logo), 
                      :notice => 'Logo was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render "edit" }
        format.json { render :json => @logo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /logos/1
  # DELETE /logos/1.json
  def destroy
    
    @logo.destroy
    
    respond_to do |format|
      format.html { redirect_to cases_path }
      format.js
    end
  end
  
  private
  
  def resolve_logo
    @logo = current_user.logos.find_by_id(params[:id]) || redirect_to(cases_path)
  end
  
  
end

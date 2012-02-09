class LetterheadsController < ApplicationController
  
  before_filter :authenticate_user!
  
  before_filter :resolve_letterhead, :except => [ :new, :create ]
  
  # GET /letterheads
  # GET /letterheads.json
  #def index
  #  @letterheads = Letterhead.all

  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.json { render json: @letterheads }
  #  end
  #end

  # GET /letterheads/1
  # GET /letterheads/1.json
  def show    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @letterhead }
    end
  end

  # GET /letterheads/new
  # GET /letterheads/new.json
  def new
    @letterhead = Letterhead.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @letterhead }
    end
  end

  # GET /letterheads/1/edit
  def edit    
  end

  # POST /letterheads
  # POST /letterheads.json
  def create
    
    @letterhead = Letterhead.new(params[:letterhead])
    @letterhead.user = current_user
    
    respond_to do |format|
      if @letterhead.save
        format.html { redirect_to root_path, notice: 'Letterhead was successfully created.' }
        format.json { render json: @letterhead, status: :created, location: @letterhead }
      else
        format.html { render action: "new" }
        format.json { render json: @letterhead.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /letterheads/1
  # PUT /letterheads/1.json
  def update
    
    respond_to do |format|
      if @letterhead.update_attributes(params[:letterhead])
        format.html { redirect_to edit_letterhead_path(@letterhead), 
                      notice: 'Letterhead was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @letterhead.errors, status: :unprocessable_entity }
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
  
  
end

class FootersController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :authorize_pi!
  
  before_filter :resolve_case
  before_filter :verify_case_author!
  
  before_filter :resolve_footer, :except => [ :new, :create ]
  
  # GET /footers
  # GET /footers.json
  #def index
  #  @footers = Footer.all
  #
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.json { render :json => @footers }
  #  end
  #end

  # GET /footers/1
  # GET /footers/1.json
  def show    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @footer }
    end
  end

  # GET /footers/new
  # GET /footers/new.json
  def new
    
    @footer = Footer.new(
      :all_pages => true, 
      :case => @case, 
      :font_size => 15,
      :font_face => :arial,
      :font_color => :black,
      :bgcolor  => :white,
      :divider_color  => :black
    )  

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @footer }
    end
  end

  # GET /footers/1/edit
  def edit    
  end

  # POST /footers
  # POST /footers.json
  def create
    
    @footer = Footer.new(params[:footer])
    @footer.case = @case

    respond_to do |format|
      if @footer.save
        format.html { redirect_to edit_case_footer_path(@case, @footer), 
                        :notice => 'Footer was successfully created.' }
        format.json { render :json =>  @footer, :status => :created, :location => @footer }
      else
        format.html { render "new" }
        format.json { render :json => @footer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /footers/1
  # PUT /footers/1.json
  def update
    
    respond_to do |format|
      if @footer.update_attributes(params[:footer])
        format.html { redirect_to(
                      edit_case_footer_path(@case, @footer),
                      :notice => 'Footer was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render "edit" }
        format.json { render :json => @footer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /footers/1
  # DELETE /footers/1.json
  def destroy
    
    @footer.destroy

    respond_to do |format|
      format.html { redirect_to footers_url }
      format.json { head :ok }
    end
  end
  
  private
  
  def resolve_case
    resolve_case_using_param(:case_id)
  end
  
  def resolve_footer    
    @footer = @case.footer || redirect_to(root_path)
  end    
  
  def verify_case_author!    
    is_author = (@case.author == current_company)
    redirect_to @case unless is_author    
  end
  
end

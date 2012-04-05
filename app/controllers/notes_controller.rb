class NotesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :authorize_pi!
  
  before_filter :resolve_case
  before_filter :resolve_note, :except => [ :new, :create ]
  
  # GET /notes
  # GET /notes.json
  
  def index
    @notes = Note.order('id DESC')
  
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.json
  def new    
    @note = @case.notes.new
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @note }
    end
  end

  # GET /notes/1/edit
  def edit    
  end

  # POST /notes
  # POST /notes.json
  def create
    
    @note = @case.notes.new params[:note]
    
    respond_to do |format|
      if @note.save
        
        @notes_count = @note.case.notes.count
        
        format.html do 
          redirect_to edit_case_note_path(@case, @note), 
                      :notice => 'Note was successfully created.'                    
        end
        format.js
        format.json { render json: @note, status: :created, location: @note }
      else
        format.html { render action: "new" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.json
  def update
    
    respond_to do |format|
      if @note.update_attributes(params[:footer])
        format.html { redirect_to(
                      edit_case_note_path(@case, @note),
                      notice: 'Note was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    
    @note.destroy

    respond_to do |format|
      
      @notes_count = @note.case.notes.count
      
      format.html { redirect_to notes_url }
      format.js
      format.json { head :ok }
    end
  end
  
  private
  
  def resolve_case
    resolve_case_using_param(:case_id)
  end
  
  def resolve_note
    @note = @case.notes.find_by_id params[:id]
  end    
  
end

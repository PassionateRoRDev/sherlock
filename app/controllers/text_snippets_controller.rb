class TextSnippetsController < ApplicationController
  
  before_filter :authenticate_user!  
  before_filter :authorize_pi!  
  
  # GET /text_snippets
  # GET /text_snippets.json
  def index
    @text_snippets = TextSnippet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @text_snippets }
    end
  end

  # GET /text_snippets/1
  # GET /text_snippets/1.json
  def show
    @text_snippet = TextSnippet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @text_snippet }
    end
  end

  # GET /text_snippets/new
  # GET /text_snippets/new.json
  def new
    @text_snippet = TextSnippet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @text_snippet }
    end
  end

  # GET /text_snippets/1/edit
  def edit
    @text_snippet = TextSnippet.find(params[:id])
  end

  # POST /text_snippets
  # POST /text_snippets.json
  def create
    @text_snippet = TextSnippet.new(params[:text_snippet])

    respond_to do |format|
      if @text_snippet.save
        format.html { redirect_to @text_snippet, notice: 'Text snippet was successfully created.' }
        format.json { render json: @text_snippet, status: :created, location: @text_snippet }
      else
        format.html { render action: "new" }
        format.json { render json: @text_snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /text_snippets/1
  # PUT /text_snippets/1.json
  def update
    @text_snippet = TextSnippet.find(params[:id])

    respond_to do |format|
      if @text_snippet.update_attributes(params[:text_snippet])
        format.html { redirect_to @text_snippet, notice: 'Text snippet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @text_snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /text_snippets/1
  # DELETE /text_snippets/1.json
  def destroy
    @text_snippet = TextSnippet.find(params[:id])
    @text_snippet.destroy

    respond_to do |format|
      format.html { redirect_to text_snippets_url }
      format.json { head :no_content }
    end
  end
end

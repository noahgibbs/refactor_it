class RefactorsController < ApplicationController
  before_filter :capture_snippet
  before_filter :authorize_user!,
    :except => [:index, :show]

  # GET /refactors
  # GET /refactors.xml
  def index
    @refactors = @snippet ? @snippet.refactors : Refactor.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @refactors }
    end
  end

  # GET /refactors/1
  # GET /refactors/1.xml
  def show
    @refactor = Refactor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @refactor }
    end
  end

  # GET /refactors/new
  # GET /refactors/new.xml
  def new
    @refactor = @snippet ? @snippet.refactors.build : Refactor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @refactor }
    end
  end

  # GET /refactors/1/edit
  def edit
    @refactor = Refactor.find(params[:id])
  end

  # POST /refactors
  # POST /refactors.xml
  def create
    @refactor = Refactor.new(params[:refactor])

    respond_to do |format|
      if @refactor.save
        format.html { redirect_to(@refactor, :notice => 'Refactor was successfully created.') }
        format.xml  { render :xml => @refactor, :status => :created, :location => @refactor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @refactor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /refactors/1
  # PUT /refactors/1.xml
  def update
    @refactor = Refactor.find(params[:id])

    respond_to do |format|
      if @refactor.update_attributes(params[:refactor])
        format.html { redirect_to(@refactor, :notice => 'Refactor was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @refactor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /refactors/1
  # DELETE /refactors/1.xml
  def destroy
    @refactor = Refactor.find(params[:id])
    @refactor.destroy

    respond_to do |format|
      format.html { redirect_to(refactors_url) }
      format.xml  { head :ok }
    end
  end

  private

  def capture_snippet
    @snippet = Snippet.find params[:snippet_id] if params[:snippet_id]
  end
end

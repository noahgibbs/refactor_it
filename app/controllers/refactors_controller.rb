class RefactorsController < ApplicationController
  before_filter :capture_snippet
  before_filter :authenticate_user!,
    :except => [:index, :show]

  Languages = Snippet::Languages
  VoteTypes = Vote::VoteTypes
  VoteTypesByNumber = Vote::VoteTypesByNumber
  VoteTypeNames = Vote::VoteTypeNames

  # GET /snippets/3/refactors
  # GET /snippets/3/refactors.xml
  def index
    @refactors = @snippet ? @snippet.refactors : Refactor.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @refactors }
    end
  end

  # GET /snippets/3/refactors/1
  # GET /snippets/3/refactors/1.xml
  def show
    @refactor = Refactor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @refactor }
    end
  end

  # POST /snippets/3/snippets/1/refactors/vote?id=274&type=Interesting
  def vote
    refactor_id = params[:id].to_i

    votes = Vote.find(:all, :conditions => { :refactor_id => refactor_id, :user_id => current_user.id })
    votes.each { |vote| vote.destroy }

    if params[:type] == "Unvote"
      render :text => "success"
    else
      ref = Refactor.find(refactor_id)
      snippet_id = ref.snippet_id
      vote = Vote.new :snippet_id => snippet_id, :refactor_id => refactor_id, :vote_type => VoteTypes[params[:type]], :user_id => current_user.id, :vote_approved => 1
      if vote.save
        render :text => "success"
      else
        render :text => "Couldn't vote!", :status => 500
      end
    end
  end

  # GET /snippets/3/refactors/new
  # GET /snippets/3/refactors/new.xml
  def new
    @refactor = @snippet ? @snippet.refactors.build : Refactor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @refactor }
    end
  end

  # GET /snippets/3/refactors/1/edit
  def edit
    @refactor = Refactor.find(params[:id])
  end

  # POST /snippets/3/refactors
  # POST /snippets/3/refactors.xml
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

  # PUT /snippets/3/refactors/1
  # PUT /snippets/3/refactors/1.xml
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

  # DELETE /snippets/3/refactors/1
  # DELETE /snippets/3/refactors/1.xml
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

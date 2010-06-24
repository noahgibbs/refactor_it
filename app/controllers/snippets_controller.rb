class SnippetsController < ApplicationController
  before_filter :authenticate_user!,
    :except => [:index, :show, :hottest]

  Languages = Snippet::Languages
  VoteTypes = Vote::VoteTypes
  VoteTypesByNumber = Vote::VoteTypesByNumber
  VoteTypeNames = Vote::VoteTypeNames

  MaxSnippets = 10

  # GET /snippets
  # GET /snippets.xml
  def index
    @snippets = Snippet.most_recent.limit(10)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @snippets }
    end
  end

  def hottest
    @snippets = Snippet.by_karma.limit(MaxSnippets)

    respond_to do |format|
      format.html { render :action => :index }
      format.xml  { render :action => :index, :xml => @snippets }
    end
  end

  # GET /snippets/1
  # GET /snippets/1.xml
  def show
    @snippet = Snippet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @snippet }
    end
  end

  # POST /snippets/vote?id=274&type=Interesting
  def vote
    snippet_id = params[:id].to_i

    votes = Vote.find(:all, :conditions => { :snippet_id => snippet_id, :user_id => current_user.id })
    votes.each { |vote| vote.destroy }

    if params[:type] == "Unvote"
      render :text => "success"
    else
      vote = Vote.new :snippet_id => snippet_id, :vote_type => VoteTypes[params[:type]], :user_id => current_user.id, :vote_approved => 1
      if vote.save
        render :text => "success"
      else
        render :text => "Couldn't vote!", :status => 500
      end
    end
  end

  # GET /snippets/new
  # GET /snippets/new.xml
  def new
    @snippet = Snippet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @snippet }
    end
  end

  # GET /snippets/1/edit
  def edit
    @snippet = Snippet.find(params[:id])
  end

  # POST /snippets
  # POST /snippets.xml
  def create
    @snippet = Snippet.new(params[:snippet].merge({:user_id => current_user.id}))

    respond_to do |format|
      if @snippet.save
        format.html { redirect_to(@snippet, :notice => 'Snippet was successfully created.') }
        format.xml  { render :xml => @snippet, :status => :created, :location => @snippet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @snippet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /snippets/1
  # PUT /snippets/1.xml
  def update
    @snippet = Snippet.find(params[:id])

    respond_to do |format|
      if @snippet.update_attributes(params[:snippet])
        format.html { redirect_to(@snippet, :notice => 'Snippet was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @snippet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /snippets/1
  # DELETE /snippets/1.xml
  def destroy
    @snippet = Snippet.find(params[:id])
    @snippet.destroy

    respond_to do |format|
      format.html { redirect_to(snippets_url) }
      format.xml  { head :ok }
    end
  end
end

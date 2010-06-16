class SnippetsController < ApplicationController
  before_filter :vote_display

  # GET /snippets
  # GET /snippets.xml
  VoteTypes = {
    "Unvote" => 1,

    "Interesting" => 1001,
    "Difficult" => 1002,

    "Not Code" => 2001,
    "Spam" => 2002
  }

  VoteTypesByNumber = {}
  VoteTypes.each { |key, val| VoteTypesByNumber[val] = key }

  VoteTypeNames = (VoteTypes.keys - ["Unvote"]).sort {|a,b|
    VoteTypes[a] <=> VoteTypes[b]
  }

  Languages = {
    "C" => "c",
    "C++" => "c++",
    "CSS" => "css",
    "Dylan" => "dylan",
    "HTML" => "html",
    "Java" => "java",
    "JavaScript/ECMAScript" => "javascript",
    "JavaScript (jQuery)" => "jquery_javascript",
    "JavaScript (Prototype)" => "javascript_+_prototype",
    "Rails (Ruby)" => "ruby_on_rails",
    "Rails (HTML/Erb)" => "html_rails",
    "Rails (SQL)" => "sql_rails",
    "Ruby" => "ruby",
    "SQL" => "sql",
  }

  def index
    @snippets = Snippet.all :order => "created_at DESC", :limit => 10
    @snippets.each {|snippet| set_vote_display snippet}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @snippets }
    end
  end

  # GET /snippets/1
  # GET /snippets/1.xml
  def show
    @snippet = Snippet.find(params[:id])
    set_vote_display @snippet

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @snippet }
    end
  end

  # POST /snippets/vote?id=274&type=Interesting
  def vote
    snippet_id = params[:id].to_i

    # TODO: find just vote(s) from this user to delete
    votes = Vote.find(:all, :conditions => { :snippet_id => snippet_id })
    votes.each { |vote| vote.destroy }

    vote = Vote.new :snippet_id => snippet_id, :vote_type => params[:type]
    if vote.save
      render :text => "success"
    else
      render :text => "Couldn't vote!", :status => 500
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
    @snippet = Snippet.new(params[:snippet].merge({:user_id => 7}))

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
    set_vote_display @snippet

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

  private

  def vote_display
    @vote_display = {}
    @unvote_display = {}
    @vote_type = {}
  end

  def set_vote_display(snippet)
    id = snippet.id
    vote = Vote.find_by_snippet_id id  # TODO: and by user

    if vote && !vote.empty?
      @vote_display[id] = " nodisplay"
      @unvote_display[id] = ""
      @vote_type[id] = VoteTypesByNumber[vote[0].vote_type]
    else
      @unvote_display[id] = " nodisplay"
      @vote_display[id] = ""
    end
  end
end

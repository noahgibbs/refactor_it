class SnippetsController < ApplicationController
  before_filter :vote_display
  before_filter :authorize_user!,
    :except => [:index, :show, :hottest]

  # TODO: make vote_display an after_filter, based on
  # @snippet and @snippets?

  Languages = Snippet::Languages
  VoteTypes = Vote::VoteTypes
  VoteTypesByNumber = Vote::VoteTypesByNumber
  VoteTypeNames = Vote::VoteTypeNames

  MaxSnippets = 10

  # GET /snippets
  # GET /snippets.xml
  def index
    @snippets = Snippet.all :order => "created_at DESC",
                            :limit => MaxSnippets
    @snippets.each {|snippet| set_vote_display snippet}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @snippets }
    end
  end

  def hottest
    # TODO: refactor this mess.
    # Rather than counting votes per-request, we should be
    # including a karma/total field in each snippet and refactor
    # that gets updated when votes do.  Karma logic belongs in
    # the model.

    sql_results = Vote.connection.execute("SELECT snippet_id, vote_type, COUNT(*) FROM votes WHERE refactor_id IS NULL AND vote_approved = 1 AND user_id IS NOT NULL GROUP BY snippet_id, vote_type")

    vote_counts = {}
    sql_results.each do |row|
      id = row['snippet_id'].to_i
      vote_type = row['vote_type'].to_i
      vote_counts[id] ||= {}
      vote_counts[id][vote_type] = row['COUNT(*)'].to_i
    end

    vote_counts.each do |snippet_id, vote_table|
      total = 0
      vote_table.each do |vtype, count|
        if vtype >= 2000  # spam or inappropriate
          total -= count * 5
        elsif vtype >= 1000  # interesting or appropriate
          total += count
        else
          raise "Unvote found in votes!"
        end
      end
      vote_counts[snippet_id]['value'] = total
    end

    snippet_ids = vote_counts.keys

    # Get random snippets, in case we have fewer ranked snippets than
    # requested, or fewer with rank above 0
    unranked_snippets = Snippet.all :order => "created_at DESC",
                                    :limit => MaxSnippets
    unranked_snippets ||= []  # in case there are none
    unranked_snippet_ids = unranked_snippets.map(&:id) - snippet_ids
    unranked_snippet_ids.each { |id|
      vote_counts[id] = {'value' => 0}
    }

    snippet_ids |= unranked_snippet_ids
    snippet_ids = snippet_ids.sort { |a, b|
      vote_counts[b]['value'] <=> vote_counts[a]['value']
    }
    snippet_ids = snippet_ids[0..MaxSnippets-1]

    @snippets = snippet_ids.map {|id| Snippet.find id }
    @snippets.each {|snippet| set_vote_display snippet}

    respond_to do |format|
      format.html { render :action => :index }
      format.xml  { render :action => :index, :xml => @snippets }
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

    votes = Vote.find(:all, :conditions => { :snippet_id => snippet_id, :user_id => current_user.id })
    votes.each { |vote| vote.destroy }

    if params[:type] == "Unvote"
      render :text => "success"
    else
      vote = Vote.new :snippet_id => snippet_id, :vote_type => VoteTypes[params[:type]], :user_id => 7, :vote_approved => 1
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
    @novote_display = {}
    @vote_type = {}
  end

  def set_vote_display(snippet)
    id = snippet.id
    vote = Vote.find_by_snippet_id_and_user_id id, current_user.id

    @vote_display[id] = @unvote_display[id] = @novote_display[id] = " nodisplay"

    unless current_user
      @novote_display[id] = ""
      return
    end

    if vote
      @unvote_display[id] = ""
      @vote_type[id] = VoteTypesByNumber[vote.vote_type]
    else
      @vote_display[id] = ""
    end
  end
end

class SearchesController < ApplicationController
  
  def index
    @searches = Search.all
  end
  
  def show
    @search = Search.find(params[:id])
    if @search.ready?
      render :partial => 'tweets', :locals=> {:search => @search}
    else
      @search.fetch_tweets
      render :nothing => true, :status => 204
    end
  end
  
  def create
    @search = Search.new(params[:search])
    respond_to do |format|
      if @search.save
        format.json{ render :json => @search }
      else
        format.json{ render :nothing => true, :status => :unprocessable_entity }
      end
    end
  end
  
end

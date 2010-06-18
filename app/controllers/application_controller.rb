# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  def after_sign_in_path_for(resource)
    url_for :controller => :snippets, :action => :hottest
    #if resource.is_a?(User)
    #  publisher_url
    #else
    #  super
    #end
  end
end

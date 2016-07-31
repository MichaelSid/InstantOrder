class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :prepare_meta_tags, if: "request.get?"


  alias_method :current_user, :current_account
  


  def prepare_meta_tags(options={})
    site_name   = "Instela"
    title       = "From Data Recovery to Carpet Cleaning, We Cover All Your Office Needs"
    description = "Instela will quickly solve all your office problems - IT
    Support, Handymen, Cleaning, Office Tasks & Chores, and more. Available across London."
    # image       = options[:image] || "your-default-image-url"
    current_url = request.url

    # Let's prepare a nice set of defaults
    defaults = {
      site:        site_name,
      title:       title,
      # image:       image,
      description: description,
      keywords:    %w[IT\ Services handymen Technical\ Support],
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    edit_account_registration_path
  end


end

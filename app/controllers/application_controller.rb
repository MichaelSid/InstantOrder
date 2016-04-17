class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :prepare_meta_tags, if: "request.get?"

  def prepare_meta_tags(options={})
    site_name   = "Instela"
    title       = "On-Demand & Onsite Support for All Your Office Needs"
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
  # ...

end

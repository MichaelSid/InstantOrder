class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :prepare_meta_tags, if: "request.get?"

  def prepare_meta_tags(options={})
    site_name   = "Instant Order"
    title       = [controller_name, 'Welcome'].join(" ")
    description = "On-Demand Support for All Your Office Needs"
    # image       = options[:image] || "your-default-image-url"
    current_url = request.url

    # Let's prepare a nice set of defaults
    defaults = {
      site:        site_name,
      title:       title,
      # image:       image,
      description: description,
      keywords:    %w[office support handymen on-demand texting SMS app],
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end
  # ...

end

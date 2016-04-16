# sitemap.rake
#http://cookieshq.co.uk/posts/creating-a-sitemap-with-ruby-on-rails-and-upload-it-to-amazon-s3/

require 'aws-sdk-v1'
require 'aws-sdk'

namespace :sitemap do

	desc 'Upload the sitemap files to S3'
	task upload_to_s3: :environment do
	  puts 'Starting sitemap upload to S3...'
	  # creds = Aws::Credentials.new(ENV['S3_ACCESS_KEY_ID'], ENV['S3_SECRET_ACCESS_KEY'])
	  s3 = Aws::S3::Resource.new(region: 'eu-west-1', credentials: Aws::Credentials.new(ENV['S3_ACCESS_KEY_ID'], ENV['S3_SECRET_ACCESS_KEY']))
	  bucket = s3.bucket(ENV['S3_BUCKET'].to_s)
	  Dir.entries(Rails.root.join('tmp', 'sitemaps')).each do |file_name|
	    next if %w(. .. .DS_Store).include? file_name
	    path = "sitemaps/#{file_name}"
	    file = Rails.root.join('tmp', 'sitemaps', file_name)
	    object = bucket.object(path)
	    object.upload_file(file)
	    puts "Saved #{file_name} to S3"
	  end
	end


	desc 'Create the sitemap, then upload it to S3 and ping the search engines'
  task create_upload_and_ping: :environment do
    Rake::Task["sitemap:create"].invoke

    Rake::Task["sitemap:upload_to_s3"].invoke

    SitemapGenerator::Sitemap.ping_search_engines('https://www.instela.co/sitemap.xml.gz')
  end

end


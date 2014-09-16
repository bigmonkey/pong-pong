class PostsController < ApplicationController

	layout 'paydayNav'

	before_filter :set_tracking
	
	def index
		@posts = Post.created.page(params[:page]).per(5)

		# needed for sidebar
		@recent_posts = Post.created.first(10)
		@categories = Topic.disp_order
	end
	
	def show
		# the find_by_slug! returns Record Not Found if nothing exits. This is escaped in the applications_controller via the rescue_from at top and method it directs to below
		
		if @post = Post.find_by_slug!(params[:id])
	
			# needed for sidebar
			@recent_posts = Post.created.first(10)
			@categories = Topic.disp_order
		end
	end

# blogdump code dumped wordpress blog into this database
# i left the code here for reference
#
#	def blogdump
#		f = File.open('/home/cw/Documents/datadumps/wordpress_9_17_2014.xml')
#		@blog = Nokogiri::XML(f)
#		f.close		
#		( @blog/'/rss/channel/item' ).each do |i| 
#  		a=Post.new
#  		a.title = (i/'./title').text.titleize
#  		a.slug = (i/'./wp:post_name').text
#  		a.created_at = (i/'./pubDate').text
#  		a.author = (i/'./dc:creator').text.titleize
#  		a.author = "Con Way" if a.author == "Conway"
#  		a.article = (i/'./content:encoded').text
#  		(i/'./wp:postmeta').each do |mp|
#  			if (mp/'./wp:meta_key').text == "_yoast_wpseo_metadesc"
#  				a.description = (mp/'./wp:meta_value').text
#  			end
#  			if (mp/'./wp:meta_key').text == "_yoast_wpseo_title"
#					a.seo_title = (mp/'./wp:meta_value').text
#  			end
#  		end
#  		a.save
#  		(i/'./category').each do |c|
#  			if !Topic.find_by_topic((c).text).blank?
#  				topic = Topic.find_by_topic((c).text)
#  				#binding.pry
#  				PostsTopic.create(post_id: a.id, topic_id: topic.id)
#  			end
#  		end
#		end
#	end

end

module PhotosHelper
	def render_flickr_sidebar_widget(user_id, photo_count = 12, columns = 2)
    begin
      photos = user_photos(user_id, photo_count).in_groups_of(2)
      render :partial => '/photos/sidebar_widget', :locals => { :photos => photos }
    rescue Exception
      render :partial => '/photos/unavailable'
    end
  end
end

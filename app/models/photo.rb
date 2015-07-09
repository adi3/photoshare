class Photo < ActiveRecord::Base
	belongs_to	:user
	has_many	:comments
	has_many	:tags

	validates :user_id, :date_time, :file_name, :presence => true

	def self.image_file? file
		return file.content_type.include? "image"
	end

	def self.get_unique_name photo
		if duplicate_name? photo
        	return modified_name photo
      	else
			return photo.original_filename
      	end
	end
	
	def self.duplicate_name? file
		path_to_check = File.join("public", "images", file.original_filename)
		return File.exists? path_to_check
	end

	def self.modified_name photo
		orig_name = photo.original_filename
		id = Photo.find(:all)[-1].id + 1
		return orig_name.insert -5, "_" + id.to_s
	end

	def self.upload_file name, photo
    	path = File.join "public", "images", name
    	File.open(path, "wb") {|f| f.write(photo.read)}
	end

	def self.find_by_query query
		query = query.downcase
		results = Array.new
		if (query.nil?)
			return nil
		end

		Photo.find(:all).each do |p|
			if p.query_in_tags?(query, p) or p.query_in_comments?(query, p)
				results << p
			end
		end

		return results
	end


	def query_in_tags? query, photo
		photo.tags.each do |t|
			u = User.find(t.user_id)
			if u.first_name.downcase.include?(query) or u.last_name.downcase.include?(query)
				return true
			end
		end
		return false
	end

	def query_in_comments? query, photo
		photo.comments.each do |c|
			if c.comment.downcase.include?(query)
				return true
			end
		end
		return false
	end

end

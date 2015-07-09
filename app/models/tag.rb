class Tag < ActiveRecord::Base
	belongs_to	:user
	belongs_to	:photo
	
	validates	:photo_id, :user_id, :top, :left, :width, :height, :presence => true
	validate	:unique_user?

	private
	def unique_user?
		tagged = Tag.find_all_by_photo_id(self.photo_id)
		if not tagged.nil?
			tagged.each do |t|
				if t.user_id == self.user_id
					errors.add(:user_id, "cannot be tagged twice on the same photo.")
				end
			end
		end
	end
end

class ChatRoom < ApplicationRecord
	has_and_belongs_to_many :users
	validates :name, presence: true, uniqueness: true, case_sensitive: false
end

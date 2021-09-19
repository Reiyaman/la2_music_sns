require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    has_many :submissions
    has_many :likes
    has_many :like_posts, :through => :likes, :source => :submission
end

class Submission < ActiveRecord::Base
    belongs_to :user
    has_many :likes
    has_many :like_users, :through => :likes, :source => :user
end

class Like < ActiveRecord::Base
    belongs_to :user
    belongs_to :submissiongha
end
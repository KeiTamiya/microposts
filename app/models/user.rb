class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
    has_secure_password
    validates :profile, presence: false, length: { maximum: 144 }
    validates :area, presence: false, length: { maximum: 50 }
    has_many :microposts
    has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :following_users, through: :following_relationships, source: :followed
    has_many :followed_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    has_many :followed_users, through: :follower_relationships, source: :follower
    
    # follow other users
    def follow(other_user)
        following_relationships.create(followed_id: other_user.id)
    end
    
    # unfollow other following users
    def unfollow(other_user)
        following_relationships.find_by(followed_id: other_user.id).destroy
    end
    
    # whether follow such user or not
    def following?(other_user)
        following_users.include?(other_user)
    end
end
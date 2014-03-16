class User < ActiveRecord::Base

  has_many :posts
  has_many :comments

  before_create :set_member

    mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, :omniauthable_providers => [:facebook]

  ROLES = %w[member moderator admin]
    def role?(base_role)
      role.nil? ? false : ROLES.index(base_role.to_s) <= ROLES.index(role)
    end  

    private

    def set_member
      self.role = 'member'
    end
end

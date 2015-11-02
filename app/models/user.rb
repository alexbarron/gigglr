class User < ActiveRecord::Base
  has_many :active_relationships, class_name: "Relationship", foreign_key: "user_id", dependent: :destroy
  has_many :comedians, through: :active_relationships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def follow(comedian)
    active_relationships.create(comedian_id: comedian.id)
  end

  def unfollow(comedian)
    active_relationships.find_by(comedian_id: comedian.id).destroy
  end

  def fan_of?(comedian)
    comedians.include?(comedian)
  end
end

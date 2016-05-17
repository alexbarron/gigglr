class User < ActiveRecord::Base
  has_many :active_relationships, class_name: "Relationship", foreign_key: "user_id", dependent: :destroy
  has_many :comedians, through: :active_relationships
  geocoded_by :location
  after_validation :geocode, :if => :location_changed?
  before_save :set_city_and_state
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def follow(comedian)
    active_relationships.create(comedian_id: comedian.id)
    comedian.update(fan_count: comedian.fan_count + 1)
  end

  def unfollow(comedian)
    active_relationships.find_by(comedian_id: comedian.id).destroy
    comedian.update(fan_count: comedian.fan_count - 1)
  end

  def fan_of?(comedian)
    comedians.include?(comedian)
  end

  def set_city_and_state
    user_loc = Geocoder.search(self.location).first
    self.city = user_loc.city
    self.state = user_loc.state_code
  end

end

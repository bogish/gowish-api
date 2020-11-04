class WishesCollection < ApplicationCollection
  def initialize(objects, struct = WishStruct)
    objects = objects.map do |object|
      attributes = object.attributes
      attributes[:user] = UserStruct.new(object.user.attributes).secure_attributes
      if object.booking.present?
        attributes[:booking] = BookingStruct.new(object.booking.attributes).to_h
        attributes[:booker] = UserStruct.new(object.booker.attributes).to_h
      end
      struct.new(attributes)
    end
    super
  end
end

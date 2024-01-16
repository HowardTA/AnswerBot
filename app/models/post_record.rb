class Post < ApplicationRecord
    validates :phone_number, presence: true
    validates :message_body, presence: true

    # Add your associations, validations, and other code here
end

# == Schema Information
#
# Table name: samples
#
#  id         :bigint           not null, primary key
#  name       :string(10)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Sample < ApplicationRecord

  # error types: :presence, :too_short, too_long
  validates :name,
    presence: true,
    length: { minimum: 1, maximum: 10 }

  # this gives a generic 'invalid' error type :(
  # validates_format_of :name, :with => /\A[a-z]*\z/, type: 'abc', message: "can only contain lowercase letters"

  NAME_REGEX = /\A[a-z]*\z/
  # this gives us an error with a meaningful type
  validate -> do
    if !self.name.nil? && !self.name.match(NAME_REGEX)
      errors.add(:name, :disallowed_characters, message: "only lowercase letters allowed")
    end
  end

end

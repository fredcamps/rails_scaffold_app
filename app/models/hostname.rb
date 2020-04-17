class Hostname < ApplicationRecord
  has_and_belongs_to_many :ips
  validates :address,
            presence: true,
            uniqueness: true
end

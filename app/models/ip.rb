# frozen_string_literal: true
require "resolv"

class Ip < ApplicationRecord
  has_and_belongs_to_many: hostnames
  validates :address,
            presence: true,
            uniqueness: true,
            format: { 'with' => Resolv::IPv4::Regex }
end

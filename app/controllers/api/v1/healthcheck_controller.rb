# frozen_string_literal: true

module Api
  module V1
    class HealthcheckController < ApplicationController
      def index
        render json: {
          'status': 'OK'
        }
      end
    end
  end
end

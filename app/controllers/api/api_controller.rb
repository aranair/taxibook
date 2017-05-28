class Api::ApiController < ApplicationController
  layout false
  skip_before_filter :verify_authenticity_token

  protected

  def access_denied
    render nothing: true, status: :forbidden
  end

  def render_422_error(error)
    respond_to do |accepts|
      accepts.json { render json: { errors: error }, status: :unprocessable_entity }
    end
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session #CSRF対策
  include DeviseTokenAuth::Concerns::SetUserByToken
end

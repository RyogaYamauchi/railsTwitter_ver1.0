class CalendarController < ApplicationController

  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = 'Google-Calendar-to-Twitter'.freeze
  CREDENTIALS_PATH = 'credentials.json'.freeze
  TOKEN_PATH = 'client_secret.json'.freeze
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR
  TIME_ZONE = 'Japan'

  def callback
    require 'google/apis/calendar_v3'
    require 'googleauth'
    require 'googleauth/stores/file_token_store'
    require 'fileutils'

    client_id = "240402029248-dfg771av1ehtn1fht7hecpj5lqjkntb1.apps.googleusercontent.com"
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    user_id = 'primary'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      code = params[:code]
      user_id = 'primary'
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end
end

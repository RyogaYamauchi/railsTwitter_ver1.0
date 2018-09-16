class CalendarController < ApplicationController
  require 'google/apis/calendar_v3'
  require 'googleauth'
  require 'googleauth/stores/file_token_store'
  require 'fileutils'

  OOB_URI = "http://localhost:3000/callbacked".freeze
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
    client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store,"http://localhost:3000/callbacked")
    user_id = 'watanuki.pazudora@gmail.com'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      code = params[:code]
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end

  def callbacked

  end
end

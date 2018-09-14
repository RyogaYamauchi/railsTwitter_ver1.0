namespace :serch do
  require 'twitter'
  require 'google/apis/calendar_v3'
  require 'googleauth'
  require 'googleauth/stores/file_token_store'
  require 'fileutils'

  #TwitterAPI初期値
  API_KEY = "JrWXQtLpbFhgKVy6dNRThvsWj"
  API_SECRET = "ik8PxiTscRIys8f4SU1AzMslAU2lph35IbQGXX0L5YRS7VVFsb"
  ACCESS_TOKEN = "2870762694-5lAx2XLBQJDLCmxXH25vCGI8Frz3Oq3HihbAUXJ"
  ACCESS_TOKEN_SECRET = "q7dKbju120Gr0RzR5jXuu962A1QfPnT2VeC4PRhcvpRyx"
  keyword = '#課題提出+課題'
  serchTweet = 10
  elements = []
  i=0
  j=0
  temp = false
  @summary =[]
  @startDate = []
  @endDate = []
  @tweetID = []
  @userID = []

  #GCalAPI初期値　アクセストークン
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = 'Google-Calendar-to-Twitter'.freeze
  CREDENTIALS_PATH = 'credentials.json'.freeze
  TOKEN_PATH = 'client_secret.json'.freeze
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR
  TIME_ZONE = 'Japan'


  #Twitterクライアントの初期設定
  @client = Twitter::REST::Client.new do |config|
    config.consumer_key        = API_KEY
    config.consumer_secret     = API_SECRET
    config.access_token        = ACCESS_TOKEN
    config.access_token_secret = ACCESS_TOKEN_SECRET
  end


  #毎分実行する処理
  task serchTweet: :environment do
    @client.search(keyword,lang: 'ja', count: serchTweet).take(serchTweet).each do |tweet|
      tweets = tweet.text

      #センテンスごとにツイートを分けてパブリックで公開
      tweet.text.each_line do |element|
        elements[i] = element
        i+=1
      end
      i=0
      p @tweetID[j]= tweet.user.screen_name
      p @tweetID[j] = tweet.id
      p @summary[j]  =elements[1].delete("課題名")
      @startDate[j]=elements[2]
      @endDate[j]  =elements[3]
      tempDate = @startDate[j].delete("0-9")
      @startDate[j].gsub!(tempDate[0],'-')
      @startDate[j].gsub!(tempDate[1],'-')
      p @startDate[j].gsub!(tempDate[2],'')
      @startDate[j].gsub!("\n",'')
      tempDate = @endDate[j].delete("0-9")
      @endDate[j].gsub!(tempDate[0],'-')
      @endDate[j].gsub!(tempDate[1],'-')
      p @endDate[j].gsub!(tempDate[2],'')
      @endDate[j].gsub!("\n",'')
      @userID[j] = tweet.user.screen_name
      tweetClient = Tweet.new(tweetID:@tweetID[j],
                              userID:@userID[j],
                              summary:@summary[j],
                              startDate:@startDate[j],
                              endDate:@endDate[j] )
      #クライアントが認証をしているか確認のリプライを送る
      clients = Tweet.all
      clients.each do | client |
        if client.userID==@userID[j]
          temp = true
          break
        end
      end
      if temp == false
        tempID = @userID[j]
        @client.update("@#{tempID}\nご利用ありがとうございます！以下のURLにアクセスしてカレンダーへの認証をお願いします！")
        p "#{@userID[j]}さんにリプライを送りました\n"
      else
        p"#{@userID[j]}さんはすでに登録しています\n"
      end
      temp = false


      #ツイートの重複を確認
      checks = Tweet.all
      checks.each do | check |
        if check.tweetID==@tweetID[j].to_s
          temp = true
          break
        end
      end
      if temp == false
        tweetClient.save
        p 'データベースにツイートの重複はありませんでした。保存します\n'
      else
        p 'データベースにツイートの重複がありました\n'
      end
      temp = false

      j+=1
      if j>2 then
        j=0
      end

    end

  end
end

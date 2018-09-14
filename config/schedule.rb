# ログ出力先ファイルを指定
set :output, 'log/crontab.log'
# ジョブ実行環境を指定
set :environment, :production

every 1.minute do
  rake "serch:serchTweet"
end

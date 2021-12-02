%w[texts movies].each do |table_name|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name} RESTART IDENTITY CASCADE")
end

require "csv"

class ImportCsv
  # CSVデータのパスを引数として受け取り、インポート処理を実行
  def self.import(path)
    # インポートするデータを格納するための空配列
    list = []
    # CSVファイルからインポートしたデータを格納
    CSV.foreach(path, headers: true) do |row|
      list << row.to_h
    end
    # メソッドの戻り値をインポートしたデータの配列とする
    list
  end

  def self.text_data
    # importクラスメソッドを呼び出す
    list = import("db/csv_data/text_data.csv")

    puts "Textインポート処理を開始"
    Text.create!(list)
    puts "Textインポート完了!"
  end

  def self.movie_data
    # importクラスメソッドを呼び出す
    puts "Movieインポート処理を開始"
    list = import("db/csv_data/movie_data.csv")
    Movie.create!(list)
    puts "Movieインポート完了!"
  end
end

email = "test@example.com"
password = "password"

# テストユーザーが存在しないときだけ作成
User.find_or_create_by!(email: email) do |user|
  user.password = password
  puts "ユーザーの初期データインポートに成功しました。"
end

ImportCsv.text_data
ImportCsv.movie_data

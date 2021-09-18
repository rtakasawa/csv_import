class User < ApplicationRecord
  enum status: { good: 0, normal: 1, bad: 2 }

  def self.import(file)

    # csvのheaderをカラムの用に出力する方法
    #   irb(User):026:0> csv = CSV.read(file,headers: :first_row,)
    # => #<CSV::Table mode:col_or_row row_count:2>
    #   irb(User):027:1* csv.each do |row|
    #   irb(User):029:0> end
    # irb(User):028:1*   p row
    #<CSV::Row "id":"1" "name":"1,2" "age":"60" "status":"normal">
    # => #<CSV::Table mode:col_or_row row_count:2>

    # csvのヘッダーのみ読込
    csv_header = CSV.read(file).first



    CSV.foreach(file.path, headers: true) do |row|

      # csvの値を変更する方法
      # row["status"] = row["status"].to_i

      # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      user = find_by(id: row["id"]) || new
      # CSVからデータを取得し、設定する
      # 更新を許可するカラムの値のみを抜粋する
      user.attributes = row.to_hash.slice(*updatable_attributes)
      # 保存する
      user.save
    end
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["id", "name", "age", "status"]
  end
end

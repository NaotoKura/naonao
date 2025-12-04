module Constants
  # 年代
  # 0: 未設定
  # 1: 10代（10歳 〜 19歳）
  # 2: 20代（20歳 〜 29歳）
  # 3: 30代（30歳 〜 39歳）
  # 4: 40代（40歳 〜 49歳）
  # 5: 50代（50歳 〜 59歳）
  # 6: 60代（60歳 〜 ）

  AGES = {
    "0": {display_name: "未設定",start_age: nil, end_age: nil},
    "1": {display_name: "10代", start_age: 10, end_age: 19},
    "2": {display_name: "20代",start_age: 20, end_age: 29},
    "3": {display_name: "30代",start_age: 30, end_age: 39},
    "4": {display_name: "40代",start_age: 40, end_age: 49},
    "5": {display_name: "50代",start_age: 50, end_age: 59},
    "6": {display_name: "60代以上",start_age: 60, end_age: nil}
  }.freeze

  # 年
  YEARS = [*1900..2020].freeze

  #性別
  # 1: 男
  # 2: 女
  # 3: 未設定
  GENDER_MAN = "1".freeze
  GENDER_WOMAN = "2".freeze
  GENDER_UNSELECT = "3".freeze

  GENDERS = {
    GENDER_MAN => "男",
    GENDER_WOMAN => "女",
    GENDER_UNSELECT => "未設定"
  }.freeze

  # 登録日
  # 1: 現在から30日前
  # 2: 現在から180日前
  # 3: 現在から365日前
  # 4: 現在から365日より前
  PERIOD = {
    "1": 30,
    "2": 180,
    "3": 365,
    "4": 365
  }.freeze
end

class User < ApplicationRecord
  has_one :board, dependent: :destroy
  has_many :posts
  has_many :likes
  belongs_to :prefecture
  has_one :user_detail
  has_many :tasks, dependent: :destroy # 担当するタスク
  has_many :created_tasks, class_name: 'Task', foreign_key: 'creator_id', dependent: :destroy # 作成したタスク
  has_many :schedule, dependent: :destroy

  # 新規登録保存の直前にgenerate_codeメソッドを呼び出している
  before_create :generate_code
  # 新規登録保存の直前にdetail_createメソッドを呼び出している
  before_create :detail_create

  has_secure_password

  has_many :posts
  include Discard::Model
  # 削除されていないものだけ返すようにする
  default_scope -> { kept }

  # 名前のあいまい検索（ユーザー検索画面）
  scope :search_name_like, -> name {
    where("name LIKE ?", "%#{name}%") if name.present?
  }

  # メールのあいまい検索（ユーザー検索画面）
  scope :search_email_like, -> email {
    where("email LIKE ?", "%#{email}%") if email.present?
  }

  # コードのあいまい検索（ユーザー検索画面）
  scope :search_code_like, -> code {
    where("code LIKE ?", "%#{code}%") if code.present?
  }

  # 年齢のから年代を検索（ユーザー検索画面）
  scope :search_start_age, -> age_id {
    return if age_id.blank?
    start_age = Constants::AGES[age_id.to_sym][:start_age]
    if start_age.present?
      where("age >= ?", start_age)
    else
      where(age: nil)
    end
  }

  # 年齢のから年代を検索（ユーザー検索画面）
  scope :search_end_age, -> age_id {
    return if age_id.blank? or Constants::AGES[age_id.to_sym][:end_age].nil?
    end_age = Constants::AGES[age_id.to_sym][:end_age]
    where("age <= ?", end_age)
  }

  # 都道府県の検索（ユーザー検索画面）
  scope :search_prefecture_id, -> prefecture_id {
    if prefecture_id.present?
      where(prefecture_id: prefecture_id == "0" ? nil : prefecture_id)
    end
  }

  # 生年月日の年を検索（ユーザー検索画面）
  scope :search_year, -> year {
    return if year.blank?
    where(year: year == "0" ? nil : year)
  }

  # 生年月日の月を検索（ユーザー検索画面）
  scope :search_month, -> month {
    return if month.blank?
    where(month: month == "0" ? nil : month)
  }

  # 投稿しているユーザー（ユーザー検索画面）
  scope :search_is_posts, -> is_posts {
    return if is_posts.blank?
    if is_posts == ["1"]
      joins(:posts).distinct
    elsif is_posts == ["0"]
      left_joins(:posts).where(posts: {id: nil})
    end
  }

  # 性別を検索（ユーザー検索画面）
  scope :search_genders, -> genders {
    return if genders.blank?
    where(gender: genders)
  }

  # 利用期間を検索（ユーザー検索画面）
  scope :search_period, -> period {
    return if period.blank?
    days = Constants::PERIOD[period.to_sym]
    date = (Time.current - 60 * 60 * 24 * days).midnight
    if period == "4"
      where("users.created_at <= ?", date)
    else
      where("users.created_at >= ?", date)
    end
  }
  # ページネート
  scope :pagenate, -> page, limit {
    page(page).per(limit)
  }

  # created_atを降順に並べ替えている
  scope :order_by_desc, -> {
    order(created_at: :desc)
  }

    # コードの完全一致（新規登録時）
    scope :search_code, -> code {
      where(code: code) if code.present?
    }

    # （いいね画面）
    scope :search_code_like, -> code {
      where("code LIKE ?", "%#{code}%") if code.present?
    }

  class << self
    def search(items)
      search_name_like(items[:name])
      .search_email_like(items[:email])
      .search_code_like(items[:code])
      .search_start_age(items[:age_id])
      .search_end_age(items[:age_id])
      .search_prefecture_id(items[:prefecture_id])
      .search_year(items[:year])
      .search_month(items[:month])
      .search_period(items[:period])
      .search_is_posts(items[:is_posts])
      .search_genders(items[:gender])
      .order_by_desc()
      .pagenate(items[:page], items[:limit])
    end
  end

  # def user_posts(page)
  #   posts.order(created_at: :desc).page(page).per(10)
  # end



  UPREGEX = /(?=.*?[A-Z])[A-Z]/.freeze
  LOWREGEX = /(?=.*?[a-z])[a-z]/.freeze
  NUMREGEX = /(?=.*?[\d])\d/.freeze
  SYMBOLREGEX = /(?=.*?[-.@_])[!-~]/.freeze

  validates :password, {
    length: { minimum: 8, maximum: 20 },
    format: {with: SYMBOLREGEX, message: "「@」「.」「_」「-」のうち1文字以上含めてください"},
    allow_nil: true
  }
  validates :password, format: {
    with: UPREGEX,
    message: "大文字を含めてください",
    allow_nil: true
  }
  validates :password, format: {
    with: LOWREGEX,
    message: "小文字を含めてください",
    allow_nil: true}
  validates :password, format: {
    with: NUMREGEX,
    message: "数字を含めてください",
    allow_nil: true}

  validate :password_check

  def password_check
    array = []
    arr = []
    if password
      pass = password.split('')
      pass.each do |x|
        if x.match?(/\W/) and x.match?(/[@._-]/)
          array.append(x)
        end
        if x.match?(/\W/)
          arr.append(x)
        end
      end
    end

    if array.length != arr.length
      errors.add(:password, "に使用できない文字が含まれています。")
    end
  end

  validates :code, length: { maximum: 20, on: :update }
  validate :code_check, on: :update

  def code_check
    unless code.ascii_only? || code.blank?
      errors.add(:code, "は半角英数字記号を用いてください")
    end
  end

  with_options uniqueness: true do
    validates :email
    validates :code, on: :update
  end

  validates :age, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 2,
    less_than_or_equal_to: 122,
    message: "は2歳以上、122歳以下にしてください",
    allow_nil: true
  }

  with_options presence: true do
    validates :name
    validates :email
    validates :code, on: :update
    validates :gender, on: :update
    validates :password, on: :create
    validates :password_confirmation, on: :create
  end

  def generate_code
    regex = /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[\d])(?=.*?[\W])/
    # 正規表現：大小英数字記号を1文字以上含む
    words = ("!".."~").to_a.join
    # 全ての大小英数字記号を取得し、文字列にしてwordsに代入している。
    is_valid = false
    until is_valid do # 繰り返し処理：is_validがtrueの時に処理が止まる
      code = ''
      20.times { code << words[rand(words.length)] }
      # ランダムに20回一文字ずつコードに代入している
      is_valid = code.match?(regex) and User.search_code(code).blank?
      # regexがtrue、かつ、完全一致するコードがdbにない
    end
    self.code = code # 保存前のUser.newのコードに代入している
  end

  def detail_create
    # 新規作成時にデフォルトとして設定している。
    self.user_detail.profile = "宜しくお願いします。"
  end
end

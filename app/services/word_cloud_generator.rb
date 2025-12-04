class WordCloudGenerator
  def initialize(text)
    @text = text
  end

  def generate
    words = []

    nm = Natto::MeCab.new
    nm.parse(@text) do |n|
      # 名詞だけを抽出
      features = n.feature.split(',')
      if features[0] == '名詞'
        words << n.surface
      end
    end

    # 単語ごとの出現回数をハッシュで集計
    word_count = words.each_with_object(Hash.new(0)) { |word, hash| hash[word] += 1 }

    # [{ text: "Ruby", size: 30 }, ...] の形式で返す（d3-cloud用）
    word_count.map { |word, count| { text: word, size: count * 10 } } # sizeの倍率は調整可能
  end
end

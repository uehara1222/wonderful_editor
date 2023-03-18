require "rails_helper"

RSpec.describe Article, type: :model do
  context "タイトルがある場合" do
    let!(:user) { create(:user) }

    it "記事を作れる" do
      article = build(:article)
      expect(article).to be_valid
    end
  end

  context "タイトルがない場合" do
    let!(:user) { create(:user) }

    it "記事を作れずエラーを返す" do
      article = build(:article, title: nil)
      expect(article).to be_invalid
      expect(article.errors.details[:title][0][:error]).to eq :blank
    end
  end
end

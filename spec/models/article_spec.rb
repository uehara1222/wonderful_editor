require "rails_helper"

RSpec.describe Article, type: :model do
  context "タイトルが入力されている場合" do
    let(:article) { build(:article) }

    it "下書き状態の記事の作成ができる" do
      expect(article).to be_valid
      expect(article.status).to eq "draft"
    end
  end

  context "タイトルはあるが本文がない場合" do
    let(:article) { build(:article, body: nil) }

    it "記事を公開状態では作成できない" do
      article.publish
      expect(article.status).to eq "published"
      expect(article).to be_invalid
      expect(article.errors.details[:body][0][:error]).to eq :blank
    end
  end

  context "タイトルが入力されてない場合" do
    let(:article) { build(:article, title: nil) }

    it "記事の作成ができない" do
      expect(article).to be_invalid
      expect(article.errors.details[:title][0][:error]).to eq :blank
    end
  end
end

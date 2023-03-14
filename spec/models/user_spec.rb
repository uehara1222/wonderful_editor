require 'rails_helper'

RSpec.describe User, type: :model do
  context "必要な情報が揃っている場合" do
    it "ユーザー登録ができる" do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  context "必要な情報が揃ってない場合" do
    it "ユーザー登録出来ずエラーを返す" do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors.details[:name][0][:error]).to eq :blank
    end
  end
end

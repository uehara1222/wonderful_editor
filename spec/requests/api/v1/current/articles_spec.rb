require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { current_user.create_new_auth_token }

  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    context "自分が書いた公開記事が複数ある時" do
      let!(:article1) { create(:article, :published, user: current_user, updated_at: 1.day.ago) }
      let!(:article2) { create(:article, :published, user: current_user, updated_at: 2.day.ago) }
      let!(:article3) { create(:article, :published, user: current_user) }
      let!(:article4) { create(:article, user: current_user) }
      let!(:article5) { create(:article, :published) }

      it "自分が書いた公開記事を更新順に取得できる" do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res.length).to eq 3
        expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
        expect(res[0]["user"]["id"]).to eq current_user.id
        expect(res[0]["user"]["name"]).to eq current_user.name
        expect(res[0]["user"]["email"]).to eq current_user.email
      end
    end
  end
end

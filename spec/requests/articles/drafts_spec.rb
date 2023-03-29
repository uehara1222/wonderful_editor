require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { current_user.create_new_auth_token }

  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    context "自分が書いた下書き記事がある時" do
      let!(:article1) { create(:article, user: current_user) }
      let!(:article2) { create(:article) }

      it "自分が書いた下書き記事の一覧が取得できる" do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res.length).to eq 1
        expect(res[0]["id"]).to eq article1.id
        expect(res[0].keys).to eq ["id", "title", "status", "updated_at", "user"]
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      end
    end
  end

  describe "GET /articles/drafts/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    context "指定した id の記事が存在して" do
      let(:article_id) { article.id }

      context "自分が書いた下書き記事の時" do
        let(:article) { create(:article, user: current_user) }

        it "記事の詳細を取得できる" do
          subject
          res = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)
          expect(res["id"]).to eq article.id
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["status"]).to eq article.status
          expect(res["updated_at"]).to be_present
          expect(res["user"]["id"]).to eq article.user.id
          expect(res["user"].keys).to eq ["id", "name", "email"]
        end
      end

      context "他のユーザーが書いた下書き記事の時" do
        let(:article) { create(:article) }

        it "記事が見つからない" do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end

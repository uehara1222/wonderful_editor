require 'rails_helper'

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST/ auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "必要な情報が揃っている時" do
      let(:params) { attributes_for(:user) }

      it "ユーザーの新規登録ができる" do
        expect{ subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(200)
        res = JSON.parse(response.body)
        expect( res["data"]["name"] ).to eq params[:name]
      end

      it "header情報を取得できる" do
        subject
        header = response.header
        expect( header["access-token"] ).to be_present
        expect( header["token-type"] ).to be_present
        expect( header["client"] ).to be_present
        expect( header["expiry"] ).to be_present
        expect( header["uid"] ).to be_present
      end
    end

    context "name がない時" do
      let(:params) { attributes_for(:user, name: nil) }
      it "エラーする" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(response).to have_http_status(422)
        expect(res["errors"]["name"]).to include "can't be blank"
      end
    end
    context "email がない時" do
      let(:params) { attributes_for(:user, email: nil) }
      it "エラーする" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(response).to have_http_status(422)
        expect(res["errors"]["email"]).to include "can't be blank"
      end
    end
    context "password がない時" do
      let(:params) { attributes_for(:user, password: nil) }
      it "エラーする" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(response).to have_http_status(422)
        expect(res["errors"]["password"]).to include "can't be blank"
      end
    end
  end
end

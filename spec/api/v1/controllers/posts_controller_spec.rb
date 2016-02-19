require 'rails_helper'
include RandomData

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:my_user){ create(:user) }
  let(:my_topic) {create(:topic)}
  let(:my_post) {create(:post, topic: my_topic, user: my_user)}

  context "unauthenitcated user" do

    it "PUT update returns http unauthenticated" do
      put :update, topic_id: my_topic.id, id: my_post.id, post: {title: "Post Title", body: RandomData.random_paragraph}
      expect(response).to have_http_status(401)
    end

    it "DELETE destroy returns http unauthenticated" do
      delete :destroy, topic_id: my_topic.id, id: my_post.id
      expect(response).to have_http_status(401)
    end
  end

  context "unauthorized user" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    it "PUT update returns http forbidden" do
      put :update, topic_id: my_topic.id, id: my_post.id, post: {title: "Post Title", body: RandomData.random_paragraph}
      expect(response).to have_http_status(403)
    end


    it "DELETE destroy returns http forbidden" do
      delete :destroy, topic_id: my_topic.id, id: my_post.id
      expect(response).to have_http_status(403)
    end
  end

  context "authenticated and authorized users" do
    before do
      my_user.admin!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
      @new_post = build(:post)
    end

    describe "PUT update" do
      before { put :update, id: my_post.id, post: {title: @new_post.title, body: @new_post.body}}

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "updates a post with the correct attributes" do
        updated_post = Post.find(my_post.id)
        expect(response.body).to eq(updated_post.to_json)
      end
    end


    describe "DELETE destroy" do
      before {delete :destroy, id: my_post.id}

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "deletes my_post" do
        expect{ Post.find(my_post.id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end

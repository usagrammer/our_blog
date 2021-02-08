require 'rails_helper'
describe PostsController, type: :request do

  before do
    @post = FactoryBot.create(:post)
  end

  describe 'GET #index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do 
      get root_path
      expect(response.status).to eq(200)
    end
    it 'indexアクションにリクエストするとレスポンスに投稿済みのポストのユーザー名が存在する' do 
     get root_path
     expect(response.body).to include(@post.user.nickname)
    end
    it 'indexアクションにリクエストするとレスポンスに投稿済みのポストのタイトルが存在する' do 
     get root_path
     expect(response.body).to include(@post.title)
    end
    it 'indexアクションにリクエストするとレスポンスにアプリ名が存在する' do 
      get root_path
      expect(response.body).to include('Our Blog')
    end
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do 
      get post_path(@post)
      expect(response.status).to eq 200
    end
    it 'showアクションにリクエストするとレスポンスに投稿済みのポストのコンテントが存在する' do 
      get post_path(@post)
      expect(response.body).to include(@post.content)
    end
    it 'showアクションにリクエストするとレスポンスに投稿済みのポストのタイトルが存在する' do 
      get post_path(@post)
      expect(response.body).to include(@post.title)
    end
  end 

end
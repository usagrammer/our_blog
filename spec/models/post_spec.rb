require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @post = FactoryBot.build(:post)
  end

  describe 'ポストの保存' do

    context 'ポストが投稿できる場合' do

      it 'titleとcontentがあれば投稿できる' do
        expect(@post).to be_valid
      end

    end

    context 'ポストが投稿できない場合' do

      it 'titleが空では投稿できない' do
        @post.title = ''

        @post.valid?
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        puts @post.errors.full_messages
        puts @post.attributes
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        expect(@post.errors.full_messages).to include("Title can't be blank")
      end

      it 'contentが空では投稿できない' do
        @post.content = ''
        
        @post.valid?
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        puts @post.errors.full_messages
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        expect(@post.errors.full_messages).to include("Content can't be blank")
      end

      it 'imageが空では投稿できない' do
        @post.image = nil
        
        @post.valid?
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        puts @post.errors.full_messages
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        expect(@post.errors.full_messages).to include("Image can't be blank")
      end

      it 'ユーザーが紐付いていなければ投稿できない' do
        @post.user = nil
        
        @post.valid?
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        puts @post.errors.full_messages
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        expect(@post.errors.full_messages).to include("User must exist")
      end

    end

  end

end

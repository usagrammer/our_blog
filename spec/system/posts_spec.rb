require 'rails_helper'

RSpec.describe 'ログインしている', type: :system do

  before do
    @user = FactoryBot.create(:user)
    @post = FactoryBot.build(:post, user: @user)
  end

  ########################

  shared_context '@post.userでログイン' do
    before do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        find('.header__right').find('a.header__right--btn[href="/users/sign_out"]')
      ).to have_content('ログアウト')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end

  end

  shared_context '新規投稿ページへアクセス' do
    before do
      # 新規投稿ページに移動する
      visit new_post_path
    end
  end

  shared_context '詳細ページへアクセス' do
    before do
      @post.save
      @new_title = 'bar'
      @new_content = 'foo'

      visit root_path
      # 投稿済みのpostをクリックする
      find('a.content__right__top--title:first-of-type').click
      expect(page).to have_content(@post.title)
    end
  end

  shared_context '編集ページへアクセス' do
    before do
      # 編集ページに移動する
      find('.postManage__edit').click
    end
  end

  ##################################

  context 'postが投稿できるとき' do 

    include_context '@post.userでログイン'
    include_context '新規投稿ページへアクセス'

    it '正しい情報を入力すればpostが投稿できてトップページに移動する' do
      # フォームに情報を入力する
      fill_in 'post_title', with: @post.title
      fill_in 'post_content', with: @post.content
      image_path = Rails.root.join('public/images/test.png')
      attach_file('post[image]', image_path)

      # 送信するとPostモデルのカウントが1上がる
      expect{
        find('input[name="commit"]').click
      }.to change { Post.count }.by(1)
      # トップページに遷移する
      expect(current_path).to eq root_path
      # トップページには先ほど投稿した内容のポストが存在する
      expect(
        find('.content__right__top--title:first-of-type')
      ).to have_content(@post.title)
      # 詳細ページに遷移する
      find('.content__right__top--title:first-of-type').click
      # 詳細ページには先ほど投稿したポストのcontentが存在する
      expect(page).to have_content(@post.content)
    end
  end

  context 'postが投稿できないとき' do

    include_context '@post.userでログイン'
    include_context '新規投稿ページへアクセス'

    it 'titleが不足していると投稿できない' do
      # フォームに情報を入力する
      fill_in 'post_title', with: nil
      fill_in 'post_content', with: @post.content
      # 送信するとPostモデルのカウントが上がらない
      expect{
        find('input[name="commit"]').click
      }.not_to change { Post.count }
    end

    it 'contentが不足していると投稿できない' do
      # フォームに情報を入力する
      fill_in 'post_title', with: @post.title
      fill_in 'post_content', with: nil
      # 送信するとPostモデルのカウントが上がらない
      expect{
        find('input[name="commit"]').click
      }.not_to change { Post.count }
    end

  end

  context 'postが編集できるとき' do

    include_context '@post.userでログイン'
    include_context '詳細ページへアクセス'
    include_context '編集ページへアクセス'

    it '正しい情報を入力すればpostが編集できてトップページに移動する' do
      # フォームに情報を入力する
      fill_in 'post_title', with: @new_title
      fill_in 'post_content', with: @new_content
      # 送信するとPostモデルのカウントが上がらない
      expect{
        find('input[name="commit"]').click
      }.not_to change { Post.count }
      # 詳細ページに遷移する
      expect(current_path).to eq post_path(@post)
      # 詳細ページには先ほど投稿したポストのcontentが存在する
      expect(page).to have_content(@new_content)
    end

  end

  context 'postが編集できないとき' do 

    include_context '@post.userでログイン'
    include_context '詳細ページへアクセス'
    include_context '編集ページへアクセス'

    it 'titleが不足していると更新できない' do
      # フォームに情報を入力する
      fill_in 'post_title', with: nil
      fill_in 'post_content', with: @new_content
      # 送信するとPostモデルのカウントが上がらない
      expect{
        find('input[name="commit"]').click
      }.not_to change { Post.count }
    end

    it 'contentが不足していると更新できない' do
      # フォームに情報を入力する
      fill_in 'post_title', with: @new_title
      fill_in 'post_content', with: nil
      # 送信するとPostモデルのカウントが上がらない
      expect{
        find('input[name="commit"]').click
      }.not_to change { Post.count }
    end

  end

  context 'postが削除できるとき' do 
    include_context '@post.userでログイン'
    include_context '詳細ページへアクセス'

    it '投稿者なら自分のpostを削除できる' do
      # 削除ボタンをクリック
      # Postモデルのカウントが1減る
      expect{
        find('.postManage__delete').click
      }.to change { Post.count }.by(-1)
    end

  end

  context 'postが削除できないとき' do
    include_context '@post.userでログイン'
    include_context '詳細ページへアクセス'

    it '投稿者でないなら自分のpostを削除できない' do
      ## @postのuserを別のuserにしておく
      another_user = FactoryBot.create(:user)
      @post.update(user: another_user)

      # 削除ボタンをクリック
      # Postモデルのカウントが1減る
      expect{
        find('.postManage__delete').click
      }.not_to change { Post.count }
    end
  end

  context 'ログインしていない' do

    before do
      @user = FactoryBot.create(:user)
      @post = FactoryBot.build(:post, user: @user)
    end

    context 'postが投稿できないとき' do

      it 'ログインしていないと新規投稿ページに遷移できない' do
        # 新規投稿ページへのリンクがない
        visit root_path
        expect(page).to have_no_content('新規投稿')
      end

    end

    context 'postが編集できないとき' do
      include_context '詳細ページへアクセス'

      it 'ログインしていないと編集ボタンが表示されない' do
        expect(page).to have_no_content('編集')
      end

      it 'ログインしていないと編集ページに遷移できない' do
        # 無理やり編集ページへアクセスする
        visit edit_post_path(@post)
        # ログインページに遷移する
        expect(current_path).to eq new_user_session_path
      end

    end

    context 'postが削除できないとき' do
      include_context '詳細ページへアクセス'

      it 'ログインしていないと削除ボタンが表示されない' do
        expect(page).to have_no_content('削除')
      end

    end

  end

end
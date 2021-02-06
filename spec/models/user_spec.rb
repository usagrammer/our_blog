require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録できるとき' do
      it 'nicknameとemail、passwordとpassword_confirmationが存在すれば登録できる' do
        expect(@user).to be_valid
      end
      it 'nicknameが6文字以下であれば登録できる' do
        @user.nickname = 'foobar'
        expect(@user).to be_valid
      end
      it 'passwordとpassword_confirmationが6文字以上であれば登録できる' do
        @user.password = 'foobar'
        @user.password_confirmation = @user.password
        expect(@user).to be_valid
      end
    end
    context '新規登録できないとき' do
      it 'nicknameが空では登録できない' do
        @user.nickname = ''
        @user.valid?
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        puts @user.errors.full_messages
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end
      it 'emailが空では登録できない' do
        @user.email = ''
        @user.valid?
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        puts @user.errors.full_messages
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        expect(@user.errors.full_messages).to include("Email can't be blank")        
      end
      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        puts @user.errors.full_messages
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      it 'passwordが存在してもpassword_confirmationが空では登録できない' do
        @user.password_confirmation = ''
        @user.valid?
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        puts @user.errors.full_messages
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it 'nicknameが7文字以上では登録できない' do
        @user.nickname = 'hogefuga'
        @user.valid?
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        puts @user.errors.full_messages
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        expect(@user.errors.full_messages).to include("Nickname is too long (maximum is 6 characters)")
      end
      it '重複したemailが存在する場合登録できない' do
        user2 = FactoryBot.build(:user)
        user2.email = @user.email
        user2.save
        @user.valid?
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        puts @user.errors.full_messages
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        expect(@user.errors.full_messages).to include("Email has already been taken")
      end
      it 'passwordが5文字以下では登録できない' do
        @user.password = 'hoge3'
        @user.password_confirmation = @user.password
        @user.valid?
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        puts @user.errors.full_messages
        puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      end
    end
  end
  
end

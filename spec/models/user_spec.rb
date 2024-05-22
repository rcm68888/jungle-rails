require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'verifies a user is created a with matching password and password_confirmation fields' do
      @user = User.create({ first_name: 'Richard', last_name: 'Smith', email: 'richardsmith@example.com', password: 'p@ssw0rd!!', password_confirmation: 'p@ssw0rd!!' })
      @user.valid?
      expect(@user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it 'verifies the presence of email' do
      @user = User.create({ first_name: 'Richard', last_name: 'Smith', email: nil, password: 'p@ssw0rd!!', password_confirmation: 'p@ssw0rd!!' })
      @user.valid?
      expect(@user.errors[:email]).to include("can't be blank")
    end

    it 'verifies the uniqueness of emails (case insensitive)' do
      @user = User.create({ first_name: 'Richard', last_name: 'Smith', email: 'richardsmith@example.com', password: 'p@ssw0rd!!', password_confirmation: 'p@ssw0rd!!' })
      @user2 = User.create({ first_name: 'Richard', last_name: 'Smith', email: 'RichardSmith@Example.com', password: 'p@ssw0rd!!', password_confirmation: 'p@ssw0rd!!' })
      @user2.valid?
      expect(@user.errors[:email]).to include("has already been taken")
    end

    it 'verifies the presence of a first name' do
      @user = User.create({ first_name: nil, last_name: 'Smith', email: 'richardsmith@example.com', password: 'p@ssw0rd!!', password_confirmation: 'p@ssw0rd!!' })
      @user.valid?
      expect(@user.errors[:first_name]).to include("can't be blank")
    end

    it 'verifies the presence of a last name' do
      @user = User.create({ first_name: 'Richard', last_name: nil, email: 'richardsmith@example.com', password: 'p@ssw0rd!!', password_confirmation: 'p@ssw0rd!!' })
      @user.valid?
      expect(@user.errors[:last_name]).to include("can't be blank")
    end
  end

  describe '.authenticate_with_credentials' do
    it 'should allow successful authentication of email with leading whitespace' do
      @user = User.create({ first_name: 'Richard', last_name: 'Smith', email: 'richardsmith@example.com', password: 'p@ssw0rd!!', password_confirmation: 'p@ssw0rd!!' })
      authenticated_user = User.authenticate_with_credentials ' richardsmith@example.com', @user.password
      expect(authenticated_user).to_not be_nil
    end

    it 'should allow successful authentication of emails with trailing whitespace' do
      @user = User.create({ first_name: 'Richard', last_name: 'Smith', email: 'richardsmith@example.com', password: 'p@ssw0rd!!', password_confirmation: 'p@ssw0rd!!' })
      authenticated_user = User.authenticate_with_credentials 'email@email.com ', @user.password
      expect(authenticated_user).to_not be_nil
    end

    it 'should allow successful authentication of emails with mismatching case' do
      @user = User.create({ first_name: 'Richard', last_name: 'Smith', email: 'richardsmith@example.com', password: 'p@ssw0rd!!', password_confirmation: 'p@ssw0rd!!' })
      authenticated_user = User.authenticate_with_credentials 'email@email.com', @user.password
      expect(authenticated_user).to_not be_nil
    end

    it 'should allow successful authentication given the correct email and password combination' do
      @user = User.create({ first_name: 'Richard', last_name: 'Smith', email: 'richardsmith@example.com', password: 'p@ssw0rd!!', password_confirmation: 'p@ssw0rd!!' })
      
      authenticated_user = User.authenticate_with_credentials @user.email, @user.password
      expect(authenticated_user).to_not be_nil
    end

    it 'should not allow successful authentication given the incorrect email and password combination' do
      @user = User.create({ first_name: 'Richard', last_name: 'Smith', email: 'richardsmith@example.com', password: 'p@ssw0rd!!', password_confirmation: 'p@ssw0rd!!' })
      
      authenticated_user = User.authenticate_with_credentials 'Rich', 'Doe'
      expect(authenticated_user).to be_nil
    end
  end

end
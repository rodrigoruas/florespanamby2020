require 'rails_helper'
RSpec.describe User, type: :model do
  context 'validation_tests' do
    let(:user) { build(:user)}
    it 'ensures first name presence' do
      user.first_name = nil
      expect(user.save).to eq(false)
    end
    it 'ensures last_name presence' do
      user.last_name = nil
      expect(user.save).to eq(false)
    end
    it 'ensures cpf presence' do
      user.cpf = nil
      expect(user.save).to eq(false)
    end
    it 'ensures e-mail presence' do
      user.email = nil
      expect(user.save).to eq(false)
    end
    it 'ensures e-mail format' do
      user.email = "blablabla"
      expect(user.save).to eq(false)
    end
    it 'ensures cpf format' do
      user.cpf = "123"
      expect(user.save).to eq(false)
    end
    it 'should save successfully' do
      expect(user.save).to eq(true)
    end
  end

  context 'scope_tests' do
    let(:users) {create_list(:random_user, 5)}
    before (:each) do
      users.last(2).map{ |u| u.update(admin: true)}
    end
    it 'should return admin users' do
      expect(User.admin_users.size).to eq(2)
    end
    it 'should return not admin users' do
      expect(User.not_admin_users.size).to eq(3)
    end
  end
end

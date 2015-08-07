require 'spec_helper'

describe User do
  let!(:user) { create(:user) }

  describe '#masquerade!' do
    it 'should cache special key on masquerade' do
      expect(SecureRandom).to receive(:urlsafe_base64).with(16) { "secure_key" }
      user.masquerade!
    end
  end

  describe '#remove_masquerade_key' do
    before { allow(SecureRandom).to receive(:urlsafe_base64) { "secure_key" } }

    let(:key) { 'users:secure_key:masquerade' }

    it 'should be possible to remove cached masquerade key' do
      user.masquerade!
      expect(Rails.cache.exist?(key)).to eq(true)

      User.remove_masquerade_key!('secure_key')
      expect(Rails.cache.exist?(key)).to eq(false)
    end
  end

  describe '#find_by_masquerade_key' do
    it 'should be possible to find user by generate masquerade key' do
      user.masquerade!

      allow(Rails.cache).to receive(:read).with("users:#{user.masquerade_key}:masquerade") { user.id }
      allow(Rails.cache).to receive(:delete).with("users:#{user.masquerade_key}:masquerade")

      new_user = User.find_by_masquerade_key(user.masquerade_key)

      expect(new_user).to eq(user)
    end
  end
end

require 'spec_helper'

describe User do
  let!(:user) { create(:user) }

  describe '#masquerade!' do
    it 'should cache special key on masquerade' do
      SecureRandom.should_receive(:base64).with(16).and_return("secure_key")

      user.masquerade!
    end
  end

  describe '#find_by_masquerade_key' do
    it 'should be possible to find user by generate masquerade key' do
      user.masquerade!

      Rails.cache.should_receive(:read).with("users:#{user.masquerade_key}:masquerade").and_return(user.id)

      new_user = User.find_by_masquerade_key(user.masquerade_key)

      new_user.should == user
    end
  end
end


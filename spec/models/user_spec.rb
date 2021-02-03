require 'spec_helper'

describe User do
  let!(:user) { create(:user) }

  describe '#masquerade_key' do
    it 'should cache special key on masquerade' do
      expect(user).to receive(:to_sgid).with(expires_in: 1.minute, for: 'masquerade') { "secure_key" }
      user.masquerade_key
    end
  end
end

require 'rails_helper'

RSpec.describe Session do
  let(:session) { Session.new(session_id: SecureRandom.uuid) }

  it 'accepts serialized genres' do
    session.genres = ['indie folk']
    expect(session.save).to be(true)
    expect(session.reload.genres).to eq(['indie folk'])
  end
end

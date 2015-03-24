require 'spec_helper'

describe 'Segment Relay' do
  it 'should successfully post a tracking event' do
    params = {
      version: 1,
      type: 'track',
      userId: '019mr8mf4r',
      event: 'Purchased an Item',
      properties: {
        revenue: '39.95',
        shippingMethod: '2-day'
      },
      timestamp: '2012-12-02T00:30:08.276Z'
    }
    post '/', params.to_json

    expect(last_response).to be_ok
  end
end

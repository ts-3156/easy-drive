require 'spec_helper'

describe EasyDrive::Files do
  let(:client) { EasyDrive::Client.new }
  describe '#copy' do
    it '10 is 10' do
      client.copy('file_id', 'folder_id', {title: 'title'})
      expect(10).to eq(10)
    end
  end
end

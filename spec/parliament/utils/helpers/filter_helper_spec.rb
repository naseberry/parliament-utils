require 'spec_helper'

RSpec.describe Parliament::Utils::Helpers::FilterHelper, vcr: true do

  it 'is a module' do
    expect(subject).to be_a(Module)
  end
 
  context '#filter' do
    it 'filters one type' do
      house = subject.filter(Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_index, 'House').first
      expect(house.type).to eq("https://id.parliament.uk/schema/House")
    end

    it 'filters a variable number of types' do
      house, party = subject.filter(Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_parties.set_url_params({house_id: '1AFu55Hs'}), 'House', 'Party')
      house = house.first
      party = party.first
      expect(house.type).to eq("https://id.parliament.uk/schema/House")
      expect(party.type).to eq("https://id.parliament.uk/schema/Party")
    end

    it 'filters ordnance types correctly' do
      places = Parliament::Utils::Helpers::FilterHelper.filter(Parliament::Utils::Helpers::ParliamentHelper.parliament_request.region_index, 'ordnance')
      expect(places.first.type).to eq("http://data.ordnancesurvey.co.uk/ontology/admingeo/EuropeanRegion")
    end
  end

  context '#filter_types' do
    it 'checks whether the type is ordnance' do
      expect(subject.filter_types('House', 'ordnance')).to eq([Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('House'), 'http://data.ordnancesurvey.co.uk/ontology/admingeo/EuropeanRegion'])
    end
  end

  context '#filter_sort' do
    it 'filters and then sorts types passed in' do
      constituencies, letters = subject.filter_sort(Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituency_current, :name, 'ConstituencyGroup', ::Grom::Node::BLANK)
      expect(constituencies[0].name).to eq("constituencyGroupName - 1")
      expect(constituencies[1].name).to eq("constituencyGroupName - 10")
      expect(constituencies[2].name).to eq("constituencyGroupName - 100")
    end
  end
end
require 'spec_helper'
describe 'winnetwork' do

  context 'with defaults for all parameters' do
    it { should contain_class('winnetwork') }
  end
end

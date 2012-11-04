require 'spec_helper'

describe Movie do
  describe 'find similar movies' do
    it 'should call Movie with director param' do
      # actual test
      Movie.should_receive(:where).with(hash_including :director => 'klapish')
      Movie.find_similar('klapish')
    end
  end
end
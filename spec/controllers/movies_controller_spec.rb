require 'spec_helper'

describe MoviesController do
  describe 'searching similar movies' do
    before :each do
      @fake_source = mock('source')
      @fake_source.stub(:director).and_return('copolla')
      @fake_results = [mock('movie1'),mock('movie2')]
    end
    it 'should call the model method that finds a movie by its ID' do
      # prepare test
      Movie.stub(:find_similar)
      # actual test
      Movie.should_receive(:find).with("1").and_return(@fake_source)
      get :similar, {:id => 1}
    end
    it 'should call the model method that performs similar movies search' do
      # prepare test
      Movie.stub(:find).and_return(@fake_source)
      # actual test
      Movie.should_receive(:find_similar).with('copolla').and_return(@fake_results)
      get :similar, {:id => 1}
    end
    it 'should select the similar movies search results template for rendering' do
      # prepare test
      Movie.stub(:find).and_return(@fake_source)
      Movie.stub(:find_similar).and_return(@fake_results)
      # actual test
      get :similar, {:id => 1}
      response.should render_template('similar')      
    end
    it 'should make the similar movies search results available to the template'
  end
end

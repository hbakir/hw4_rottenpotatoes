require 'spec_helper'

describe MoviesController do
  describe 'show details' do
    it 'should select the details template for rendering' do
      # prepare test
      fake_movie = mock('movie')
      Movie.stub(:find).and_return(fake_movie)
      # actual test
      get :show, {:id => 1}
      response.should render_template('show')      
    end
  end
  describe 'create movie' do
    it 'should call the model method that created movies' do
      @fake_movie = FactoryGirl.build(:movie, :title => 'Milk', :rating => 'R')
      Movie.should_receive(:create!).and_return(@fake_movie)
      post :create, {:movie => @fake_movie}
    end
    it 'should redirect to movies page with notice that movie was created' do
      # prepare test
      @fake_movie = FactoryGirl.build(:movie, :title => 'Milk', :rating => 'R')
      Movie.stub(:create!).and_return(@fake_movie)
      # actual test
      post :create, {:movie => @fake_movie}
      flash[:notice].should_not be_nil
      response.should redirect_to(movies_path)
    end
  end
  describe 'update movie' do
    it 'should call the model method that updates the movie' do
      @fake_movie = FactoryGirl.build(:movie, :id => 1, :title => 'Milk', :rating => 'R')
      Movie.stub(:find).and_return(@fake_movie)
      @fake_movie.should_receive(:update_attributes!)
      put :update, {:id => 1, :movie => @fake_movie}
    end
    it 'should redirect to movie page with notice that movie was updated' do
      # prepare test
      @fake_movie = FactoryGirl.build(:movie, :title => 'Milk', :rating => 'R')
      Movie.stub(:find).and_return(@fake_movie)
      # @fake_movie.stub(:update_attributes!)
      # actual test
      put :update, {:id => 1, :movie => @fake_movie}
      flash[:notice].should_not be_nil
      response.should redirect_to(movie_path)
    end
  end
  describe 'destroy movie' do
    it 'should call the model method that destroys the movie' do
      @fake_movie = FactoryGirl.build(:movie, :id => 1, :title => 'Milk', :rating => 'R')
      Movie.stub(:find).and_return(@fake_movie)
      @fake_movie.should_receive(:destroy)
      delete :destroy, {:id => 1}
    end
    it 'should redirect to movies page with notice that movie was deleted' do
      # prepare test
      @fake_movie = FactoryGirl.build(:movie, :title => 'Milk', :rating => 'R')
      Movie.stub(:find).and_return(@fake_movie)
      @fake_movie.stub(:destroy)
      # actual test
      delete :destroy, {:id => 1}
      flash[:notice].should_not be_nil
      response.should redirect_to(movies_path)
    end
  end
  describe 'edit movie' do
    it 'should select the details template for rendering' do
      # prepare test
      fake_movie = mock('movie')
      Movie.stub(:find).and_return(fake_movie)
      # actual test
      get :edit, {:id => 1}
      response.should render_template('edit')      
    end
    it 'should make the edited movie available to the template' do
      # prepare test
      fake_movie = mock('movie')
      Movie.stub(:find).and_return(fake_movie)
      # actual test
      get :edit, {:id => 1}
      assigns(:movie).should == fake_movie
    end
  end
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
    it 'should make the similar movies search results available to the template' do
      # prepare test
      Movie.stub(:find).and_return(@fake_source)
      Movie.stub(:find_similar).and_return(@fake_results)
      # actual test
      get :similar, {:id => 1}
      assigns(:movies).should == @fake_results
    end
    it 'should redirect to home page with notice that movie has no Director' do
      # prepare test
      @fake_no_director = mock('no_director')
      @fake_no_director.stub(:director).and_return('')
      @fake_no_director.stub(:title).and_return('1941')
      Movie.stub(:find).and_return(@fake_no_director)
      # actual test
      get :similar, {:id => 1}
      flash[:notice].should_not be_nil
      response.should redirect_to(root_path)
    end
  end
end

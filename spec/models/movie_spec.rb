require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:categories).class_name('Category') }
    it { should belong_to(:user).class_name('User') }
    it { should have_many(:comments).class_name('Comment') }
    it { should have_one_attached(:cover_image) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:synopsis) }
    it { should validate_presence_of(:director) }
    it { should validate_presence_of(:release_year) }
    it do
      should validate_numericality_of(:release_year)
        .only_integer
        .is_greater_than_or_equal_to(1888)
        .is_less_than_or_equal_to(Date.current.year + 5)
    end
    it { should validate_presence_of(:duration) }
    it { should validate_numericality_of(:duration).only_integer.is_greater_than(0) }
  end

  describe 'scopes' do
    let!(:movie_2020) { FactoryBot.create(:movie, release_year: 2020, director: "Spielberg") }
    let!(:movie_2021) { FactoryBot.create(:movie, release_year: 2021, director: "Nolan") }
    let!(:category_action) { FactoryBot.create(:category, name: "Action") }
    let!(:category_drama) { FactoryBot.create(:category, name: "Drama") }

    before do
      movie_2020.categories << category_action
      movie_2021.categories << category_drama
    end

    describe '.by_category' do
      it 'returns movies filtered by category name' do
        expect(Movie.by_category('Action')).to include(movie_2020)
        expect(Movie.by_category('Action')).not_to include(movie_2021)
      end

      it 'returns nil if category name is blank' do
        expect(Movie.by_category(nil)).to be_nil
        expect(Movie.by_category('')).to be_nil
      end
    end

    describe '.by_year' do
      it 'returns movies filtered by release_year' do
        expect(Movie.by_year(2020)).to include(movie_2020)
        expect(Movie.by_year(2020)).not_to include(movie_2021)
      end

      it 'returns nil if year is blank' do
        expect(Movie.by_year(nil)).to be_nil
      end
    end

    describe '.by_director' do
      it 'returns movies filtered by director name (ILIKE)' do
        expect(Movie.by_director('Spielberg')).to include(movie_2020)
        expect(Movie.by_director('Spielberg')).not_to include(movie_2021)
      end

      it 'is case insensitive' do
        expect(Movie.by_director('spielberg')).to include(movie_2020)
      end

      it 'returns nil if director_name is blank' do
        expect(Movie.by_director(nil)).to be_nil
        expect(Movie.by_director('')).to be_nil
      end
    end
  end

  describe 'tags' do
    let(:movie) { FactoryBot.create(:movie) }

    it 'can have tags' do
      movie.tag_list.add("sci-fi", "adventure")
      movie.save
      expect(movie.tag_list).to include("sci-fi", "adventure")
    end
  end

  describe 'cover image' do
    let(:movie) { FactoryBot.create(:movie) }

    it 'can attach a cover image' do
      movie.cover_image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample.jpg')), filename: 'sample.jpg', content_type: 'image/jpg')
      expect(movie.cover_image).to be_attached
    end
  end
end

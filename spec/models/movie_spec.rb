require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:categories).class_name('Category') }
    it { should belong_to(:user).class_name('User') }
    it { should have_many(:comments).class_name('Comment') }
  end


  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:synopsis) }
    it { should validate_presence_of(:director) }
    it { should validate_presence_of(:release_year) }
    it do
      should validate_numericality_of(:release_year).
      only_integer.
      is_greater_than_or_equal_to(1888).
      is_less_than_or_equal_to(Date.current.year + 5)
    end
    it { should validate_presence_of(:duration) }
    it { should validate_numericality_of(:duration).only_integer.is_greater_than(0) }
  end

  describe 'scopes' do
    context '.default_scope' do
      context 'when there are movies with different created_at timestamps' do
        let!(:new_movie) { FactoryBot.create(:movie) }

        before { FactoryBot.create_list(:movie, 3, created_at: 2.days.ago) }

        it 'orders movies by created_at descending' do
          expect(Movie.all.first).to eq(new_movie)
        end
      end
      context 'when there are no movies' do
        it 'returns an empty array' do
          expect(Movie.all).to be_empty
        end
      end
    end
  end
end

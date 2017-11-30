require 'rails_helper'

RSpec.describe Context, type: :model do
  describe 'Factory' do
    it 'should have a valid factory' do
      expect(FactoryBot.build(:context)).to be_valid
    end
    it 'should have a valid factory with trait with_context' do
      expect(FactoryBot.build(:context, :with_context)).to be_valid
    end
    it 'should have a valid factory with trait with_contexts' do
      expect(FactoryBot.build(:context, :with_contexts)).to be_valid
    end
    it 'should have a valid factory with all traits' do
      expect(FactoryBot.build(:context, :with_context, :with_contexts)).to be_valid
    end
  end
  describe 'Validations' do
    it 'should be invalid without name' do
      expect(FactoryBot.build(:context, name: nil)).to_not be_valid
    end
    it 'should be invalid when name=""' do
      expect(FactoryBot.build(:context, name: '')).to_not be_valid
    end
    it 'should be invalid without user' do
      expect(FactoryBot.build(:context, user: nil)).to_not be_valid
    end
    it 'should be valid without context' do
      expect(FactoryBot.build(:context, context: nil)).to be_valid
    end
  end
  describe 'Relations' do
    before do
      @context = FactoryBot.build(:context, :with_context, :with_contexts)
    end
    it 'should have a User' do
      expect(@context.user).to be_a User
    end
    it 'should have a Context' do
      expect(@context.context).to be_a Context
    end
    it 'should have many Contexts' do
      expect(@context.contexts.first).to be_a Context
    end
  end
  describe 'get_full_name' do
    context 'without parrent' do
      before do
        @context = FactoryBot.build(:context)
      end
      it 'should return its own name exactly' do
        expect(@context.get_full_name).to eq @context.name
      end
    end
    context 'with parrent(s)' do
      before do
        @context = FactoryBot.build(:context, :with_context)
      end
      it 'should return its parrents get_full_name and its name joined by a colon' do
        expect(@context.get_full_name).to eq "#{@context.context.name}:#{@context.name}"
      end
      it 'should have one colon per parent' do
        expect {
          @context.context.context = FactoryBot.build(:context)
        }.to change{
          @context.get_full_name.count ':'
        }.by 1
      end
    end
  end
end

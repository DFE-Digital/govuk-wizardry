require 'rails_helper'

describe Wizardry::Instance do
  include_context 'setup simple wizard'
  let(:object) { SomeObject.new(field_one: 'abc', field_two: 'def', field_three: nil) }

  context 'when the previous pages have been completed and are valid' do
    subject do
      Wizardry::Instance.new(
        current_page: :page_three,
        object: object,
        framework: framework
      )
    end

    specify '#route contains :page_one and :page_two' do
      expect(subject.route.map(&:name)).to eql([:page_one, :page_two])
    end

    it { is_expected.to be_valid_so_far }
  end

  context %(when the previous pages haven't all been completed and some aren't valid) do
    subject do
      Wizardry::Instance.new(
        current_page: :check_your_answers,
        object: object,
        framework: framework
      )
    end

    specify '#route contains :page_one, :page_two and :page_three' do
      expect(subject.route.map(&:name)).to eql([:page_one, :page_two, :page_three])
    end

    it { is_expected.to_not be_valid_so_far }
  end
end

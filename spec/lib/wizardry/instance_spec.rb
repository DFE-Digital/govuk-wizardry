require 'rails_helper'

describe Wizardry::Instance do
  include_context 'setup simple wizard'

  let(:current_page_name) { :page_three }
  let(:object_attributes) { { field_one: 'abc', field_two: 'def', field_three: 'ghi' } }
  let(:object) { SomeObject.new(**object_attributes) }

  subject do
    Wizardry::Instance.new(
      current_page: current_page_name,
      object: object,
      framework: framework
    )
  end

  describe '#next_page' do
    it { is_expected.to respond_to(:next_page).with(0..1).arguments }

    specify "correctly identifies the next page" do
      {
        page_one: :page_two,
        page_two: :page_three,
        page_three: :check_your_answers,
        check_your_answers: :completion,
      }.each do |current_page_name, next_page_name|
        current_page = subject.framework.pages.detect { |p| p.name == current_page_name }

        expect(subject.next_page(current_page).name).to eql(next_page_name)
      end
    end
  end

  describe '#next_incomplete_page' do
    let(:current_page_name) { :page_two }
    let(:object_attributes) { { field_one: 'abc', field_two: 'def' } }

    specify "correctly identifies the next incomplete page" do
      expect(subject.next_incomplete_page.name).to eql(:page_three)
    end
  end

  describe '#route' do
    it { is_expected.to respond_to(:route).with(0..1).arguments }

    describe "linear routes" do
      {
        page_one: OpenStruct.new(
          route: [],
          object_attributes: {}
        ),
        page_two: OpenStruct.new(
          route: %i(page_one),
          object_attributes: { field_one: 'abc' }
        ),
        page_three: OpenStruct.new(
          route: %i(page_one page_two),
          object_attributes: { field_one: 'abc', field_two: 'def' }
        ),
        check_your_answers: OpenStruct.new(
          route: %i(page_one page_two page_three),
          object_attributes: { field_one: 'abc', field_two: 'def', field_three: 'ghi' }
        ),
        completion: OpenStruct.new(
          route: %i(page_one page_two page_three check_your_answers),
          object_attributes: { field_one: 'abc', field_two: 'def', field_three: 'ghi' }
        ),
      }.each do |current_page_name, options|
        context "when on #{current_page_name}" do
          let(:current_page_name) { current_page_name }
          let(:object_attributes) { options.object_attributes }

          specify %(correctly identifies the route as #{options.route.empty? ? 'empty' : options.route.join('->')}) do
            expect(subject.route.map(&:name)).to eql(options.route)
          end
        end
      end
    end

    describe %(branching) do
      include_context 'setup branched wizard'
      let(:object) { SomeObjectWithOptionalSteps.new }
      let(:current_page_name) { :page_five }

      specify '#route omits the optional page' do
        expect(subject.route.map(&:name)).to eql(%i(page_one page_two page_four))
      end

      context 'when the answers will take us down the optional path' do
        let(:object) { SomeObjectWithOptionalSteps.new(field_two: "Shazam") }

        specify '#route contains the optional page' do
          expect(subject.route.map(&:name)).to eql(%i(page_one page_two page_three))
        end
      end
    end
  end

  describe '#valid_so_far?' do
    it { is_expected.to respond_to(:valid_so_far?).with(0).arguments }

    context 'when the previous pages have been completed and are valid' do
      let(:object_attributes) { { field_one: 'abc', field_two: 'def', field_three: 'ghi' } }

      subject do
        Wizardry::Instance.new(
          current_page: :page_three,
          object: object,
          framework: framework
        )
      end

      specify "valid so far" do
        expect(subject.route.map(&:name)).to eql(%i(page_one page_two))
        is_expected.to be_valid_so_far
      end
    end

    context %(when the previous pages haven't all been completed and some aren't valid) do
      let(:object_attributes) { { field_one: 'abc', field_two: nil, field_three: 'ghi' } }

      subject do
        Wizardry::Instance.new(
          current_page: :check_your_answers,
          object: object,
          framework: framework
        )
      end

      specify "not valid so far" do
        expect(subject.route.map(&:name)).to eql(%i(page_one page_two page_three))
        is_expected.to_not be_valid_so_far
      end
    end
  end
end

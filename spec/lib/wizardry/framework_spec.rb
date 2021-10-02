require 'rails_helper'

describe Wizardry::Framework do
  let(:wizard_name) { 'desserts' }

  let(:favourite_dessert_page) { double(Wizardry::Pages::QuestionPage, name: :favourite_dessert, pages: [], branch?: false) }
  let(:cherries_page)          { double(Wizardry::Pages::QuestionPage, name: :cherries,          pages: [], branch?: false) }
  let(:favourite_topping_page) { double(Wizardry::Pages::QuestionPage, name: :favourite_topping, pages: [], branch?: true) }

  let(:pages) { [favourite_dessert_page, cherries_page, favourite_topping_page] }

  subject do
    Wizardry::Framework.new(
      name: wizard_name,
      class_name: 'Dessert',
      edit_path_helper: :desserts_page_path,
      update_path_helper: :dessert_path,
      pages: pages,
    )
  end

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:class_name) }
  it { is_expected.to respond_to(:edit_path_helper) }
  it { is_expected.to respond_to(:update_path_helper) }

  describe "#cookie_name" do
    specify %(is the wizard name followed by '-wizard') do
      expect(subject.cookie_name).to eql("#{wizard_name}-wizard")
    end
  end

  describe '#pages' do
    specify "returns all pages" do
      expect(subject.pages).to match_array(pages)
    end

    context "when there are nested pages" do
      let(:calories_page) { double(Wizardry::Pages::QuestionPage, name: :calories, pages: [], branch?: true, branch!: true) }
      let(:pages) { [double(Wizardry::Pages::QuestionPage, name: :favourite_dessert, pages: [calories_page], branch?: false)] }

      specify "the pages are flattened to an array" do
        expect(subject.pages.map(&:name)).to eql(%i(favourite_dessert calories))
      end
    end
  end

  describe '#trunk_pages' do
    specify "excludes any branch pages" do
      expect(subject.trunk_pages.map(&:name)).not_to include(:favourite_topping)
    end
  end

  describe '#branch_pages' do
    specify "only includes branch pages" do
      expect(subject.branch_pages.map(&:name)).to eql([:favourite_topping])
    end
  end

  describe "#page_names" do
    specify "returns all page names (including branches)" do
      expect(subject.page_names).to match_array(%i(favourite_dessert favourite_topping cherries))
    end
  end

  describe "#page" do
    it { is_expected.to respond_to(:page).with(1).argument }

    specify "returns the named page object" do
      expect(subject.page(:cherries)).to eql(cherries_page)
    end
  end
end

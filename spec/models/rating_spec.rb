require 'rails_helper'

RSpec.describe(Rating, type: :model) do
  # string column with not null
  it { is_expected.to(have_db_column(:identifier).of_type(:string).with_options(null: false)) }

  # string columns
  %i(last_completed_step full_name name address_1 address_2 town postcode phone email customer_type).each do |column|
    it { is_expected.to(have_db_column(column).of_type(:string)) }
  end

  # other column types
  it { is_expected.to(have_db_column(:purchase_date).of_type(:date)) }
  it { is_expected.to(have_db_column(:feedback).of_type(:text)) }
  it { is_expected.to(have_db_column(:rating).of_type(:integer)) }
end

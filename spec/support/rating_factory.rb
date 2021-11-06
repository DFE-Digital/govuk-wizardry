class RatingFactory
  class RatingAttributeBuilder
    attr_accessor :last_completed_step

    def initialize(last_completed_step)
      self.last_completed_step = last_completed_step
    end

    def attrs
      case last_completed_step
      when 'started'
        minimum
      when 'identification'
        minimum.merge(**identification)
      when 'address'
        minimum.merge(**identification, **address)
      when 'contact_details'
        minimum.merge(**identification, **address, **contact_details)
      when 'rating'
        minimum.merge(**identification, **address, **contact_details, **rating)
      when 'check_your_answers'
        minimum.merge(**identification, **address, **contact_details, **rating, **check_your_answers)
      else
        fail ArgumentError, "unknown page #{last_completed_step}"
      end
    end

  private

    def minimum
      { identifier: SecureRandom.uuid }
    end

    def identification
      { full_name: 'Nelson Muntz', name: 'Nelson', last_completed_step: 'identification' }
    end

    def address
      { address_1: '234 Something Street', town: 'Springfield', postcode: 'S2 3JF', last_completed_step: 'address' }
    end

    def contact_details
      { phone: '01212 123 1234', email: 'nmuntz@something.org', last_completed_step: 'contact_details' }
    end

    def rating
      { customer_type: 'New customer', purchase_date: 2.weeks.ago, feedback: 'Super great, yeah', rating: 3, last_completed_step: 'rating' }
    end

    def check_your_answers
      { last_completed_step: 'check_your_answers' }
    end
  end

  def self.build(last_completed_step: 'identification', **kwargs)
    Rating.new(**RatingAttributeBuilder.new(last_completed_step).attrs.merge(kwargs))
  end

  def self.create(...)
    build(...).save!
  end
end

module Yoti
  #
  # Process age attribute
  #
  # @deprecated 2.0.0 - replaced by Yoti::AgeVerification
  #
  class AgeProcessor
    AGE_PATTERN = 'age_(over|under):[1-9][0-9]?[0-9]?'

    # check if the key matches the format age_[over|under]:[1-999]
    def self.is_age_verification(age_field)
      /#{AGE_PATTERN}/.match?(age_field)
    end
  end
end

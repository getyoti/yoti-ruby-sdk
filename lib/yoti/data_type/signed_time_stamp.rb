module Yoti
    # Encapsulates anchor signed time stamp
    class SignedTimeStamp
        attr_reader :version, :date_time

        def initialize(version, date_time)
            @version = version
            @date_time = date_time
        end
    end
end

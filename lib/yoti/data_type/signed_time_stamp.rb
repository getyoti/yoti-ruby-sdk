module Yoti
    # Encapsulates anchor signed time stamp
    class SignedTimeStamp
        attr_reader :version, :time_stamp

        def initialize(version, time_stamp)
            @version = version
            @time_stamp = time_stamp
        end
    end
end

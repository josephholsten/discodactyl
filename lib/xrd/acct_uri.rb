require 'uri'

module URI
  class ACCT < Generic


    COMPONENT = [
      :scheme,
      :local_part, :host
    ].freeze

    def self.parse(str)
      /^(acct:)?(.*)$/ =~ str
      scheme = 'acct'
      opaque = $2
      self.new(scheme, nil, nil, nil, nil, nil, opaque, nil, nil)
    end


    #
    # == Description
    #
    # Create a new URI::ACCT object from components, with syntax checking.
    #
    # The components accepted are local-part and host.
    #
    # The components should be provided either as an Array, or as a Hash
    # with keys formed by preceding the component names with a colon.
    #
    # If an Array is used, the components must be passed in the order
    # [local-part, host].
    #
    # Example:
    #
    #     newuri = URI::ACCT.build({:host => 'example.com',
    #       :local_part> => 'bob'})
    #
    #     newuri = URI::ACCT.build(['bob', "example.com"])
    #
    def self.build(args)
      tmp = Util::make_components_hash(self, args)
      if tmp[:local_part] && tmp[:host]
        tmp[:opaque] = tmp[:local_part]+'@'+tmp[:host]
        tmp[:host] = nil
      end
      return super(tmp)
    end

    def initialize(*arg)
      super(*arg)
      parse_opaque
    end

    def parse_opaque
      if /^([^@]*)@(.*)$/ =~ @opaque
        @local_part = $1
        @host = $2
      end
    end

    attr_reader :local_part

    def set_local_part(val)
      @local_part = val
    end
    protected :set_local_part

    def to_s
      "#{@scheme}:#{@local_part}@#{@host}"
    end

    def id
      "#{@local_part}@#{@host}"
    end

    def heirarchical?
      false
    end
  end

  @@schemes['ACCT'] = ACCT
end

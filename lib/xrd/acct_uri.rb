class AcctURI
  class << self
    def parse(str)
      /^(acct:)?([^@]*)@(.*)$/ =~ str
      acct = self.new
      acct.local_part, acct.host = Regexp.last_match[2..3]
      acct
    end
  end
  attr_accessor :local_part, :host
  def to_s
    "#{local_part}@#{host}"
  end
end
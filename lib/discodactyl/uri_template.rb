class URITemplate
  attr_accessor :pattern
  def initialize(pattern)
    @pattern = pattern
  end
  def to_uri(params)
    require 'cgi'
    uri = @pattern
    while /\{%([^}]*)\}/ =~ uri
      uri.gsub!($~[0], params[$~[1]])
    end
    while /\{([^}]*)\}/ =~ uri
      uri.gsub!($~[0], CGI::escape(params[$~[1]].to_s))
    end
    uri
  end

  def ==(other)
    return false unless other.class == self.class
    return false unless other.instance_variables == self.instance_variables
    self.instance_variables.each do |var|
      self_var = self.instance_variable_get(var)
      other_var = other.instance_variable_get(var)
      return false unless self_var.eql?(other_var)
    end
    true
  end
end

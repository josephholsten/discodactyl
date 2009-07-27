require 'nokogiri'

module XRD
  class << self
    # parse proxym    def parse(string)
      doc = Nokogiri::XML::Document.parse(string)
      add_decorators(doc)
    end
    
    # Add compatibility decorators
    def add_decorators(doc)
      doc.decorators(XML::Document) << Decorators::Document
      doc.decorators(XML::Node) << Decorators::Node
      doc.decorators(XML::NodeSet) << Decorators::NodeSet
      doc.decorate!
      doc
    end
  end
end

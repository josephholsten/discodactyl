class ResourceDescriptor
  attr_reader :links
  
  def initialize(contents)
    @links = contents[:links] || []
  end
  def get
    self
  end
# put  xrd -> xrd -> xrd;             {xrd}
  def put(xrd)
    xrd.normalize
  end
# post xrd -> xrd-link -> xrd;        {xrd << xrd-link}
  def post(link)
    self << link.normalize
    self.normalize
  end
# get  xrd -> URI -> xrd-link;        xrd/link[@href=uri]
  def get_link(uri)
    self./"link[@href=#{uri}]"
  end
# put  xrd -> xrd-link -> xrd; {post {del xrd, get(xrd, xrd-link.href)}, xrd-link}
  def put_link(uri, xrd-link)
# del  xrd -> xrd-link -> xrd;             {xrd - xrd-link}
  def delete_link(link)
    self - link
    self.normalize
  end
end

class ResourceDescriptorLink
  def href
    self['href']
  end
  def to_xml
end

describe ResourceDescriptor do
  describe 'fine grained' do
    describe 'document' do
      before :each do
        @rd = ResourceDescriptor.new
        @link = ResourceDescriptorLink.new
        @rds = ResourceDescriptorLink.new(:links => [@link])
      end
  
      it 'should create instance with links' do
        ResourceDescriptorLink.new(:links => [@link]).links.should_not :be_empty
      end
  
      it 'should get link' do
        @rd.get_link()
      end
      it 'should put a new link' do
        @rd = @rd.put(@link)
        @rd
      end
      describe 'empty' do
        before :each do
          @rd = ResourceDescriptor.new
        end
        it 'should not be nil' do
          @rd.should_not :be_nil
        end
        it 'should equal itself' do
          @rd.should == @rd
        end
        it 'should have empty links' do
          @rd.links.should :be_empty
        end
        it 'should get itself' do
          @rd.get.should == @rd
        end
        it 'should serialize to xml' do
          @rd.to_xml.should == '<xrd/>'.to_xml
        end
      end
      describe 'with link'
    end


    describe 'link' do
      describe 'empty' do
        before :each do
          @link = ResourceDescriptorLink.new(:href => '/')
        end
        it 'should have an href' do
          @link.href.should_not :be_nil
        end
        it 'should not have priority' do
          @link.priority.should :be_nil
        end
        it 'should have empty rels' do
          @link.rels.should :be_empty
        end
        it 'should have empty media types' do
          @link.media_types.should :be_empty
        end
        it 'should have empty uris' do
          @link.uris.should :be_empty
        end
        it 'should have empty uri templates' do
          @link.uri_templates.should :be_empty
        end
        it 'should have no target subject' do
          @link.target_subject.should :be_nil
        end
        it 'should have empty source aliases' do
          @link.source_aliases.should :be_empty
        end
      end
    end
  end

  describe 'Course Grained' do
    before :each do
      @router = stub!.link_path {'link_uri'}
      @rd = stub!.find_link {:old_link}
      @view = stub!.render
      @controller = ResourceDescriptorController.new(:rd => @rd, :router => @router, :view => @view)
    end
    describe 'collection' do    
      describe 'get' do
        it 'should render' do
          @controller.view = mock!.render(:rd => @rd)
          @controller.index
        end
        it 'should return ok' do
          @controller.index.status.should == :ok
        end
      end
      describe 'update' do
        it 'should replace rd' do
          @controller.rd = mock!.replace(:rd)
          @controller.update(:rd)
        end
        it 'should render' do
          @controller.view = mock!.
        end
        it 'should return ok'
      end
      describe 'post' do
        it 'should add new link'
        it 'should render'
        it 'should return ok'
      end
    end
    describe 'link' do
      it 'should update link' do
        @controller.update_link(1, :new_link)
      end
      describe 'get' do
        it 'should get link' do
          @controller.rd = mock!.find_link('link_uri') {:old_link}
          get('/xrds/1')
        end
        it 'should render'
        it 'should return ok'
      end
      describe 'delete' do
        it 'should delete link' do
          @controller.rd = mock!.delete_link('link_uri')
          delete('/xrds/1')
        end
        it 'should return ok' do
          delete('/xrds/1')
          @controller.delete(1).status.should == :ok
        end
      end
    end
  end
end

describe ExtensibleResourceDescriptor do
  # handle application/xrd+xml serialization
  describe 'document' do
    describe 'Parser' do
      it 'should parse minimal doc'
      it 'should parse complicated doc'
      it 'should not parse invalid doc'
    end
    describe 'Renderer' do
      it 'should render minimal doc'
      it 'should render complicated doc'
    end
  end
  describe 'link' do
    describe 'Parser' do
      it 'should parse minimal link'
      it 'should parse complicated link'
      it 'should not parse invalid link'
    end
    describe 'Renderer' do
      it 'should render minimal link'
      it 'should render complicated link'
    end
  end
end

describe Powder do
  # handle POWDER rdf serialization
  it 'should parse'
  it 'should render'
end
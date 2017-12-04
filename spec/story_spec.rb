# Test Story class
require 'story'

describe Story do
  describe '.url' do
    context 'If an unsupported URL is set' do
      it 'it throws an error' do
        story = Story.new
        expect{ story.url = 'https://www.ruby-lang.org/' }.to raise_error ArgumentError, %r{URL not recognised}
      end
    end
  end

  describe '.url' do
    context 'If a supported URL is set' do
      it 'it loads the plugin' do
        story = Story.new
        story.url = 'https://www.fanfiction.net/s/12734411/1/Cobalt-s-Edge'
        expect( story.respond_to? :fetch ).to eql true
      end
    end
  end

  describe '.fetch' do
    context 'If no URL is set' do
      it 'it throws an error' do
        story = Story.new
        expect{ story.fetch }.to raise_error NoMethodError, %r{undefined method .fetch.}
      end
    end
  end

  describe '.fetch' do
    context 'If a supported URL is set' do
      it 'it fetches the page' do
        story = Story.new
        story.url = 'https://www.fanfiction.net/s/12734411/1/Cobalt-s-Edge'
        story.fetch
        expect( story.html ).to match %r{<h1>Cobalt's Edge</h1>}m
      end
    end
  end

  describe '.to_txt' do
    context 'Given a html attribute containing no HTML tags' do
      it 'it copies it to the text attribute unchanged' do
        story = Story.new
        story.html = 'This is a very short story.'
        story.to_txt
        expect( story.text ).to eql story.html
      end
    end
  end

  describe '.to_txt' do
    context 'Given a html attribute containing HTML tags' do
      it 'it places a text-only version into the text attribute' do
        story = Story.new
        story.html = '<p>This is a <b>very</b> short story.</p>'
        story.to_txt
        expect( story.text ).to eql "This is a very short story.\n\n"
      end
    end
  end
end

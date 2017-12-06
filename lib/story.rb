require 'open-uri'
require 'nokogiri'

# Story class - fetches, parses, converts, and saves (dices, slices, etc)
class Story
  attr_accessor :output_dir, :title, :author, :html, :text, :plugins
  attr_reader   :url

  def initialize
    # Load any available plugins
    my_dir = __dir__
    my_dir.sub! %r{/lib}, ''
    self.plugins = {}
    Dir.foreach( 'plugins' ) do |filename|
      next unless filename.match? %r{^\w+\.rb$}
      filename.sub! '.rb', ''
      require "#{my_dir}/plugins/#{filename}"
      plugin = Object.const_get filename.capitalize!
      plugins[ filename ] = plugin.url_regex
    end
  end

  def to_txt
    if html.match? %r{<p>|<br ?/?>}
      html.gsub! %r{[\r\n]},     ''
      html.gsub! %r{</h1>},      "</h1>\n\n"
      html.gsub! %r{</p>},       "</p>\n\n"
      html.gsub! %r{<br\s+?/?>}, "<br>\n"
      self.text = Nokogiri::HTML( html ).text
    else
      self.text = html
    end
    self
  end

  def write_file
    # Create a filename based on title of story
    filename = "#{title}__#{author}"
    filename.gsub! %r{\s+}, '-'
    filename.gsub! %r{[^-\w]+}, ''
    # Open a file for output
    # TODO: in a subfolder based on category?
    output_file = "#{output_dir}/#{filename}.txt"
    open( output_file, 'w' ) do |f|
      # Write the txt version to the file
      f.puts text
      f.puts "\n\nDownloaded from: #{url}"
    end
    self
  end

  def url=( url )
    raise ArgumentError, 'You must provide a valid URL to fetch the story from.' unless url
    # Remove any query params (in case we're on second page or similar)
    url.sub! %r{\?.*$}, ''
    # Check to see if any of the available plugins can handle this URL
    plugins.each_key do |plugin|
      next unless url.match? plugins[ plugin ]
      extend Object.const_get( plugin )
      @url = url
      return self
    end
    raise ArgumentError, 'URL not recognised - do you need to install a plugin for that site?'
  end
end

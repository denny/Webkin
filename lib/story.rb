# Story class - fetches, parses, converts, and saves (dices, slices, etc)
require 'open-uri'
require 'nokogiri'

class Story
  attr_accessor :url, :output_dir, :title, :author, :html, :text, :plugins

  def initialize
    # Load any available plugins
    my_dir = File.expand_path( File.dirname(__FILE__) )
    my_dir.sub! %r{/lib}, ''
    self.plugins = Hash.new
    Dir.foreach( 'plugins' ) { |filename|
      next unless filename.match %r{^\w+\.rb$}
      filename.sub! '.rb', ''
      require "#{my_dir}/plugins/#{filename}"
      filename.capitalize!
      plugin = Object.const_get( filename )
      self.plugins[ filename ] = plugin.url_regex
    }
  end

  def to_txt
    if self.html.match %r{<p>|<br ?/?>}
      self.html.gsub! %r{[\r\n]},   ''
      self.html.gsub! %r{</p>},     "</p>\n\n"
      self.html.gsub! %r{<br ?/?>}, "<br>\n"
      self.text = Nokogiri::HTML( self.html ).text
    else
      self.text = self.html
    end
  end

  def write_file
    # Create a filename based on title of story
    filename = "#{self.title}__#{self.author}"
    filename.gsub! /\s+/, '-'
    filename.gsub! /[^-\w]+/, ''
    # Open a file for output
    # TODO: in a subfolder based on category?
    output_file = "#{self.output_dir}/#{filename}.txt"
    open( output_file, 'w' ) { |f|
      # Write the txt version to the file
      f.puts self.text
      f.puts "\n\nDownloaded from: #{self.url}"
    }
  end

  def url
    @url
  end

  def url=( url )
    raise ArgumentError, 'You must provide a valid URL to fetch the story from.' unless url
    # Remove any query params (in case we're on second page or similar)
    url.sub! %r{\?.*$}, ''
    # Check to see if any of the available plugins can handle this URL
    self.plugins.keys.each do |plugin|
      if url.match self.plugins[ plugin ]
        extend Object.const_get( plugin )
        @url = url
        return
      end
    end
    raise ArgumentError, 'URL not recognised - do you need to install a plugin for that site?'
  end
end

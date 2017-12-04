# Webkin plugin for fanfiction.net
module Fanfiction
  def self.url_regex
    return %r{https://www.fanfiction.net/.+}
  end

  def fetch
    title  = ''
    author = ''
    loop do
      page_html = open( "#{self.url}" ).read
      %r{</button><b class='xcontrast_txt'>(?<title>[^<]+)</b>.+</div>By:</span> <a class='xcontrast_txt' href='[\w/]+'>(?<author>[^<]+)</a>}m =~ page_html if title.empty?
      more_pages = true if page_html.match %r{Next >}m
      page_html.sub! %r{.+id='storytext'>}m,  ''
      page_html.sub! %r{\n</div>\n</div>.+}m, ''
      self.html = "#{self.html}\n#{page_html}"
      break unless more_pages
      self.url.sub! %r{/\d\d?/(?<slug>[-\w]+)}, "/#{nextp}/#{slug}"
    end
    self.title  = title
    self.author = author
    self.html   = "<h1>#{self.title}</h1>\n\n#{self.html}"
  rescue OpenURI::HTTPError
    abort 'Story page not found - please check URL and try again.'
  end
end

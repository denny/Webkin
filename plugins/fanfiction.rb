# Webkin plugin for fanfiction.net
module Fanfiction
  def self.url_regex
    return %r{https://www.fanfiction.net/.+}
  end

  def fetch
    title  = ''
    author = ''
    page   = 1
    url    = self.url.dup
    loop do
      page_html = open( "#{url}" ).read
      more_pages = true if page_html.match %r{Next &gt;}m
      %r{</button><b class='xcontrast_txt'>(?<title>[^<]+)</b>.+</div>By:</span> <a class='xcontrast_txt' href='[\w/]+'>(?<author>[^<]+)</a>}m =~ page_html if title.empty?
      page_html.sub! %r{.+id='storytext'>}m,  ''
      page_html.sub! %r{\n</div>\n</div>.+}m, ''
      self.html = "#{self.html}\n#{page_html}"
      break unless more_pages
      page += 1
      %r{/\d+/(?<slug>[-\w]+)$} =~ url
      url.sub! %r{/\d+/[-\w]+$}, "/#{page}/#{slug}"
    end
    self.title  = title
    self.author = author
    self.html   = "<h1>#{self.title}</h1>\n\n#{self.html}"
  rescue OpenURI::HTTPError
    abort 'Story page not found - please check URL and try again.'
  end
end

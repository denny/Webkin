# Webkin plugin for fanfiction.net
module Fanfiction
  def self.url_regex
    %r{https://www.fanfiction.net/.+}
  end

  def fetch
    title  = ''
    author = ''
    page   = 1
    url    = self.url.dup
    loop do
      page_html = open( url ).read
      more_pages = true if page_html.match? %r{Next &gt;}m
      if title.empty?
        %r{</button><b\sclass='xcontrast_txt'>(?<title>[^<]+)</b>.+
            </div>By:</span>\s<a\sclass='xcontrast_txt'\s
            href='[\w/]+'>(?<author>[^<]+)</a>}mx =~ page_html
      end
      page_html.sub! %r{.+id='storytext'>}m,  ''
      page_html.sub! %r{\n</div>\n</div>.+}m, ''
      self.html = "#{html}\n#{page_html}"
      break unless more_pages
      page += 1
      %r{/\d+/(?<slug>[-\w]+)$} =~ url
      url.sub! %r{/\d+/[-\w]+$}, "/#{page}/#{slug}"
    end
    self.title  = title
    self.author = author
    self.html   = "<h1>#{title}</h1>\n\n#{html}"
    self
  rescue OpenURI::HTTPError
    abort 'Story page not found - please check URL and try again.'
  end
end

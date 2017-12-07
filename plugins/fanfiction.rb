# Webkin plugin for fanfiction.net
module Fanfiction
  def self.url_regex
    %r{https://www.fanfiction.net/.+}
  end

  def fetch
    page_num = 1
    page_url = url.dup.sub %r{/[^/]+$}, ''
    loop do
      page_html = open( page_url ).read
      self.title, self.author = get_title page_html if page_num == 1
      self.html = extract_html html, page_html
      break unless page_html.match? %r{Next &gt;}m
      page_num += 1
      page_url.sub! %r{/\d\d?$}, "/#{page_num}"
    end
    self.html = "<h1>#{title}</h1>\n\n#{html}"
    self
  rescue OpenURI::HTTPError
    abort 'Story page not found - please check URL and try again.'
  end

  def get_title( html )
    %r{</button><b\sclass='xcontrast_txt'>(?<title>[^<]+)</b>.+
      </div>By:</span>\s<a\sclass='xcontrast_txt'\s
      href='[\w/]+'>(?<author>[^<]+)</a>}mx =~ html
    [ title, author ]
  end

  def extract_html( full_html, new_html )
    new_html.sub! %r{.+id='storytext'>}m,  ''
    new_html.sub! %r{\n</div>\n</div>.+}m, ''
    "#{full_html}\n#{new_html}"
  end
end

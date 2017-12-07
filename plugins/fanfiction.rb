# Webkin plugin for fanfiction.net
module Fanfiction
  def self.url_regex
    %r{https://www.fanfiction.net/.+}
  end

  def fetch
    page_num = 1
    base_url = url.dup.sub %r{/[^/]+/[^/]+$}, '/'
    loop do
      page_html = open( "#{base_url}/#{page_num}" ).read
      extract_details page_html if page_num == 1
      extract_story page_html
      break unless page_html.match? %r{Next &gt;}m
      page_num += 1
    end
    self.html = "<h1>#{title}</h1>\n\n#{html}"
    self
  end

  def extract_details( html )
    %r{</button><b\sclass='xcontrast_txt'>(?<title>[^<]+)</b>.+
      </div>By:</span>\s<a\sclass='xcontrast_txt'\s
      href='[\w/]+'>(?<author>[^<]+)</a>}mx =~ html
    self.title  = title
    self.author = author
  end

  def extract_story( new_html )
    new_html.sub! %r{.+id='storytext'>}m,  ''
    new_html.sub! %r{\n</div>\n</div>.+}m, ''
    self.html = "#{html}\n#{new_html}"
  end
end

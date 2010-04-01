class Article < ActiveRecord::Base
  has_many :comments
  
  def body_html
    "<p>#{(body || '').strip.lines.to_a.join("<br />")}</p>".gsub(%r{<br />\s*<br />}, "</p><p>")
  end
end

class Comment < ActiveRecord::Base
  belongs_to :article
  
  def body_html
    "<p>#{(body || '').strip.lines.to_a.join("<br />")}</p>".gsub(%r{<br />\s*<br />}, "</p><p>")
  end
end
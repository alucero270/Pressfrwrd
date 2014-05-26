module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Pressfrwrd"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def link_to_function(name, function, html_options={})
    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || '#'
    content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
  end

  def add_asset_link(name)
    ret=render partial:'asset', locals: { asset: Asset.new }
    partjs=escape_javascript(render partial:'asset', object:Asset.new)
    func="$('#assets').append('#{partjs}')"
    link_to_function name, func, class:"add_file"
  end

  def escape_quotes(string,quote='"')
    string.gsub('"','&quot;')
  end
end

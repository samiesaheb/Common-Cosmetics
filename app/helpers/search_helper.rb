module SearchHelper
  def highlight_match(text, query)
    return text if query.blank?

    pattern = Regexp.new(Regexp.escape(query), Regexp::IGNORECASE)
    text.gsub(pattern) do |match|
      "<mark class='bg-yellow-200 dark:bg-yellow-600 text-black dark:text-white rounded px-1'>#{match}</mark>"
    end.html_safe
  end
end

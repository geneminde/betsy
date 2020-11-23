module ApplicationHelper
  def show_date(date)
    return "[unknown]" unless date
    return content_tag(:span,"#{date.strftime("%b %m, %Y")}")
  end
end

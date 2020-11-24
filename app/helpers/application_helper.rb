module ApplicationHelper
  def readable_date(date)
    return "[unknown]" unless date
    return content_tag(:span,"#{date.strftime("%b %m, %Y")}", class: 'date', title: date.to_s)
  end
end

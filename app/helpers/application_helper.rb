module ApplicationHelper
  def readable_date(date)
    return "[unknown]" unless date
    return content_tag(:span,"#{date.strftime("%b %m, %Y")}", class: 'date', title: date.to_s)
  end

  def readable_time(date)
    return "[unknown]" unless date
    return content_tag(:span, "#{date.strftime("%I:%M:%S %p")}")
  end

  def has_order_items?
    order = Order.find_by(session[:order_id])
    return order.order_items.blank? ? false : true
  end
end

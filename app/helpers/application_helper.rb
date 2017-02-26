module ApplicationHelper
  def calculate_page(page_num)
    (page_num != nil ? ((page_num.to_i - 1) * WillPaginate.per_page) : 0) + 1
  end
end

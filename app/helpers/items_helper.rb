module ItemsHelper
  def item_options_for_select(group, options)
    arr = options.map{|o| [o.value, o.id] }
    arr.unshift(["Select #{group}:", nil])

    options_for_select(arr)
  end

  def item_quantities
    arr = (1..10).to_a
    arr.unshift(["Qty", nil])
  end
end

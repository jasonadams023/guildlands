module Helper
	extend ActiveSupport::Concern

	def items_string_parse(items_string)
		parsed = {}

		if items_string != nil
			strings = items_string.split
			
			strings.each do |string|
				arr = string.split('_')
				amount = arr[0].to_i
				item_str = arr[1].split('*').join(' ')
				item = Item.select{|i| i.name == item_str}
				parsed[item[0]] = amount
			end
		end

		return parsed
	end
end
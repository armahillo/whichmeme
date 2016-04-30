module UsersHelper
	def pretty_accuracy(accuracy)
	  return "" unless accuracy
	  number_with_precision(accuracy*100, precision: 2) + "%"
	end
end
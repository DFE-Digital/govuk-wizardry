require 'wizardry/graph'

wg = Wizardry::Graph.new(RatingsController.new.wizard)

puts wg.to_dot

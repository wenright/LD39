local Sunbeam = Class {
	__includes = Rigidbody
}

function Sunbeam:init(properties)
	self.rotation = -math.pi / 8

	Rigidbody.init(self, properties)

	self.filterFunction = function(item, other)
		if other.type == 'Player' then
			return 'cross'
		else
			return nil
		end
	end

	self.type = 'Sunbeam'
end

return Sunbeam

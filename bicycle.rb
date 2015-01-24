# chainring = 52
# cog       = 11
# ratio    = chainring / cog.to_f
# puts ratio

# chainring = 30
# cog       = 27
# ratio     = chainring / cog.to_f
# puts ratio

# Nouns bicycle and Gear
# nothing in the description list any behavior for bicycle, so it does not qualify
# Gears has chainrings, cogs and ratios - both data and behavior:
# => it deserves to be a class

# class Gear
#   attr_reader :chainring, :cog

#   def initialize(chainring, cog)
#     @chainring = chainring
#     @cog       = cog
#   end

#   def ratio
#     chainring / cog.to_f
#   end
# end

# puts Gear.new(52, 11).ratio
# puts Gear.new(30, 27).ratio

# class Gear
#   attr_reader :chainring, :cog, :rim, :tire

#   def initialize(chainring, cog, rim, tire)
#     @chainring = chainring
#     @cog       = cog
#     @rim       = rim
#     @tire      = tire
#   end

#   def ratio
#     @chainring / cog.to_f
#   end

#   def gear_inches
#     # tire goes around the rim twice for diameter
#     ratio * (rim + (tire * 2))
#   end
# end

# puts Gear.new(52, 11, 26, 1.5).gear_inches
# puts Gear.new(52, 11, 24, 1.25).gear_inches


# Always wrap instance variables in accessor methods

# class Gear
#   attr_reader :chainring, :cog

#   def initialize(chainring, cog)
#   @chainring = chainring
#   @cog = cog  
#   end

#   def ratio
#     chainring / cog.to_f
#   end

#   # Refactor to make it easier to examine class responsibility
#   # def gear_inches
#   # # tire goes around the rim twice for diameter
#   #  ratio * (rim + (tire * 2))
#   # end

#   def gear_inches
#     ratio * diameter
#   end

#   def diameter
#     rim + (tire * 2)
#   end
# end 


# # nightmare code:
# # class ObscuringReferences
# #   attr_reader :data

# #   def initialize(data)
# #     @data = data
# #   end

# #   def diameters
# #     # 0 is rim, 1 is tire
# #     data.collect { |cell|
# #       cell[0] + (cell[1] * 2)}
# #   end
# # end

# # rim and tire sizes (now in millimeters!) in a 2d array 
# # @data = [[622, 20], [622, 23], [559, 30], [559, 40]]

# class RevealingReferences
#   attr_reader :wheels

#   def initialize(data)
#     @wheels = wheelify(data)
#   end

#   # This method has 2 responsibilities simplify
#   # def diameters
#   #   wheels.collect {|wheel|
#   #     wheel.rim + (wheel.tire * 2)}
#   # end
#   #... Now everyone can send rim/tire to wheel

#   # First iterate over the array
#   def diameters
#     wheels.collect {|wheel| diameter(wheel)}
#   end

#   # second - calculate the diameter of one wheel
#   def diameter(wheel)
#     wheel.rim + (wheel.tire * 2)
#   end

#   Wheel = Struct.new(:rim, :tire)
#   def wheelify(data)
#     data.collect {|cell|
#       Wheel.new(cell[0], cell[1])}
#   end
# end



# Wheel exist only in the context of Gear No need to make a seperate gear class

# class Gear
#   attr_reader :chainring, :cog, :wheel

#   def initialize(chainring, cog, rim, tire)
#     @chainring = chainring
#     @cog       = cog
#     @wheel     = Wheel.new(rim, tire)
#   end

#   def ratio
#     chainring / cog.to_f
#   end

#   def gear_inches
#     ratio * wheel.diameter
#   end

#   Wheel = Struct.new(:rim, :tire) do 
#     def diameter
#       rim + (tire * 2)
#     end
#   end
# end



# Explicit need for wheel

class Gear
  attr_reader :chainring, :cog, :wheel

  def initialize(chainring, cog, wheel=nil)
    @chainring = chainring
    @cog       = cog
    @wheel     = wheel
  end

  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    ratio * wheel.diameter
  end
end

class Wheel
  attr_reader :rim, :tire

  def initialize(rim, tire)
    @rim       = rim
    @tire      = tire
  end

  def diameter
    rim + (tire * 2)
  end

  def circumference
    diameter * Math::PI
  end
end

wheel = Wheel.new(26, 1.5)
puts wheel.circumference

puts Gear.new(52, 11, wheel).gear_inches

puts Gear.new(52, 11).ratio

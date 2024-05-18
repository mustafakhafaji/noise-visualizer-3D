local Visualizer = {}

local StarterPlayer = game:GetService('StarterPlayer')

local Values = require(StarterPlayer.StarterPlayerScripts.Modules.Values)
local SplineMaps = require(StarterPlayer.StarterPlayerScripts.Modules.SplineMaps)

local visualParts = {}

local HEIGHT = -10
local VISUALIZER_SIZE = 225

-- PRIVATE

function initVisual()
	for x = 1, VISUALIZER_SIZE do
		for z = 1, VISUALIZER_SIZE do
			local part = Instance.new('Part')
			part.Size = Vector3.new(1, 1, 1)
			part.Material = Enum.Material.SmoothPlastic
			part.CanCollide = false
			part.Anchored = true
			part.Parent = workspace.Visual
			
			table.insert(visualParts, part)
		end
	end
end


function fractalNoise(x: number, y: number): number
	-- The sum of our octaves
	local value = 0 

	-- These coordinates will be scaled the lacunarity
	local x1 = x 
	local y1 = y

	-- Determines the effect of each octave on the previous sum
	local amplitude = 1

	for i = 1, Values.Octaves, 1 do
		-- Multiply the noise output by the amplitude and add it to our sum
		value += math.noise(x1 / Values.Scale, y1 / Values.Scale, Values.Seed) * amplitude

		-- Scale up our perlin noise by multiplying the coordinates by lacunarity
		y1 *= Values.Lacunarity
		x1 *= Values.Lacunarity

		-- Reduce our amplitude by multiplying it by persistence
		amplitude *= Values.Persistence
	end
	
	return value
end


-- PUBLIC

function Visualizer.visualizeNoise(): ()
	for x = 1, VISUALIZER_SIZE do
		for z = 1, VISUALIZER_SIZE do
			local part = visualParts[(x - 1) * VISUALIZER_SIZE + z]
			local noise = fractalNoise(x, z)
			local normalizedNoise = (noise + Values.HeightScale / (Values.HeightScale * 2))
			normalizedNoise = math.clamp(normalizedNoise, 0, 1)
			normalizedNoise = SplineMaps.getPeaksAndValleysTerrainHeightOffset(noise)
			
			part.Color = Color3.fromHSV(0, 0, normalizedNoise)
			part.Position = Vector3.new(x - VISUALIZER_SIZE / 2, HEIGHT + normalizedNoise * Values.HeightScale, z - VISUALIZER_SIZE / 2)
		end
	end
end


-- INIT
initVisual()
Visualizer.visualizeNoise()


return Visualizer
local InputHandler = {}

local StarterPlayer = game:GetService('StarterPlayer')
local Players = game:GetService('Players')

local Values = require(StarterPlayer.StarterPlayerScripts.Modules.Values)
local Visualizer = require(StarterPlayer.StarterPlayerScripts.Modules.Visualizer)

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

-- PRIVATE

local NoiseSettings: Frame = PlayerGui:WaitForChild('ScreenGui'):WaitForChild('NoiseSettings')

for _, frame in NoiseSettings:GetChildren() do
	if not frame:IsA('Frame') then
		continue
	end
	local TextBox: TextBox = frame:WaitForChild('TextBox')
	TextBox.FocusLost:Connect(function()
		local value = TextBox.Text
		if value == '' or not tonumber(value) then
			return
		end
		Values[frame.Name] = tonumber(value)
		Visualizer.visualizeNoise()
	end)
	TextBox.Text = Values[frame.Name]
end

return InputHandler

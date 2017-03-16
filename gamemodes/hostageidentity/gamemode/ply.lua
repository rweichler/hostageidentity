
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:GetGGLevel()
	return self.GGLevel
end


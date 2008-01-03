
local slots, freeslots, items = {1, 3, 5, 6, 7, 8, 9, 10, 16, 17, 18}, {}, {}


local function GetEmpties()
	for i=0,4 do freeslots[i] = 0 end
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			if not GetContainerItemInfo(bag, slot) then freeslots[bag] = freeslots[bag] + 1 end
		end
	end
end


local function GetNextEmpty()
	for i=0,4 do
		if freeslots[i] > 0 then
			freeslots[i] = freeslots[i] - 1
			return i
		end
	end
end


SlashCmdList["NUDIST"] = function()
	if CursorHasItem() then ClearCursor() end

	if next(items) then
		for i=1,#items do EquipItemByName(table.remove(items)) end
	else
		GetEmpties()
		for _,i in ipairs(slots) do
			local bag = GetNextEmpty()
			if not bag then return end

			local item = GetInventoryItemLink("player", i)
			if item then
				table.insert(items, (GetItemInfo(item)))
				PickupInventoryItem(i)
				if bag == 0 then PutItemInBackpack() else PutItemInBag(bag + 19) end
			end
		end
	end
end

SLASH_NUDIST1 = "/nudist"



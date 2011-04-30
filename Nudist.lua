
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


---------------------------------
--      Char frame button      --
---------------------------------

local butt = CreateFrame("Button", nil, PaperDollFrame)
butt:SetFrameStrata("DIALOG")
butt:SetPoint("BOTTOMRIGHT", CharacterFrame, "TOPRIGHT", -60, -30)
butt:SetWidth(64) butt:SetHeight(64)

-- Textures --
butt:SetNormalTexture("Interface\\Addons\\Nudist\\clothed")
butt:SetPushedTexture("Interface\\Addons\\Nudist\\nude")

-- Tooltip bits
--~ butt:SetScript("OnEnter", ShowTooltip)
--~ butt:SetScript("OnLeave", HideTooltip)


local function handler()
	if CursorHasItem() then ClearCursor() end

	if next(items) then
		while next(items) do EquipItemByName(table.remove(items), table.remove(items)) end
		butt:SetNormalTexture("Interface\\Addons\\Nudist\\clothed")
		butt:SetPushedTexture("Interface\\Addons\\Nudist\\nude")
	elseif not InCombatLockdown() then
		butt:SetNormalTexture("Interface\\Addons\\Nudist\\nude")
		butt:SetPushedTexture("Interface\\Addons\\Nudist\\clothed")
		GetEmpties()
		for _,i in ipairs(slots) do
			local bag = GetNextEmpty()
			if not bag then return end

			local item = GetInventoryItemLink("player", i)
			if item then
				table.insert(items, i)
				table.insert(items, item)
				PickupInventoryItem(i)
				if bag == 0 then PutItemInBackpack() else PutItemInBag(bag + 19) end
			end
		end
	end
end

SLASH_NUDIST1 = "/nudist"
SlashCmdList["NUDIST"] = handler
butt:SetScript("OnClick", handler)

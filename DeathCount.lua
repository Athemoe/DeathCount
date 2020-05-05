DC = {};
DC.fully_loaded = false;
DC.default_options = {

	frameRef = "TOP",
	frameX = 0,
	frameY = 0,
	hide = false,

	frameW = 200 ,
	frameH = 200,
};

deathCounter = 0

	local function DeathCountChat(msg, editbox)
		if msg == 'say' then
			SendChatMessage("Total Deaths:"..' '..tostring(deathCounter), "SAY", "Common", "Bob");
		elseif msg == 'reset' then
			deathCounter = 0
			DeathSave = 0
			print("Amount of deaths have been reset to 0")
		else
			print("Total Deaths:"..' '..tostring(deathCounter));
		end
	  end
	  
	  SLASH_DCOUNTER1, SLASH_DCOUNTER2 = '/deaths', '/death'
	  
	  SlashCmdList["DCOUNTER"] = DeathCountChat   


function DC.OnReady()


	_G.DCPrefs = _G.DCPrefs or {};

	for k,v in pairs(DC.default_options) do
		if (not _G.DCPrefs[k]) then
			_G.DCPrefs[k] = v;
		end
	end

	DC.CreateUIFrame();
end

function DC.OnSaving()

	if (DC.UIFrame) then
		local point, relativeTo, relativePoint, xOfs, yOfs = DC.UIFrame:GetPoint()
		_G.DCPrefs.frameRef = relativePoint;
		_G.DCPrefs.frameX = xOfs;
		_G.DCPrefs.frameY = yOfs;
	end
end


function DC.OnEvent(frame, event, ...)

	if (event == 'ADDON_LOADED') then
		local name = ...;
		if name == 'DC' then
			DC.OnReady();
		end
		return;
	end

	if (event == 'PLAYER_LOGIN') then

		DC.fully_loaded = true;
	
		if DeathSave == nil then
			DeathSave = 0
		else
			deathCounter = DeathSave
		  end
		  return;
		end
  if (event == 'PLAYER_DEAD') then
    deathCounter = DeathSave+1
	print("You died. Total deaths:"..' '..tostring(deathCounter));
	DeathSave = deathCounter
    return;
  end

	if (event == 'PLAYER_LOGOUT') then
    DC.OnSaving();
    DeathSave = deathCounter
		return;
	end
end

function DC.CreateUIFrame()

	DC.UIFrame = CreateFrame("Frame",nil,UIParent);
	DC.UIFrame:SetFrameStrata("BACKGROUND")
	DC.UIFrame:SetWidth(_G.DCPrefs.frameW);
	DC.UIFrame:SetHeight(_G.DCPrefs.frameH);

	DC.UIFrame.texture = DC.UIFrame:CreateTexture();
	DC.UIFrame.texture:SetAllPoints(DC.UIFrame);
	DC.UIFrame.texture:SetTexture(0, 0, 0);

	DC.UIFrame:SetPoint(_G.DCPrefs.frameRef, _G.DCPrefs.frameX, _G.DCPrefs.frameY);

	DC.UIFrame:SetMovable(true);
	DC.UIFrame:EnableMouse(true);

	DC.Cover = CreateFrame("Button", nil, DC.UIFrame);
	DC.Cover:SetFrameLevel(128);
	DC.Cover:SetPoint("TOPLEFT", 0, 0);
	DC.Cover:SetWidth(_G.DCPrefs.frameW);
	DC.Cover:SetHeight(_G.DCPrefs.frameH);
	DC.Cover:EnableMouse(true);
	DC.Cover:RegisterForClicks("AnyUp");
	DC.Cover:RegisterForDrag("LeftButton");
	DC.Cover:SetScript("OnDragStart", DC.OnDragStart);
	DC.Cover:SetScript("OnDragStop", DC.OnDragStop);
	DC.Cover:SetScript("OnClick", DC.OnClick);

	DC.Label = DC.Cover:CreateFontString(nil, "OVERLAY");
	DC.Label:SetPoint("CENTER", DC.UIFrame, "CENTER", 2, 0);
	DC.Label:SetJustifyH("LEFT");
	DC.Label:SetFont([[Fonts\FRIZQT__.TTF]], 12, "OUTLINE");
	DC.Label:SetText(" ");
	DC.Label:SetTextColor(1,1,1,1);
	DC.SetFontSize(DC.Label, 20);
end

function DC.SetFontSize(string, size)

	local Font, Height, Flags = string:GetFont()
	if (not (Height == size)) then
		string:SetFont(Font, size, Flags)
	end
end

function DC.OnDragStart(frame)
	DC.UIFrame:StartMoving();
	DC.UIFrame.isMoving = true;
	GameTooltip:Hide()
end

function DC.OnDragStop(frame)
	DC.UIFrame:StopMovingOrSizing();
	DC.UIFrame.isMoving = false;
end

function DC.OnClick(self, aButton)
	if (aButton == "RightButton") then
	print("Total Deaths:"..' '..tostring(deathCounter));
	end
end

function DC.UpdateFrame()
  DC.Label:SetText("Deaths:"..' '..tostring(deathCounter));
end


DC.EventFrame = CreateFrame("Frame");
DC.EventFrame:Show();
DC.EventFrame:SetScript("OnEvent", DC.OnEvent);
DC.EventFrame:SetScript("OnUpdate", DC.OnUpdate);
DC.EventFrame:RegisterEvent("ADDON_LOADED");
DC.EventFrame:RegisterEvent("PLAYER_LOGIN");
DC.EventFrame:RegisterEvent("PLAYER_LOGOUT");
DC.EventFrame:RegisterEvent("PLAYER_DEAD");


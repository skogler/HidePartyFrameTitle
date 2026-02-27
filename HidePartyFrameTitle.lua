-- HidePartyTitle.lua
-- Hides the "Party" label that appears above the compact party frame.

local ADDON_NAME = "HidePartyFrameTitle"

local function HidePartyTitle()
    -- Modern retail UI (Dragonflight / War Within / Midnight)
    -- The party header lives on CompactPartyFrame
    if CompactPartyFrame then
        -- The title region is a FontString child called "Title"
        local title = CompactPartyFrameTitle
        if title then
            title:Hide()
            return
        end

        -- Fallback: iterate children to find a FontString that says "Party"
        for _, child in ipairs({ CompactPartyFrame:GetRegions() }) do
            if child:GetObjectType() == "FontString" then
                local text = child:GetText()
                if text and text:lower() == "party" then
                    child:Hide()
                    return
                end
            end
        end
    end
end

-- Try immediately in case frames are already built
HidePartyTitle()

-- Also hook into the PLAYER_LOGIN event to catch late initialisation
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("GROUP_ROSTER_UPDATE")  -- re-apply if the frame is rebuilt on group join
f:SetScript("OnEvent", function(self, event)
    HidePartyTitle()

    -- Some patches rebuild the compact frames; hook the show event to be safe
    if CompactPartyFrame and not self.hooked then
        self.hooked = true
        hooksecurefunc(CompactPartyFrame, "Show", HidePartyTitle)
    end
end)

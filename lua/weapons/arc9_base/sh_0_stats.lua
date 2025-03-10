local ENTITY = FindMetaTable("Entity")
local entityGetTable = ENTITY.GetTable

SWEP.StatCache = {}
SWEP.HookCache = {}
SWEP.AffectorsCache = nil
SWEP.HasNoAffectors = {}

SWEP.ExcludeFromRawStats = {
    ["PrintName"] = true,
}

SWEP.DynamicConditions = { -- Never cache these conditions because they will always change
    ["Recoil"] = true,
}

local quickmodifiers = {
    ["DamageMin"] = GetConVar("arc9_mod_damage"),
    ["DamageMax"] = GetConVar("arc9_mod_damage"),
    ["Spread"] = GetConVar("arc9_mod_spread"),
    ["Recoil"] = GetConVar("arc9_mod_recoil"),
    ["VisualRecoil"] = GetConVar("arc9_mod_visualrecoil"),
    ["AimDownSightsTime"] = GetConVar("arc9_mod_adstime"),
    ["SprintToFireTime"] = GetConVar("arc9_mod_sprinttime"),
    ["DamageRand"] = GetConVar("arc9_mod_damagerand"),
    ["PhysBulletMuzzleVelocity"] = GetConVar("arc9_mod_muzzlevelocity"),
    ["RPM"] = GetConVar("arc9_mod_rpm"),
    ["HeadshotDamage"] = GetConVar("arc9_mod_headshotdamage"),
    ["MalfunctionMeanShotsToFail"] = GetConVar("arc9_mod_malfunction")
}

local singleplayer = game.SinglePlayer()
local ARC9HeatCapacityGPVOverflow = false

function SWEP:ClearLongCache()
    local pvData = ARC9.PV_Data[self]
    for _, v in pairs(pvData.PV_CacheLong) do v.time = 0 end
end

function SWEP:InvalidateCache()
    if singleplayer and self:GetOwner():IsPlayer() then
        self:CallOnClient("InvalidateCache")
    end

    self:ClearLongCache()

    self.StatCache = {}
    self.HookCache = {}
    self.AttPosCache = {}
    self.AffectorsCache = nil
    self.ElementsCache = nil
    self.ElementTablesCache = nil
    self.RecoilPatternCache = {}
    -- self.ScrollLevels = {} -- moved to PostModify
    self.HasNoAffectors = {}
    self:SetBaseSettings()

    local pvData = ARC9.PV_Data[self]
    pvData.PV_Cache = {}
    pvData.PV_CacheLong = {}
end

function SWEP:GetFinalAttTableFromAddress(address)
    return self:GetFinalAttTable(self:LocateSlotFromAddress(address))
end

local tableCopy = table.Copy
local tableMerge = table.Merge
local ARC9GetAttTable = ARC9.GetAttTable

function SWEP:GetFinalAttTable(slot)
    if !slot then return {} end
    if !slot.Installed then return {} end
    local atttbl = tableCopy(ARC9GetAttTable(slot.Installed) or {})

    if self.AttachmentTableOverrides and self.AttachmentTableOverrides[slot.Installed] then
        atttbl = tableMerge(atttbl, self.AttachmentTableOverrides[slot.Installed])
    end

    if atttbl.ToggleStats then
        local toggletbl = atttbl.ToggleStats[slot.ToggleNum or 1] or {}
        tableMerge(atttbl, toggletbl)
    end

    return atttbl
end

do
    -- local swepGetCurrentFiremodeTable = SWEP.GetCurrentFiremodeTable
    local swepGetElements = SWEP.GetElements
    local swepGetFinalAttTable = SWEP.GetFinalAttTable
    local cvarArcModifiers = GetConVar("arc9_modifiers")
    local cvarGetString = FindMetaTable("ConVar").GetString

    function SWEP:GetAllAffectors()
        if self.AffectorsCache then return self.AffectorsCache end

        local aff = {tableCopy(entityGetTable(self))}

        local affLength = 1

        if not ARC9.OverrunSights then
            ARC9.OverrunSights = true
            local originalSightTable = self:GetSight().OriginalSightTable

            if originalSightTable then
                affLength = affLength + 1
                aff[affLength] = originalSightTable
            end

            ARC9.OverrunSights = false
        end

        local subSlotList = self:GetSubSlotList()
        local subSlotListLength = #subSlotList

        for i = 1, subSlotListLength do
            local atttbl = swepGetFinalAttTable(self, subSlotList[i])

            if atttbl then
                affLength = affLength + 1
                aff[affLength] = atttbl
            end
        end

        local config = string.Split(cvarGetString(cvarArcModifiers), "\\n")
        local configLength = #config
        local c4 = {}

        for i = 1, configLength do
            local swig = string.Split(config[i], "\\t")
            local swig1, swig2 = swig[1], swig[2]
            -- local c2 = c4[swig[1]]
            local swig2Num = tonumber(swig2)

            if swig2Num then
                c4[swig1] = swig2Num
            elseif swig2 == "true" or swig2 == "false" then
                c4[swig1] = swig2 == "true"
            else
                c4[swig1] = swig2
            end
        end

        affLength = affLength + 1
        aff[affLength] = c4

        if not ARC9.OverrunFiremodes then
            ARC9.OverrunFiremodes = true
            affLength = affLength + 1
            aff[affLength] = self:GetCurrentFiremodeTable()
            ARC9.OverrunFiremodes = false
        end

        if not ARC9.OverrunAttElements then
            ARC9.OverrunAttElements = true

            local eles = self:GetAttachmentElements()

            for _, eletable in ipairs(eles) do
                if eletable then
                    affLength = affLength + 1
                    aff[affLength] = eletable
                end
            end

            ARC9.OverrunAttElements = false
        end

        self.AffectorsCache = aff

        return aff
    end
end

do
    -- local CURRENT_AFFECTOR
    -- local CURRENT_DATA
    -- local CURRENT_SWEP
    local swepGetAllAffectors = SWEP.GetAllAffectors

    -- local function affectorCall()
    --     return CURRENT_AFFECTOR(CURRENT_SWEP, CURRENT_DATA)
    -- end

    function SWEP:RunHook(val, data)
        local any = false
        local hookCache = self.HookCache[val]

        if hookCache then
            for i = 1, #hookCache do
                local d = hookCache[i](self, data)

                if d ~= nil then
                    data = d
                end

                any = true
            end

            data2 = hook.Run("ARC9_" .. val, self, data)
            if data2 ~= nil then
                data = data2
            end

            return data, any
        end

        -- CURRENT_SWEP = self

        local cacheLen = 0
        local newCache = {}
        local affectors = swepGetAllAffectors(self)
        local affectorsCount = #affectors

        for i = 1, affectorsCount do
            local tbl = affectors[i]
            local tblVal = tbl[val]
            if tblVal and isfunction(tblVal) then
                cacheLen = cacheLen + 1
                newCache[cacheLen] = tblVal

                -- CURRENT_AFFECTOR = tblVal
                -- CURRENT_DATA = data
                -- local succ, returnedData = CURRENT_AFFECTOR(CURRENT_SWEP, CURRENT_DATA) pcall(affectorCall)
                local d = tblVal(self, data)
                if d ~= nil then
                    data = d
                end
                -- if succ then
                --     data = returnedData ~= nil and returnedData or data
                --     any = true
                -- else
                --     print("!!! ARC9 ERROR - \"" .. (tbl["PrintName"] or "Unknown") .. "\" TRIED TO RUN INVALID HOOK ON " .. val .. "!")
                --     print(returnedData, '\n')
                -- end
            end
        end

        self.HookCache[val] = newCache
        data2 = hook.Run("ARC9_" .. val, self, data)
        if data2 ~= nil then
            data = data2
        end

        return data, any
    end
end

local Lerp = function(a, v1, v2)
    local d = v2 - v1

    return v1 + (a * d)
end

-- local pvtick = 0
-- local pv_move = 0
-- local pv_shooting = 0
-- local pv_melee = 0

ARC9.PV_Data = ARC9.PV_Data or {}

function SWEP:PV_Initialize()
    ARC9.PV_Data[self] = {
        PV_Tick = 0,
        PV_Move = 0,
        PV_Shooting = 0,
        PV_Melee = 0,
        PV_Cache = {},
        PV_CacheLong = {},
    }
end

function SWEP:PV_Remove()
    ARC9.PV_Data[self] = nil
end

-- SWEP.PV_Tick = 0
-- SWEP.PV_Move = 0
-- SWEP.PV_Shooting = 0
-- SWEP.PV_Melee = 0
-- SWEP.PV_Cache = {}
-- SWEP.PV_CacheLong = {}

do
    local swepRunHook = SWEP.RunHook
    local swepGetAllAffectors = SWEP.GetAllAffectors

    -- Maybe we need to make a thug version of this function? with getmetatable fuckery
    local type = type

    function SWEP:GetValue(val, base, condition, amount)
        condition = condition or ""
        amount = amount or 1
        local stat = base
        local entityTable = entityGetTable(self)

        if stat == nil then
            stat = entityTable[val]
        end

        local valContCondition = val .. condition
        local HasNoAffectors = entityTable.HasNoAffectors

        if HasNoAffectors[valContCondition] == true then
            return stat
        end

        local unaffected = true
        local baseStr = tostring(base)
        -- damn
        local baseContValContCondition = baseStr .. valContCondition

        if type(stat) == "table" then
            stat.BaseClass = nil
        end

        local statCache = entityTable.StatCache
        local cacheAvailable = statCache[baseContValContCondition]

        if cacheAvailable ~= nil then
            stat = cacheAvailable
            local oldstat = stat
            stat = swepRunHook(self, val .. "Hook" .. condition, stat)

            if stat == nil then
                stat = oldstat
            end
            
            if quickmodifiers[val] and isnumber(stat) then
                local convarvalue = quickmodifiers[val]:GetFloat()

                if val == "MalfunctionMeanShotsToFail" then -- dont kill me for this pls
                    stat = stat / math.max(0.00000001, convarvalue)
                else
                    stat = stat * convarvalue
                end
            end

            return stat
        end

        local priority = 0
        local allAffectors = swepGetAllAffectors(self)
        local affectorsCount = #allAffectors

        if not entityTable.ExcludeFromRawStats[val] then
            for i = 1, affectorsCount do
                local tbl = allAffectors[i]
                if !tbl then continue end
                
                local att_priority = tbl[valContCondition .. "_Priority"] or 1

                if att_priority >= priority and tbl[valContCondition] ~= nil then
                    stat = tbl[valContCondition]
                    priority = att_priority
                    unaffected = false
                end
            end
        end

        for i = 1, affectorsCount do
            local tbl = allAffectors[i]
            local att_priority = tbl[val .. "Override" .. condition .. "_Priority"] or 1
            local keyName = val .. "Override" .. condition

            if att_priority >= priority and tbl[keyName] ~= nil then
                stat = tbl[keyName]
                priority = att_priority
                unaffected = false
            end
        end

        if type(stat) == "number" then
            for i = 1, affectorsCount do
                local tbl = allAffectors[i]
                local keyName = val .. "Add" .. condition

                if tbl[keyName] ~= nil then
                    if type(tbl[keyName]) == type(stat) then
                        stat = stat + (tbl[keyName] * amount)
                    end

                    unaffected = false
                end
            end

            for i = 1, affectorsCount do
                local tbl = allAffectors[i]
                local keyName = val .. "Mult" .. condition

                if tbl[keyName] ~= nil then
                    if type(tbl[keyName]) == type(stat) then
                        if amount > 1 then
                            stat = stat * math.pow(tbl[keyName], amount)
                        else
                            stat = stat * tbl[keyName]
                        end
                    end

                    unaffected = false
                end
            end
        end

        local cond = entityTable.DynamicConditions[condition]

        if not cond then
            statCache[baseContValContCondition] = stat
        end

        local newstat, any = swepRunHook(self, val .. "Hook" .. condition, stat)
        stat = newstat or stat

        if quickmodifiers[val] and isnumber(val) then
            local convarvalue = quickmodifiers[val]:GetFloat()
            
            if val == "MalfunctionMeanShotsToFail" then  -- dont kill me for this pls
                stat = stat / math.max(0.00000001, convarvalue)
            else
                stat = stat * convarvalue
            end

            unaffected = false
        end

        if any then
            unaffected = false
        end

        if not cond then
            HasNoAffectors[valContCondition] = unaffected
        end

        if type(stat) == 'table' then
            stat.BaseClass = nil
        end

        return stat
    end
end

do
    local PLAYER = FindMetaTable("Player")
    local playerCrouching = PLAYER.Crouching
    local playerGetWalkSpeed = PLAYER.GetWalkSpeed
	local playerSprinting = PLAYER.IsSprinting
    local entityOwner = ENTITY.GetOwner
    local entityOnGround = ENTITY.OnGround
    local entityIsValid = ENTITY.IsValid
    local entityGetMoveType = ENTITY.GetMoveType
    local entityIsPlayer = ENTITY.IsPlayer
    -- local entityIsNPC = ENTITY.IsNPC
    local entityGetAbsVelocity = ENTITY.GetAbsVelocity
    local WEAPON = FindMetaTable("Weapon")
    local weaponClip1 = WEAPON.Clip1
    local weaponClip2 = WEAPON.Clip2
    local weaponGetNextPrimaryFire = WEAPON.GetNextPrimaryFire
    local arcGetValue = SWEP.GetValue
    local cvarArc9Truenames = GetConVar("arc9_truenames")
    local cvarGetBool = FindMetaTable("ConVar").GetBool
    local vectorLength = FindMetaTable("Vector").Length
    local engineTickInterval = engine.TickInterval
    local engineTickCount = engine.TickCount
    local CurTime = CurTime
    local UnPredictedCurTime = UnPredictedCurTime

    local getmetatable = getmetatable
    local numberMeta = getmetatable(1)

    -- This should NOT break anything
    -- There are a few addons (such as SAM) that do the same
    if not numberMeta then
        numberMeta = {MetaName = "number"}
        debug.setmetatable(1, numberMeta)
    end

    local function isnumber(val)
        return getmetatable(val) == numberMeta
    end

    local GetProcessedValue = nil
    ARC9.TestT = ARC9.TestT or {}

    function SWEP:GetProcessedValue(val, cachedelay, base, cmd)
        --ARC9.TestT[val] = (ARC9.TestT[val] or 0) + 1

        local processedValueName = tostring(val) .. tostring(base)
        local ticks = engineTickCount()
        local pvData = ARC9.PV_Data[self]

        if pvData.PV_Cache[processedValueName] ~= nil and pvData.PV_Tick >= ticks then
            local predictionActive = not cachedelay and IsValid(GetPredictionPlayer())
            if (predictionActive) then
                -- Dont return cached values in prediction or else it will cause prediction errors
            else
                return pvData.PV_Cache[processedValueName]
            end
        end

        if pvData.PV_Tick < ticks then
            pvData.PV_Cache = {}
        end

        local upct = UnPredictedCurTime()

        if cachedelay then
            local PV_CacheLong = pvData.PV_CacheLong
            local pValue = PV_CacheLong[processedValueName]

            if pValue then
                local cachetime = pValue.time

                if cachetime then
                    if upct > cachetime then
                        pValue.time = upct + 60 -- idk whats number here should be
                        pValue.value = GetProcessedValue(self, val, nil, base, cmd, false)
                    end
                end
            else
                pValue = {}
                PV_CacheLong[processedValueName] = pValue
                pValue.time = upct
                pValue.value = GetProcessedValue(self, val, nil, base, cmd, false)
            end

            return pValue.value
        end

        local swepDt = self.dt
        local ct = CurTime()
        local stat = arcGetValue(self, val, base)
        local ubgl = swepDt.UBGL
        local owner = entityOwner(self)
        local ownerIsNPC = owner:IsNPC()

        if ownerIsNPC then
            stat = arcGetValue(self, val, stat, "NPC")
        end

        if cvarGetBool(cvarArc9Truenames) then
            stat = arcGetValue(self, val, stat, "True")
        end

        if not ownerIsNPC and entityIsValid(owner) then
            local ownerOnGround = entityOnGround(owner)

            if not ownerOnGround /*or entityGetMoveType(owner) == MOVETYPE_NOCLIP*/ then
                stat = arcGetValue(self, val, stat, "MidAir")
            end

            if ownerOnGround and playerCrouching(owner) then
                stat = arcGetValue(self, val, stat, "Crouch")
            end
			
			if ownerOnGround and playerSprinting(owner) and !self:StillWaiting() then
                stat = arcGetValue(self, val, stat, "Sprint")
			end
        end

        if swepDt.Reloading then
            stat = arcGetValue(self, val, stat, "Reload")
        end

        if swepDt.BurstCount == 0 then
            stat = arcGetValue(self, val, stat, "FirstShot")
        end

        if swepDt.GrenadeTossing then
            stat = arcGetValue(self, val, stat, "Toss")
        end

        if weaponClip1(self) == 0 then
            stat = arcGetValue(self, val, stat, "Empty")
        end

        if not ubgl and arcGetValue(self, "Silencer") then
            stat = arcGetValue(self, val, stat, "Silenced")
        end

        if ubgl then
            stat = arcGetValue(self, val, stat, "UBGL")

            if weaponClip2(self) == 0 then
                stat = arcGetValue(self, val, stat, "EmptyUBGL")
            end
        end

        if swepDt.NthShot % 2 == 0 then
            stat = arcGetValue(self, val, stat, "EvenShot")
        else
            stat = arcGetValue(self, val, stat, "OddShot")
        end

        if swepDt.NthReload % 2 == 0 then
            stat = arcGetValue(self, val, stat, "EvenReload")
        else
            stat = arcGetValue(self, val, stat, "OddReload")
        end

        -- if self:GetBlindFire() then
        --     stat = arcGetValue(self, val, stat, "BlindFire")
        -- end
        if swepDt.Bipod then
            stat = arcGetValue(self, val, stat, "Bipod")
        end

        local hasNoAffectors = self.HasNoAffectors

        if not hasNoAffectors[val .. "Sights"] or not hasNoAffectors[val .. "HipFire"] or not hasNoAffectors[val .. "Sighted"] then
            local sightAmount = swepDt.SightAmount

            if isnumber(stat) then
                local hipfire = arcGetValue(self, val, stat, "HipFire")
                local sights = arcGetValue(self, val, stat, "Sights")
                local sighted = arcGetValue(self, val, stat, "Sighted")

                if sightAmount >= 1 and not hasNoAffectors[val .. "Sighted"] then
                    stat = sighted
                elseif isnumber(hipfire) and isnumber(sights) then
                    stat = Lerp(sightAmount, hipfire, sights)
                end
            else
                if sightAmount >= 1 then
                    if hasNoAffectors[val .. "Sighted"] then
                        stat = arcGetValue(self, val, stat, "Sights")
                    else
                        stat = arcGetValue(self, val, stat, "Sighted")
                    end
                else
                    stat = arcGetValue(self, val, stat, "HipFire")
                end
            end
        end

        if not ARC9HeatCapacityGPVOverflow then
            local heatAmount = swepDt.HeatAmount
            local hasHeat = heatAmount > 0

            if hasHeat and base ~= "HeatCapacity" and (not hasNoAffectors[val .. "Hot"] or not hasNoAffectors[val .. "Heated"]) then

                ARC9HeatCapacityGPVOverflow = true
                local cap = GetProcessedValue(self, "HeatCapacity")
                ARC9HeatCapacityGPVOverflow = false

                if isnumber(stat) then
                    local hot = arcGetValue(self, val, stat, "Hot")

                    if not hasNoAffectors[val .. "Heated"] and heatAmount >= cap then
                        stat = arcGetValue(self, val, stat, "Heated")
                    elseif isnumber(hot) then
                        ARC9HeatCapacityGPVOverflow = true
                        stat = Lerp(heatAmount / cap, stat, hot)
                        ARC9HeatCapacityGPVOverflow = false
                    end
                else
                    if not hasNoAffectors[val .. "Heated"] and heatAmount >= cap then
                        stat = arcGetValue(self, val, stat, "Heated")
                    elseif hasHeat then
                        stat = arcGetValue(self, val, stat, "Hot")
                    end
                end
            end
        end

        local getlastmeleetime = swepDt.LastMeleeTime

        if not hasNoAffectors[val .. "Melee"] and getlastmeleetime < ct then
            local pft = ct - getlastmeleetime
            local d = pft / (arcGetValue(self, "PreBashTime") + arcGetValue(self, "PostBashTime"))
            d = 1 - math.Clamp(d, 0, 1)

            if isnumber(stat) then
                stat = Lerp(d, stat, arcGetValue(self, val, stat, "Melee"))
            else
                if d > 0 then
                    stat = arcGetValue(self, val, stat, "Melee")
                end
            end
        end

        if not hasNoAffectors[val .. "Shooting"] then
            local nextPrimaryFire = weaponGetNextPrimaryFire(self)

            if nextPrimaryFire + 0.1 > ct then
                local pft = (nextPrimaryFire + 0.1) - ct
                local d = math.Clamp(pft / 0.1, 0, 1)

                if isnumber(stat) then
                    stat = Lerp(d, stat, arcGetValue(self, val, stat, "Shooting"))
                else
                    if d > 0 then
                        stat = arcGetValue(self, val, stat, "Shooting")
                    end
                end
            end
        end

        -- Did not seem to do anything to modify any value being fetched?
        -- if val ~= "RecoilModifierCap" and not hasNoAffectors[val .. "Recoil"] then
        --     local recoilAmount = math.min(GetProcessedValue(self, "RecoilModifierCap"), swepDt.RecoilAmount)

        --     if recoilAmount > 0 then
        --         print("before", stat)
        --         stat = arcGetValue(self, val, stat, "Recoil", recoilAmount)
        --         print("after", stat)
        --     end
        -- end

        if not hasNoAffectors[val .. "Move"] and IsValid(owner) then
            local spd = pvData.PV_Move
            local maxspd = entityIsPlayer(owner) and playerGetWalkSpeed(owner) or 250

            --if singleplayer or CLIENT or pvData.PV_Tick ~= upct then
                spd = math.min(vectorLength(entityGetAbsVelocity(owner)), maxspd) / maxspd
                pvData.PV_Move = spd
            --end

            if isnumber(stat) then
                stat = Lerp(spd, stat, arcGetValue(self, val, stat, "Move"))
            else
                if spd > 0 then
                    stat = arcGetValue(self, val, stat, "Move")
                end
            end
        end

        -- if CLIENT then
            -- pvData.PV_Tick = ticks + (ownerIsNPC and engineTickInterval() * 16 or engineTickInterval())
            pvData.PV_Tick = ticks + (ownerIsNPC and 16 or 1)
            pvData.PV_Cache[processedValueName] = stat
        -- end

        return stat
    end

    GetProcessedValue = SWEP.GetProcessedValue
end

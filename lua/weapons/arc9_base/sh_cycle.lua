
local PLAYER = FindMetaTable("Player")
local KeyDown = PLAYER.KeyDown
local GetInfoNum = PLAYER.GetInfoNum

local ENTITY = FindMetaTable("Entity")
local GetOwner = ENTITY.GetOwner
local GetTable = ENTITY.GetTable

function SWEP:ThinkCycle()
    local entityTbl = GetTable(self)

    local needsCycle = entityTbl.GetNeedsCycle(self)

    if needsCycle then
        local cycleFinishTime = entityTbl.GetCycleFinishTime(self)

        if cycleFinishTime != 0 and cycleFinishTime <= CurTime() then
            entityTbl.SetNeedsCycle(self, false)
            entityTbl.SetCycleFinishTime(self, 0)
        end
    end

    if entityTbl.StillWaiting(self) then return end
    local owner = GetOwner(self)

    local manual = entityTbl.ShouldManualCycle(self)

    local cycling = nil

    if manual then
        cycling = KeyDown(owner, IN_RELOAD)
    else
        cycling = !KeyDown(owner, IN_ATTACK)
    end

    if needsCycle and (cycling or entityTbl.GetProcessedValue(self, "SlamFire", true)) then

        if entityTbl.MalfunctionCycle and (IsFirstTimePredicted() and entityTbl.RollJam(self)) then return end

        local ejectdelay = entityTbl.GetProcessedValue(self, "EjectDelay", true)

        local t = self:PlayAnimation("cycle", entityTbl.GetProcessedValue(self, "CycleTime", true), false)

        t = t * ((entityTbl.GetAnimationEntry(self, entityTbl.TranslateAnimation(self, "cycle")) or {}).MinProgress or 1)

        entityTbl.SetCycleFinishTime(self, CurTime() + t)

        if IsFirstTimePredicted() and !entityTbl.GetProcessedValue(self, "NoShellEjectManualAction", true) then
            if ejectdelay == 0 then
                self:DoEject()
            else
                self:SetTimer(ejectdelay, function()
                    self:DoEject()
                end)
            end
        end
    end
end

function SWEP:ShouldManualCycle()
    return GetInfoNum(GetOwner(self), "arc9_manualbolt", 0) >= 1
end
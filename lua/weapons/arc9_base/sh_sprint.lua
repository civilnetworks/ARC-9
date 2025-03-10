
local PLAYER = FindMetaTable("Player")
local KeyDown = PLAYER.KeyDown

local ENTITY = FindMetaTable("Entity")
local GetMoveType = ENTITY.GetMoveType
local OnGround = ENTITY.OnGround
local GetOwner = ENTITY.GetOwner

function SWEP:GetSprintToFireTime()
    local owner = GetOwner(self)
    local slidingmult = (owner.GetSliding and owner:GetSliding()) and 0.66 or 1
    return self:GetProcessedValue("SprintToFireTime", true) * slidingmult -- Incorrectly uses a time as a multiplier! Preserved for legacy behavior
end

function SWEP:GetTraverseSprintToFireTime()
    return self:GetProcessedValue("SprintToFireTime") * 1.5
end

-- local cachedissprinting = false
-- local cachedsprinttime = 0

function SWEP:GetIsSprinting()
    return self:GetIsSprintingCheck()
end

function SWEP:GetIsWalking()
    local owner = GetOwner(self)

    if !owner:IsValid() or owner:IsNPC() then
        return false
    end

    if KeyDown(owner, IN_SPEED) then return false end
    if !KeyDown(owner, IN_FORWARD + IN_BACK + IN_MOVELEFT + IN_MOVERIGHT) then return false end

    local curspeed = owner:GetVelocity():LengthSqr()
    if curspeed <= 0 then return false end

    return true
end

function SWEP:GetIsSprintingCheck()
    local owner = GetOwner(self)

    if !owner:IsValid() or owner:IsNPC() then
        return false
    end
    if KeyDown(owner, IN_ATTACK2) then return end
    if self:GetInSights() then return false end
    -- if self:GetCustomize() then return false end
    -- if self:GetIsNearWall() then return true end
    if !KeyDown(owner, IN_SPEED) then return false end
    if !OnGround(owner) or GetMoveType(owner) == MOVETYPE_NOCLIP then return false end
    if !KeyDown(owner, IN_FORWARD + IN_BACK + IN_MOVELEFT + IN_MOVERIGHT) then return false end

    -- if (self:GetAnimLockTime() > CurTime()) and self:GetProcessedValue("NoSprintWhenLocked", true) then
    --     return false
    -- end

    -- if self:GetProcessedValue("ShootWhileSprint", true) and KeyDown(owner, IN_ATTACK) then
    --     return false
    -- end

    if self:GetGrenadePrimed() then
        return false
    end

    -- if owner.GetSliding and owner:GetSliding() then return false end

    if owner:Crouching() then return false end

    return true
end

function SWEP:GetSprintDelta()
    return self:GetSprintAmount()
end

function SWEP:EnterSprint()
    self:SetShouldHoldType()

    if !self:GetProcessedValue("ReloadWhileSprint", true) then
        self:CancelReload()
    end

    if !self:StillWaiting() then
        if self:GetProcessedValue("InstantSprintIdle", true) then
            self:PlayAnimation("idle")
        else
            local anim = self:TranslateAnimation("enter_sprint")
            local mult = self:GetSprintToFireTime()
            if self:GetAnimationEntry(anim).NoStatAffectors then
                mult = 1
            end
            self:PlayAnimation(anim, mult, nil, nil, nil, true)
        end
    end
end

function SWEP:ExitSprint()
    self:SetShouldHoldType()

    if !self:StillWaiting() then
        if self:GetProcessedValue("InstantSprintIdle", true) then
            self:PlayAnimation("idle")
        else
            local anim = self:TranslateAnimation("exit_sprint")
            local mult = self:GetSprintToFireTime()
            if self:GetAnimationEntry(anim).NoStatAffectors then
                mult = 1
            end
            self:PlayAnimation(anim, mult, nil, nil, nil, true)
        end
    end
end

function SWEP:ThinkSprint()

    local sprinting = false

    if self:GetSightAmount() >= 1 or (self:GetProcessedValue("ReloadNoSprintPos", true) and self:GetReloading() or self:StillWaiting()) then
        sprinting = false
    else
        sprinting = self:GetSafe() or self:GetIsSprinting()
    end

    local amt = self:GetSprintAmount()
    local oldAmt = amt

    local lastwassprinting = self:GetLastWasSprinting()

    if lastwassprinting and !sprinting then
        self:ExitSprint()
    elseif !lastwassprinting and sprinting then
        self:EnterSprint()
    end

    if (lastwassprinting != sprinting) then
        self:SetLastWasSprinting(sprinting)
    end

    if sprinting and !self:GetPrimedAttack() then
        if amt < 1 then
            amt = math.Approach(amt, 1, FrameTime() / self:GetSprintToFireTime())
        end
    else
        if amt > 0 then
            amt = math.Approach(amt, 0, FrameTime() / self:GetSprintToFireTime())
        end
    end

    if (amt != oldAmt) then
        self:SetSprintAmount(amt)
    end
end
function SWEP:ThinkTriggerSounds()
    local TriggerDownSound = self.TriggerDownSound
    local TriggerUpSound = self.TriggerUpSound

    if (!TriggerDownSound or TriggerDownSound == "") and (!TriggerUpSound or TriggerUpSound == "") then return end

    if self:GetAnimLockTime() > CurTime() then return end
    if self:StillWaiting() then return end
    if self:SprintLock() then return end
    if self:GetSafe() then return end
    local owner = self:GetOwner()
    local processedValue = self.GetProcessedValue

    if processedValue(self,"Throwable", true) then return end
    if processedValue(self,"PrimaryBash", true) then return end

    if owner:KeyReleased(IN_ATTACK) then

		if self.RecentMelee then 
			return 
		end

        local soundtab = {
            name = "triggerup",
            sound = self:RandomChoice(self.TriggerUpSound),
            channel = ARC9.CHAN_TRIGGER+7
        }

        self:PlayTranslatedSound(soundtab)
    elseif owner:KeyPressed(IN_ATTACK) then
        if processedValue(self,"Bash", true) and owner:KeyDown(IN_USE) and !self:GetInSights() then return end

        local soundtab = {
            name = "triggerdown",
            sound = self:RandomChoice(self.TriggerDownSound),
            channel = ARC9.CHAN_TRIGGER+7
        }

        self:PlayTranslatedSound(soundtab)
    end
end
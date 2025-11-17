GUI.AddToast("OPMONEY2.2", Added Improved $ Earned\n Console now shows when failed\n Some heists still only work once looking into it. , 5000, 0)

local CAYO_HEIST_INTERVAL_SECONDS = 31 * 60 

local cayoHeistLastTransactionTime = 0
local cayoHeistTimerActive = false
local cayoHeistInitialDelaySet = false

local CASINO_HEIST_INTERVAL_SECONDS = 61 * 60 
local CASINO_HEIST_PAYOUT = 3619000

local CAYO_HEIST_PAYOUT = 2050000

local DOOMSDAY_HEIST_INTERVAL_SECONDS = 61 * 60 
local DOOMSDAY_HEIST_PAYOUT = 2550000

local AGENCY_HEIST_INTERVAL_SECONDS = 61 * 60 
local AGENCY_HEIST_PAYOUT = 3000000

local APARTMENT_HEIST_INTERVAL_SECONDS = 61 * 60 
local APARTMENT_HEIST_PAYOUT = 3000000

local CLUCKING_BELL_HEIST_INTERVAL_SECONDS = 61 * 60
local CLUCKING_BELL_HEIST_PAYOUT = 1000000

local casinoHeistLastTransactionTime = 0
local casinoHeistTimerActive = false
local casinoHeistInitialDelaySet = false
local doomsdayHeistLastTransactionTime = 0
local doomsdayHeistTimerActive = false
local doomsdayHeistInitialDelaySet = false
local agencyHeistLastTransactionTime = 0
local agencyHeistTimerActive = false
local agencyHeistInitialDelaySet = false
local apartmentHeistLastTransactionTime = 0
local apartmentHeistTimerActive = false
local apartmentHeistInitialDelaySet = false
local cluckingBellHeistLastTransactionTime = 0
local cluckingBellHeistTimerActive = false
local cluckingBellHeistInitialDelaySet = false

local cayoHeistInitialDelay = 0
local casinoHeistInitialDelay = 0
local doomsdayHeistInitialDelay = 0
local agencyHeistInitialDelay = 0
local apartmentHeistInitialDelay = 0
local cluckingBellHeistInitialDelay = 0

local totalMoneyEarned = 0

local heistNames = {
    [0xDBF39508] = "Cayo Perico Heist",
    [0xB703ED29] = "Diamond Casino Heist",
    [Utils.Joaat("SERVICE_EARN_GANGOPS_FINALE")] = "Doomsday Heist Finale",
    [Utils.Joaat("SERVICE_EARN_AGENCY_FINALE")] = "Agency Heist Finale",
    [Utils.Joaat("SERVICE_EARN_HEIST_FINALE")] = "Apartment Heist Finale",
    [Utils.Joaat("SERVICE_EARN_CLUCKING_BELL_FINALE")] = "Clucking Bell Heist Finale"
}

local addFiveMinutesToggle = "AddFiveMinutesBetweenTimers"

local addFiveMinutesToggle = "AddFiveMinutesBetweenTimers"
local addFiveMinutesActive = false

local depositLocationToggle = "DepositLocation"
local depositLocation = 1 -- Default to Wallet (1), Bank is 2

local cayoHeistToggle = "CayoHeistFeature"
local casinoHeistToggle = "CasinoHeistFeature"
local doomsdayHeistToggle = "DoomsDayHeistFeature"
local agencyHeistToggle = "AgencyHeistFeature"
local apartmentHeistToggle = "ApartmentHeistFeature"
local cluckingBellHeistToggle = "CluckingBellHeistFeature"

local function getActiveHeistCount()
    local count = 0
    if cayoHeistTimerActive then count = count + 1 end
    if casinoHeistTimerActive then count = count + 1 end
    if doomsdayHeistTimerActive then count = count + 1 end
    if agencyHeistTimerActive then count = count + 1 end
    if apartmentHeistTimerActive then count = count + 1 end
    if cluckingBellHeistTimerActive then count = count + 1 end
    return count
end

function Natives.Invoke(returnType, hash)
    return function(...)
        return Natives[string.format("Invoke%s", returnType)](hash, ...)
    end
end


FeatureMgr.AddFeature(Utils.Joaat(cayoHeistToggle), "Enable Cayo Heist (2.05m payout)", eFeatureType.Toggle, "", function(f)
    local wasActive = cayoHeistTimerActive
    cayoHeistTimerActive = f:IsToggled()
    if cayoHeistTimerActive and not wasActive then
        cayoHeistLastTransactionTime = Time.Get()
        local otherActiveHeistCount = getActiveHeistCount() - 1
        if addFiveMinutesActive and otherActiveHeistCount > 0 then
            cayoHeistInitialDelaySet = false
            cayoHeistInitialDelay = otherActiveHeistCount * 300
        else
            TriggerTransaction(0xDBF39508, CAYO_HEIST_PAYOUT)
            cayoHeistInitialDelaySet = true
            cayoHeistInitialDelay = 0
        end
    elseif not cayoHeistTimerActive then
        cayoHeistInitialDelaySet = false
        cayoHeistInitialDelay = 0
    end
end)

FeatureMgr.AddFeature(Utils.Joaat(casinoHeistToggle), "Enable Casino Heist (3.6m payout)", eFeatureType.Toggle, "", function(f)
    local wasActive = casinoHeistTimerActive
    casinoHeistTimerActive = f:IsToggled()
    if casinoHeistTimerActive and not wasActive then
        casinoHeistLastTransactionTime = Time.Get()
        local otherActiveHeistCount = getActiveHeistCount() - 1
        if addFiveMinutesActive and otherActiveHeistCount > 0 then
            casinoHeistInitialDelaySet = false
            casinoHeistInitialDelay = otherActiveHeistCount * 300
        else
            TriggerTransaction(0xB703ED29, CASINO_HEIST_PAYOUT)
            casinoHeistInitialDelaySet = true
            casinoHeistInitialDelay = 0
        end
    elseif not casinoHeistTimerActive then
        casinoHeistInitialDelaySet = false
        casinoHeistInitialDelay = 0
    end
end)

FeatureMgr.AddFeature(Utils.Joaat(doomsdayHeistToggle), "Enable DoomsDay Heist Finale (2.55m payout)", eFeatureType.Toggle, "", function(f)
    local wasActive = doomsdayHeistTimerActive
    doomsdayHeistTimerActive = f:IsToggled()
    if doomsdayHeistTimerActive and not wasActive then
        doomsdayHeistLastTransactionTime = Time.Get()
        local otherActiveHeistCount = getActiveHeistCount() - 1
        if addFiveMinutesActive and otherActiveHeistCount > 0 then
            doomsdayHeistInitialDelaySet = false
            doomsdayHeistInitialDelay = otherActiveHeistCount * 300
        else
            TriggerTransaction(Utils.Joaat("SERVICE_EARN_GANGOPS_FINALE"), DOOMSDAY_HEIST_PAYOUT)
            doomsdayHeistInitialDelaySet = true
            doomsdayHeistInitialDelay = 0
        end
    elseif not doomsdayHeistTimerActive then
        doomsdayHeistInitialDelaySet = false
        doomsdayHeistInitialDelay = 0
    end
end)

FeatureMgr.AddFeature(Utils.Joaat(agencyHeistToggle), "Enable Agency Heist (3m payout)", eFeatureType.Toggle, "", function(f)
    local wasActive = agencyHeistTimerActive
    agencyHeistTimerActive = f:IsToggled()
    if agencyHeistTimerActive and not wasActive then
        agencyHeistLastTransactionTime = Time.Get()
        local otherActiveHeistCount = getActiveHeistCount() - 1
        if addFiveMinutesActive and otherActiveHeistCount > 0 then
            agencyHeistInitialDelaySet = false
            agencyHeistInitialDelay = otherActiveHeistCount * 300
        else
            TriggerTransaction(Utils.Joaat("SERVICE_EARN_AGENCY_FINALE"), AGENCY_HEIST_PAYOUT)
            agencyHeistInitialDelaySet = true
            agencyHeistInitialDelay = 0
        end
    elseif not agencyHeistTimerActive then
        agencyHeistInitialDelaySet = false
        agencyHeistInitialDelay = 0
    end
end)

FeatureMgr.AddFeature(Utils.Joaat(apartmentHeistToggle), "Enable Apartment Heist (3m payout)", eFeatureType.Toggle, "", function(f)
    local wasActive = apartmentHeistTimerActive
    apartmentHeistTimerActive = f:IsToggled()
    if apartmentHeistTimerActive and not wasActive then
        apartmentHeistLastTransactionTime = Time.Get()
        local otherActiveHeistCount = getActiveHeistCount() - 1
        if addFiveMinutesActive and otherActiveHeistCount > 0 then
            apartmentHeistInitialDelaySet = false
            apartmentHeistInitialDelay = otherActiveHeistCount * 300
        else
            TriggerTransaction(Utils.Joaat("SERVICE_EARN_HEIST_FINALE"), APARTMENT_HEIST_PAYOUT)
            apartmentHeistInitialDelaySet = true
            apartmentHeistInitialDelay = 0
        end
    elseif not apartmentHeistTimerActive then
        apartmentHeistInitialDelaySet = false
        apartmentHeistInitialDelay = 0
    end
end)

FeatureMgr.AddFeature(Utils.Joaat(cluckingBellHeistToggle), "Enable Clucking Bell Heist (1m payout)", eFeatureType.Toggle, "", function(f)
    local wasActive = cluckingBellHeistTimerActive
    cluckingBellHeistTimerActive = f:IsToggled()
    if cluckingBellHeistTimerActive and not wasActive then
        cluckingBellHeistLastTransactionTime = Time.Get()
        local otherActiveHeistCount = getActiveHeistCount() - 1
        if addFiveMinutesActive and otherActiveHeistCount > 0 then
            cluckingBellHeistInitialDelaySet = false
            cluckingBellHeistInitialDelay = otherActiveHeistCount * 300
        else
            TriggerTransaction(Utils.Joaat("SERVICE_EARN_CLUCKING_BELL_FINALE"), CLUCKING_BELL_HEIST_PAYOUT)
            cluckingBellHeistInitialDelaySet = true
            cluckingBellHeistInitialDelay = 0
        end
    elseif not cluckingBellHeistTimerActive then
        cluckingBellHeistInitialDelaySet = false
        cluckingBellHeistInitialDelay = 0
    end
end)

FeatureMgr.AddFeature(Utils.Joaat(addFiveMinutesToggle), "Add 5 minutes between each transaction", eFeatureType.Toggle, "", function(f)
    addFiveMinutesActive = f:IsToggled()
end)

FeatureMgr.AddFeature(Utils.Joaat(depositLocationToggle), "Deposit in", eFeatureType.List, "Choose where to deposit money (Wallet: 1, Bank: 2)", function(f)
    local selectedIndex = f:GetListIndex()
    if selectedIndex == 0 then -- Wallet
        depositLocation = 1
    elseif selectedIndex == 1 then -- Bank
        depositLocation = 2
    end
end)

local function formatMoneyWithCommas(amount)
    local s = tostring(math.floor(amount))
    local len = #s
    local result = ""
    local count = 0
    for i = len, 1, -1 do
        result = s:sub(i, i) .. result
        count = count + 1
        if count % 3 == 0 and i > 1 then
            result = "," .. result
        end
    end
    return result
end

local scriptStartTime = Time.Get() 

local function opmoneytab()
    local columns = 2
    if ImGui.BeginTable("OPMoney2Layout", columns, ImGuiTableFlags.SizingStretchSame) then
        local activeHeistCount = 0
        if cayoHeistTimerActive then activeHeistCount = activeHeistCount + 1 end
        if casinoHeistTimerActive then activeHeistCount = activeHeistCount + 1 end
        if doomsdayHeistTimerActive then activeHeistCount = activeHeistCount + 1 end
        if agencyHeistTimerActive then activeHeistCount = activeHeistCount + 1 end
        if apartmentHeistTimerActive then activeHeistCount = activeHeistCount + 1 end
        if cluckingBellHeistTimerActive then activeHeistCount = activeHeistCount + 1 end

        ImGui.TableNextRow()
        ImGui.TableSetColumnIndex(0)
        if ClickGUI.BeginCustomChildWindow("Toggles") then

            local newCayoHeistState = ImGui.Checkbox("Enable Cayo Heist (2.05m payout)", cayoHeistTimerActive)
            if newCayoHeistState ~= cayoHeistTimerActive then
                FeatureMgr.ToggleFeature(Utils.Joaat(cayoHeistToggle))
            end

            if cayoHeistTimerActive then
            end


            local newCasinoHeistState = ImGui.Checkbox("Enable Casino Heist (3.6m payout)", casinoHeistTimerActive)
            if newCasinoHeistState ~= casinoHeistTimerActive then
                FeatureMgr.ToggleFeature(Utils.Joaat(casinoHeistToggle))
            end

            if casinoHeistTimerActive then
            end

            local newDoomsdayHeistState = ImGui.Checkbox("Enable DoomsDay Heist (2.55m payout)", doomsdayHeistTimerActive)
            if newDoomsdayHeistState ~= doomsdayHeistTimerActive then
                FeatureMgr.ToggleFeature(Utils.Joaat(doomsdayHeistToggle))
            end

            if doomsdayHeistTimerActive then
            end

            local newAgencyHeistState = ImGui.Checkbox("Enable Agency Heist (3m payout)", agencyHeistTimerActive)
            if newAgencyHeistState ~= agencyHeistTimerActive then
                FeatureMgr.ToggleFeature(Utils.Joaat(agencyHeistToggle))
            end

            if agencyHeistTimerActive then
            end

   
            local newApartmentHeistState = ImGui.Checkbox("Enable Apartment Heist (3m payout)", apartmentHeistTimerActive)
            if newApartmentHeistState ~= apartmentHeistTimerActive then
                FeatureMgr.ToggleFeature(Utils.Joaat(apartmentHeistToggle))
            end

            if apartmentHeistTimerActive then
            end

            local newCluckingBellHeistState = ImGui.Checkbox("Enable Clucking Bell Heist (1m payout)", cluckingBellHeistTimerActive)
            if newCluckingBellHeistState ~= cluckingBellHeistTimerActive then
                FeatureMgr.ToggleFeature(Utils.Joaat(cluckingBellHeistToggle))
            end

            if cluckingBellHeistTimerActive then
            end
            ClickGUI.EndCustomChildWindow()
        end

        if ClickGUI.BeginCustomChildWindow("Settings") then
            local newAddFiveMinutesState = ImGui.Checkbox("Add 5 minutes between each timer", addFiveMinutesActive)
            if newAddFiveMinutesState ~= addFiveMinutesActive then
                FeatureMgr.ToggleFeature(Utils.Joaat(addFiveMinutesToggle))
            end

            local currentDepositLocationIndex = 0
            if depositLocation == 1 then
                currentDepositLocationIndex = 0 -- Wallet
            elseif depositLocation == 2 then
                currentDepositLocationIndex = 1 -- Bank
            end
            local newDepositLocationIndex = ImGui.Combo("Deposit in", currentDepositLocationIndex, "Wallet\0Bank\0\0")
            if newDepositLocationIndex ~= currentDepositLocationIndex then
                if newDepositLocationIndex == 0 then
                    depositLocation = 1 -- Directly update for UI responsiveness
                    FeatureMgr.SetFeatureListIndex(Utils.Joaat(depositLocationToggle), 0) -- Wallet
                elseif newDepositLocationIndex == 1 then
                    depositLocation = 2 -- Directly update for UI responsiveness
                    FeatureMgr.SetFeatureListIndex(Utils.Joaat(depositLocationToggle), 1) -- Bank
                end
            end
            ClickGUI.EndCustomChildWindow()

        ImGui.TableSetColumnIndex(1)
        if ClickGUI.BeginCustomChildWindow("Stats") then
            if cayoHeistTimerActive then
                local currentTime = Time.Get()
                local elapsedTime = currentTime - cayoHeistLastTransactionTime
                local remainingTimeSeconds
                if not cayoHeistInitialDelaySet then
                    remainingTimeSeconds = cayoHeistInitialDelay - elapsedTime
                else
                    remainingTimeSeconds = CAYO_HEIST_INTERVAL_SECONDS - elapsedTime
                end
                remainingTimeSeconds = math.max(0, remainingTimeSeconds)
                local remainingMinutes = math.floor(remainingTimeSeconds / 60)
                local remainingSeconds = math.floor(remainingTimeSeconds % 60)
                ImGui.Text(string.format("Next Cayo Heist in: %02d:%02d", remainingMinutes, remainingSeconds))
            else
                ImGui.Text("Cayo Heist Timer: Inactive")
            end

            if casinoHeistTimerActive then
                local currentTime = Time.Get()
                local elapsedTime = currentTime - casinoHeistLastTransactionTime
                local remainingTimeSeconds
                if not casinoHeistInitialDelaySet then
                    remainingTimeSeconds = casinoHeistInitialDelay - elapsedTime
                else
                    remainingTimeSeconds = CASINO_HEIST_INTERVAL_SECONDS - elapsedTime
                end
                remainingTimeSeconds = math.max(0, remainingTimeSeconds)
                local remainingMinutes = math.floor(remainingTimeSeconds / 60)
                local remainingSeconds = math.floor(remainingTimeSeconds % 60)
                ImGui.Text(string.format("Next Casino Heist in: %02d:%02d", remainingMinutes, remainingSeconds))
            else
                ImGui.Text("Casino Heist Timer: Inactive")
            end

            if doomsdayHeistTimerActive then
                local currentTime = Time.Get()
                local elapsedTime = currentTime - doomsdayHeistLastTransactionTime
                local remainingTimeSeconds
                if not doomsdayHeistInitialDelaySet then
                    remainingTimeSeconds = doomsdayHeistInitialDelay - elapsedTime
                else
                    remainingTimeSeconds = DOOMSDAY_HEIST_INTERVAL_SECONDS - elapsedTime
                end
                remainingTimeSeconds = math.max(0, remainingTimeSeconds)
                local remainingMinutes = math.floor(remainingTimeSeconds / 60)
                local remainingSeconds = math.floor(remainingTimeSeconds % 60)
                ImGui.Text(string.format("Next DoomsDay Heist in: %02d:%02d", remainingMinutes, remainingSeconds))
            else
                ImGui.Text("DoomsDay Heist Timer: Inactive")
            end

            if agencyHeistTimerActive then
                local currentTime = Time.Get()
                local elapsedTime = currentTime - agencyHeistLastTransactionTime
                local remainingTimeSeconds
                if not agencyHeistInitialDelaySet then
                    remainingTimeSeconds = agencyHeistInitialDelay - elapsedTime
                else
                    remainingTimeSeconds = AGENCY_HEIST_INTERVAL_SECONDS - elapsedTime
                end
                remainingTimeSeconds = math.max(0, remainingTimeSeconds)
                local remainingMinutes = math.floor(remainingTimeSeconds / 60)
                local remainingSeconds = math.floor(remainingTimeSeconds % 60)
                ImGui.Text(string.format("Next Agency Heist in: %02d:%02d", remainingMinutes, remainingSeconds))
            else
                ImGui.Text("Agency Heist Timer: Inactive")
            end

            if apartmentHeistTimerActive then
                local currentTime = Time.Get()
                local elapsedTime = currentTime - apartmentHeistLastTransactionTime
                local remainingTimeSeconds
                if not apartmentHeistInitialDelaySet then
                    remainingTimeSeconds = apartmentHeistInitialDelay - elapsedTime
                else
                    remainingTimeSeconds = APARTMENT_HEIST_INTERVAL_SECONDS - elapsedTime
                end
                remainingTimeSeconds = math.max(0, remainingTimeSeconds)
                local remainingMinutes = math.floor(remainingTimeSeconds / 60)
                local remainingSeconds = math.floor(remainingTimeSeconds % 60)
                ImGui.Text(string.format("Next Apartment Heist in: %02d:%02d", remainingMinutes, remainingSeconds))
            else
                ImGui.Text("Apartment Heist Timer: Inactive")
            end

            if cluckingBellHeistTimerActive then
                local currentTime = Time.Get()
                local elapsedTime = currentTime - cluckingBellHeistLastTransactionTime
                local remainingTimeSeconds
                if not cluckingBellHeistInitialDelaySet then
                    remainingTimeSeconds = cluckingBellHeistInitialDelay - elapsedTime
                else
                    remainingTimeSeconds = CLUCKING_BELL_HEIST_INTERVAL_SECONDS - elapsedTime
                end
                remainingTimeSeconds = math.max(0, remainingTimeSeconds)
                local remainingMinutes = math.floor(remainingTimeSeconds / 60)
                local remainingSeconds = math.floor(remainingTimeSeconds % 60)
                ImGui.Text(string.format("Next Clucking Bell Heist in: %02d:%02d", remainingMinutes, remainingSeconds))
            else
                ImGui.Text("Clucking Bell Heist Timer: Inactive")
            end

            local currentTime = Time.Get()
            local totalElapsedTimeSeconds = currentTime - scriptStartTime

            local hours = math.floor(totalElapsedTimeSeconds / 3600)
            local minutes = math.floor((totalElapsedTimeSeconds % 3600) / 60)
            local seconds = math.floor(totalElapsedTimeSeconds % 60)

            ImGui.Text(string.format("Script Running Time: %02d:%02d:%02d", hours, minutes, seconds))

            local totalEstimatedMoney = 0

            if cayoHeistTimerActive then
                totalEstimatedMoney = totalEstimatedMoney + (CAYO_HEIST_PAYOUT * 2)
            end
            if casinoHeistTimerActive then
                totalEstimatedMoney = totalEstimatedMoney + CASINO_HEIST_PAYOUT
            end
            if doomsdayHeistTimerActive then
                totalEstimatedMoney = totalEstimatedMoney + DOOMSDAY_HEIST_PAYOUT
            end
            if agencyHeistTimerActive then
                totalEstimatedMoney = totalEstimatedMoney + AGENCY_HEIST_PAYOUT
            end
            if apartmentHeistTimerActive then
                totalEstimatedMoney = totalEstimatedMoney + APARTMENT_HEIST_PAYOUT
            end
            if cluckingBellHeistTimerActive then
                totalEstimatedMoney = totalEstimatedMoney + CLUCKING_BELL_HEIST_PAYOUT
            end

            ImGui.Text(string.format("Estimated $ per hour: $%s", formatMoneyWithCommas(totalEstimatedMoney)))
            ImGui.Text(string.format("$ Earned: $%s", formatMoneyWithCommas(totalMoneyEarned)))

            ClickGUI.EndCustomChildWindow()
        end
        ImGui.EndTable()
    end
end
end

ClickGUI.AddTab("OP Money 2", opmoneytab)

local function heistLoop()
    while true do
        local currentTime = Time.Get()

        -- Cayo Heist
        if cayoHeistTimerActive then
            local interval = cayoHeistInitialDelaySet and CAYO_HEIST_INTERVAL_SECONDS or cayoHeistInitialDelay
            if currentTime - cayoHeistLastTransactionTime >= interval then
                TriggerTransaction(0xDBF39508, CAYO_HEIST_PAYOUT)
                cayoHeistLastTransactionTime = currentTime
                if not cayoHeistInitialDelaySet then
                    cayoHeistInitialDelaySet = true
                end
            end
        end

        -- Casino Heist
        if casinoHeistTimerActive then
            local interval = casinoHeistInitialDelaySet and CASINO_HEIST_INTERVAL_SECONDS or casinoHeistInitialDelay
            if currentTime - casinoHeistLastTransactionTime >= interval then
                TriggerTransaction(0xB703ED29, CASINO_HEIST_PAYOUT)
                casinoHeistLastTransactionTime = currentTime
                if not casinoHeistInitialDelaySet then
                    casinoHeistInitialDelaySet = true
                end
            end
        end

        -- Doomsday Heist
        if doomsdayHeistTimerActive then
            local interval = doomsdayHeistInitialDelaySet and DOOMSDAY_HEIST_INTERVAL_SECONDS or doomsdayHeistInitialDelay
            if currentTime - doomsdayHeistLastTransactionTime >= interval then
                TriggerTransaction(Utils.Joaat("SERVICE_EARN_GANGOPS_FINALE"), DOOMSDAY_HEIST_PAYOUT)
                doomsdayHeistLastTransactionTime = currentTime
                if not doomsdayHeistInitialDelaySet then
                    doomsdayHeistInitialDelaySet = true
                end
            end
        end

        -- Agency Heist
        if agencyHeistTimerActive then
            local interval = agencyHeistInitialDelaySet and AGENCY_HEIST_INTERVAL_SECONDS or agencyHeistInitialDelay
            if currentTime - agencyHeistLastTransactionTime >= interval then
                TriggerTransaction(Utils.Joaat("SERVICE_EARN_AGENCY_FINALE"), AGENCY_HEIST_PAYOUT)
                agencyHeistLastTransactionTime = currentTime
                if not agencyHeistInitialDelaySet then
                    agencyHeistInitialDelaySet = true
                end
            end
        end

        -- Apartment Heist
        if apartmentHeistTimerActive then
            local interval = apartmentHeistInitialDelaySet and APARTMENT_HEIST_INTERVAL_SECONDS or apartmentHeistInitialDelay
            if currentTime - apartmentHeistLastTransactionTime >= interval then
                TriggerTransaction(Utils.Joaat("SERVICE_EARN_HEIST_FINALE"), APARTMENT_HEIST_PAYOUT)
                apartmentHeistLastTransactionTime = currentTime
                if not apartmentHeistInitialDelaySet then
                    apartmentHeistInitialDelaySet = true
                end
            end
        end

        -- Clucking Bell Heist
        if cluckingBellHeistTimerActive then
            local interval = cluckingBellHeistInitialDelaySet and CLUCKING_BELL_HEIST_INTERVAL_SECONDS or cluckingBellHeistInitialDelay
            if currentTime - cluckingBellHeistLastTransactionTime >= interval then
                TriggerTransaction(Utils.Joaat("SERVICE_EARN_CLUCKING_BELL_FINALE"), CLUCKING_BELL_HEIST_PAYOUT)
                cluckingBellHeistLastTransactionTime = currentTime
                if not cluckingBellHeistInitialDelaySet then
                    cluckingBellHeistInitialDelaySet = true
                end
            end
        end
        Script.Yield()
    end
end

Script.QueueJob(heistLoop)

function TriggerTransaction(hash, price)
    local playerCharacter = Stats.GetInt(("mpply_last_mp_char"), 0)

    local initialMoney = 0
    if depositLocation == 1 then -- Wallet
        initialMoney = Natives.Invoke("Int", 0xA40F9C2623F6A8B5)(playerCharacter)
    elseif depositLocation == 2 then -- Bank
        initialMoney = Natives.Invoke("Int", 0x76EF28DA05EA395A)(playerCharacter)
    end

    if Natives.Invoke("Bool", 0xA65568121DF2EA26) then
        Natives.Invoke("Bool", 0xFA336E7F40C0A0D0)
    end

    -- Use depositLocation (1 for Wallet, 2 for Bank)
    local valid, id = GTA.BeginService(-1135378931, 0x57DE404E, hash, 0x562592BB, price, depositLocation)

    if valid then
        GTA.CheckoutStart(id)


        Script.Yield(4000)

        local finalMoney = 0
        if depositLocation == 1 then -- Wallet
            finalMoney = Natives.Invoke("Int", 0xA40F9C2623F6A8B5)(playerCharacter)
        elseif depositLocation == 2 then -- Bank
            finalMoney = Natives.Invoke("Int", 0x76EF28DA05EA395A)(playerCharacter)
        end

        local transactionSuccessful = (finalMoney - initialMoney) >= price
        local depositTarget = (depositLocation == 1 and "Wallet") or "Bank"
local heistName = heistNames[hash] or string.format("Heist:%x", hash)
        
        if transactionSuccessful then
            local message = string.format("[%s] Transaction successful! Deposited $%s into %s. Initial: $%s, Final: $%s.", heistName, formatMoneyWithCommas(price), depositTarget, formatMoneyWithCommas(initialMoney), formatMoneyWithCommas(finalMoney))
            print(message)
            GUI.AddToast("OPMONEY2", message, 5000, 0)
            totalMoneyEarned = totalMoneyEarned + price
        else
            local message = string.format("[%s] Transaction failed! Attempted to deposit $%s into %s. Initial: $%s, Final: $%s.", heistName, formatMoneyWithCommas(price), depositTarget, formatMoneyWithCommas(initialMoney), formatMoneyWithCommas(finalMoney))
            print(message)
            GUI.AddToast("OPMONEY2", message, 5000, 0)
        end
    else
        local message = string.format("Transaction initiation failed for $%s. 'GTA.BeginService' returned invalid.", formatMoneyWithCommas(price))
        print(message)
        GUI.AddToast("OPMONEY2", message, 5000, 0)
    end
end

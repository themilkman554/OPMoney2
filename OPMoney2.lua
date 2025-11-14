

local CAYO_HEIST_INTERVAL_SECONDS = 31 * 60 

local cayoHeistLastTransactionTime = 0
local cayoHeistTimerActive = false

local CASINO_HEIST_INTERVAL_SECONDS = 61 * 60 
local CASINO_HEIST_PAYOUT = 3600000

local CAYO_HEIST_PAYOUT = 2050000

local casinoHeistLastTransactionTime = 0
local casinoHeistTimerActive = false


local cayoHeistToggle = "CayoHeistFeature"
local casinoHeistToggle = "CasinoHeistFeature"

function Natives.Invoke(returnType, hash)
    return function(...)
        return Natives[F("Invoke%s", returnType)](hash, ...)
    end
end

FeatureMgr.AddFeature(Utils.Joaat(cayoHeistToggle), "Enable Cayo Heist (2.05m payout)", eFeatureType.Toggle, "", function(f)
    if f:IsToggled() then

        if not cayoHeistTimerActive then
            TriggerTransaction(0xDBF39508, CAYO_HEIST_PAYOUT)
            cayoHeistLastTransactionTime = Time.Get()
            cayoHeistTimerActive = true
        end
    else
        cayoHeistTimerActive = false
    end
end)

FeatureMgr.AddFeature(Utils.Joaat(casinoHeistToggle), "Enable Casino Heist (3.6m payout)", eFeatureType.Toggle, "", function(f)
    if f:IsToggled() then

        if not casinoHeistTimerActive then
            TriggerTransaction(0xB703ED29, CASINO_HEIST_PAYOUT)
            casinoHeistLastTransactionTime = Time.Get()
            casinoHeistTimerActive = true
        end
    else
        casinoHeistTimerActive = false
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
        ImGui.TableNextRow()
        ImGui.TableSetColumnIndex(0)
        if ClickGUI.BeginCustomChildWindow("Toggles") then

            local newCayoHeistState = ImGui.Checkbox("Enable Cayo Heist (2.05m payout)", cayoHeistTimerActive)
            if newCayoHeistState ~= cayoHeistTimerActive then
                FeatureMgr.ToggleFeature(Utils.Joaat(cayoHeistToggle))
                cayoHeistTimerActive = newCayoHeistState 
            end

            if cayoHeistTimerActive then
                local currentTime = Time.Get()
                local elapsedTime = currentTime - cayoHeistLastTransactionTime

                if elapsedTime >= CAYO_HEIST_INTERVAL_SECONDS then
                    TriggerTransaction(0xDBF39508, 2050000)
                    cayoHeistLastTransactionTime = currentTime
                    elapsedTime = 0 
                end

                local remainingTimeSeconds = CAYO_HEIST_INTERVAL_SECONDS - elapsedTime
                local remainingMinutes = math.floor(remainingTimeSeconds / 60)
                local remainingSeconds = math.floor(remainingTimeSeconds % 60)


            end


            local newCasinoHeistState = ImGui.Checkbox("Enable Casino Heist (3.6m payout)", casinoHeistTimerActive)
            if newCasinoHeistState ~= casinoHeistTimerActive then
                FeatureMgr.ToggleFeature(Utils.Joaat(casinoHeistToggle))
                casinoHeistTimerActive = newCasinoHeistState
            end

            if casinoHeistTimerActive then
                local currentTime = Time.Get()
                local elapsedTime = currentTime - casinoHeistLastTransactionTime

                if elapsedTime >= CASINO_HEIST_INTERVAL_SECONDS then
                    TriggerTransaction(0xB703ED29, 3600000)
                    casinoHeistLastTransactionTime = currentTime
                    elapsedTime = 0 
                end

                local remainingTimeSeconds = CASINO_HEIST_INTERVAL_SECONDS - elapsedTime
                local remainingMinutes = math.floor(remainingTimeSeconds / 60)
                local remainingSeconds = math.floor(remainingTimeSeconds % 60)


            end
            ClickGUI.EndCustomChildWindow()
        end

        ImGui.TableSetColumnIndex(1)
        if ClickGUI.BeginCustomChildWindow("Stats") then
            if cayoHeistTimerActive then
                local currentTime = Time.Get()
                local elapsedTime = currentTime - cayoHeistLastTransactionTime
                local remainingTimeSeconds = CAYO_HEIST_INTERVAL_SECONDS - elapsedTime
                local remainingMinutes = math.floor(remainingTimeSeconds / 60)
                local remainingSeconds = math.floor(remainingTimeSeconds % 60)
                ImGui.Text(string.format("Next Cayo Heist in: %02d:%02d", remainingMinutes, remainingSeconds))
            else
                ImGui.Text("Cayo Heist Timer: Inactive")
            end

            if casinoHeistTimerActive then
                local currentTime = Time.Get()
                local elapsedTime = currentTime - casinoHeistLastTransactionTime
                local remainingTimeSeconds = CASINO_HEIST_INTERVAL_SECONDS - elapsedTime
                local remainingMinutes = math.floor(remainingTimeSeconds / 60)
                local remainingSeconds = math.floor(remainingTimeSeconds % 60)
                ImGui.Text(string.format("Next Casino Heist in: %02d:%02d", remainingMinutes, remainingSeconds))
            else
                ImGui.Text("Casino Heist Timer: Inactive")
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

            ImGui.Text(string.format("Estimated $ per hour: $%s", formatMoneyWithCommas(totalEstimatedMoney)))

            ClickGUI.EndCustomChildWindow()
        end
        ImGui.EndTable()
    end
end

ClickGUI.AddTab("OP Money 2", opmoneytab)




function TriggerTransaction(hash, price)
    if Natives.Invoke("Bool",(0xA65568121DF2EA26)) then
        Natives.Invoke("Bool",(0xFA336E7F40C0A0D0))
    end

    local valid, id = GTA.BeginService(-1135378931, 0x57DE404E, hash, 0x562592BB, price, 2)

    if valid then
        GTA.CheckoutStart(id)
    end
end

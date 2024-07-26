
BLOODQUEEN_REPORTCHANNEL = "RAID_WARNING";
BLOODQUEEN_REPORTMC = true;
BLOODQUEEN_REPORTBITE = true;
BLOODQUEEN_REPORTASSIGN = false;
BLOODQUEEN_WHISPASSIGN = true;
BLOODQUEEN_WARNTIMER = 5;
BLOODQUEEN_ICONS = true;
BLOODQUEEN_RECOUNT = false;
BLOODQUEEN_DETAILS = false;
BLOODQUEEN_SKADA = false;
BLOODQUEEN_DUAL = false;
BLOODQUEEN_DUALTRADE = true;
BLOODQUEEN_ICONSVAMP = false;
BloodQueen_List={
};

BloodQueen_Profile = {
		[0] = 1,
		[1] = {
			["name"] = BloodQueen_Local["Default"],
			["list"] = BloodQueen_List,
			["reportchannel"] = BLOODQUEEN_REPORTCHANNEL,
			["warntimer"] = BLOODQUEEN_WARNTIMER,
			["icons"] = BLOODQUEEN_ICONS,
			["vampicons"] = BLOODQUEEN_ICONSVAMP,
			["dual"] = BLOODQUEEN_DUAL,
			["dualtrade"] = BLOODQUEEN_DUALTRADE,
			["recount"] = BLOODQUEEN_RECOUNT,
			["details"] = BLOODQUEEN_DETAILS,
			["skada"] = BLOODQUEEN_SKADA,
			["reportmc"] = BLOODQUEEN_REPORTMC,
			["reportbite"] = BLOODQUEEN_REPORTBITE,
			["reportassign"] = BLOODQUEEN_REPORTASSIGN,
			["wshipassign"] = BLOODQUEEN_WHISPASSIGN,
		},
};

local BloodQueen_Config = {
    reportChannel = BLOODQUEEN_REPORTCHANNEL or "RAID_WARNING",
    reportMC = BLOODQUEEN_REPORTMC or true,
    reportBite = BLOODQUEEN_REPORTBITE or true,
    reportAssign = BLOODQUEEN_REPORTASSIGN or false,
    whisperAssign = BLOODQUEEN_WHISPASSIGN or true,
    warnTimer = BLOODQUEEN_WARNTIMER or 5,
    useIcons = BLOODQUEEN_ICONS or true,
    useRecount = BLOODQUEEN_RECOUNT or false,
    useDetails = BLOODQUEEN_DETAILS or false,
    useSkada = BLOODQUEEN_SKADA or false,
    useDual = BLOODQUEEN_DUAL or false,
    useDualTrade = BLOODQUEEN_DUALTRADE or true,
    useIconsVamp = BLOODQUEEN_ICONSVAMP or false,
}

local BloodQueen_Difficulty = {
    [10] = {2, 15, 20},
    [25] = {5, 10, 15}
}

local BloodQueen_Version = "1.0.8"
local BloodQueen_Run = {false, 0}
local BloodQueen_Icon = 1
local BloodQueen_RaidList = { }
local BloodQueen_TestRaidList = { }

local function createEmptyRaidEntry()
    return {
        name = "", raidid = 0, from = 0, bite = -1, bitetimer = 0, warn = 0,
        warntimer = 0, raidicon = false, raidicontimer = 0, mc = 0, type = 0, damage = 0
    }
end



function BloodQueenResetRaidList()
    BloodQueen_RaidList = {}
    for i = 1, 25 do
        BloodQueen_RaidList[i] = createEmptyRaidEntry()
    end
end

function BloodQueenResetTestRaidList()
    BloodQueen_TestRaidList = {}
    for i = 1, 25 do
        BloodQueen_TestRaidList[i] = createEmptyRaidEntry()
    end
end

local function BloodQueen_Size()
    local _, _, _, _, maxraid = GetInstanceInfo()
    return maxraid
end

function BQReportData()
    if BloodQueen_Config.useRecount and Recount then
        -- Report data using Recount
        local lasttable = Recount.db.profile.MainWindowMode
        Recount.db.profile.CurDataSet = "CurrentFightData"
        Recount.MainWindow.DispTableSorted = {}
        Recount.MainWindow.DispTableLookup = {}
        Recount.FightName = "Current Fight"
        Recount:RefreshMainWindow()
        if RecountDeathTrack then RecountDeathTrack:SetFight(Recount.db.profile.CurDataSet) end
        Recount:SetMainWindowMode(1)

        local dataMode = Recount.MainWindowData[Recount.db.profile.MainWindowMode]
        local data = dbCombatants
        local reportTable = Recount.MainWindow.DispTableSorted
        local lookup = Recount.MainWindow.DispTableLookup
        local Total = 0

        if type(data) == "table" then
            for k, v in pairs(data) do
                if v and v.type and Recount.db.profile.Filters.Show[v.type] then
                    if v.Fights[Recount.db.profile.CurDataSet] then
                        local Value, PerSec = dataMode[2](self, v, 1)
                        if Value > 0 then
                            if v.type ~= "Pet" or not Recount.db.profile.MergePets then
                                Total = Total + Value
                            end
                            if lookup[k] then
                                lookup[k][1] = k
                                lookup[k][2] = Value
                                lookup[k][5] = PerSec
                            else
                                lookup[k] = {k, Value, v.enClass, v, PerSec}
                                table.insert(reportTable, lookup[k])
                            end
                        end
                    end
                end
            end
        end

        for i = 1, 100 do
            if reportTable[i] and reportTable[i][2] > 0 then
                local PerSec = reportTable[i][5] and string.format("%.1f, ", reportTable[i][5]) or ""
                BloodQueen_HandleRecount(reportTable[i][1], math.floor(10 * reportTable[i][2]) / 10)
            end
        end

        Recount:SetMainWindowMode(lasttable)
    elseif BloodQueen_Config.useSkada and Skada then
        local set = Skada:find_set("current")
        if set then 
            for _, player in ipairs(set.players) do
                if player.damage > 0 then
                    BloodQueen_HandleRecount(player.name, player.damage)
                end
            end
        end
    elseif BloodQueen_Config.useDetails and Details then
        local combat = Details:GetCurrentCombat()
        local damageActors = combat:GetActorList(DETAILS_ATTRIBUTE_DAMAGE)
        for _, actor in ipairs(damageActors) do
            BloodQueen_HandleRecount(actor.name, actor.damage)
        end
    end
end

function BloodQueen_HandleRecount(player,damage)
	for i=1,BloodQueen_Size() do
		if(BloodQueen_RaidList[i]["name"]==player) then
			BloodQueen_RaidList[i]["damage"]= damage;
			return;
		end
	end
end

local function BloodQueen_Report(msg)
    SendChatMessage(msg, BloodQueen_Config.reportChannel)
end

local function BloodQueen_Whisper(msg, target)
    if BloodQueen_Config.whisperAssign then
        SendChatMessage(msg, "WHISPER", nil, target)
    end
end

function BloodQueenFilterWhisper(table,event,msg)
	if  ( event == "CHAT_MSG_WHISPER_INFORM" and BloodQueen_Run[1] ) then
		startPos, endPos = strfind(msg, ">>");
		if startPos == 1 and endPos == 2 then
			return true;
		end
	end
	return false;
end

function BloodQueen_BiteNumber()
    local number = 0
    for y = 1, BloodQueen_Size() do
        if BloodQueen_RaidList[y].bite == 2 then
            number = number + 1
        end
    end
    return number
end

local function BloodQueen_SetRaidTarget(target, icon)
    if BloodQueen_Config.useIcons and icon and target then
        SetRaidTarget(target, icon)
    end
end


function BloodQueen_Print(sms,type)
	if sms then
		if type == 1 then
			DEFAULT_CHAT_FRAME:AddMessage( "|c0000FF00["..BloodQueen_Local["BloodQueen"].."]|r "..sms);
		else
			DEFAULT_CHAT_FRAME:AddMessage( "|c0000FF00["..BloodQueen_Local["BloodQueen"].."]|r |c00FFFF00"..sms.."|r");
		end
	end
end

function BQGetNext(target,type)
	local value=0;
	local max;
	for i=1,BloodQueen_Size() do
		local _, _, group, _, _, _, _, online, isDead = GetRaidRosterInfo(BloodQueen_RaidList[i]["raidid"]);
		if(BloodQueen_RaidList[i]["damage"] >= value and (not BloodQueen_GetGhostID(BloodQueen_RaidList[i]["raidid"])) and BloodQueen_RaidList[i]["bite"] == 0 and BloodQueen_RaidList[i]["mc"] == 0 and (not isDead) and online and target~= BloodQueen_RaidList[i]["name"] and (BloodQueen_RaidList[i]["type"]==type or (not type))) then
			value = BloodQueen_RaidList[i]["damage"];
			max = i;
		end
	end
	if not max and type then
		return 300;
	end
	return max;
end

function BloodQueen_Bite(x, target, dead, icon, type)
    if not IsRaidLeader() then return end -- Verifica se é líder da raid

    if BloodQueen_BiteNumber() >= 16 then return end -- Limite de mordidas

    local whisp = false
    local match

    if BloodQueen_BiteNumber() == 1 and BloodQueen_Config.useDualTrade then
        if type == 1 then
            type = 2
        elseif type == 2 then
            type = 1
        end
    end

    if BloodQueen_Config.useRecount or BloodQueen_Config.useSkada or BloodQueen_Config.useDetails then
        BQReportData()
        match = BQGetNext(target, type)
    end

    for y = 1, BloodQueen_Size() do
        local _, _, group, _, _, _, _, online, isDead = GetRaidRosterInfo(BloodQueen_RaidList[y].raidid)

        if ((not match) or y == match) and (not BloodQueen_GetGhostID(BloodQueen_RaidList[y].raidid)) and BloodQueen_RaidList[y].bite == 0 and BloodQueen_RaidList[y].mc == 0 and (not isDead) and online and target ~= BloodQueen_RaidList[y].name and (BloodQueen_RaidList[y].type == type or (not type)) then
            local newicon = ""
            local vampicon = ""
            local yicon = y

            if BloodQueen_Config.useIcons then
                if BloodQueen_Config.useIconsVamp then
                    vampicon = icon and "{rt" .. icon .. "}" or "{rt" .. BloodQueen_Icon .. "}"
                    yicon = y
                else
                    newicon = icon and "{rt" .. icon .. "}" or "{rt" .. BloodQueen_Icon .. "}"
                end
            end

            if dead then
                local timeleft = BloodQueen_Config.warnTimer - dead

                if timeleft > 0 then
                    SendAddonMessage("BloodQueenGTA", "BITE " .. target .. " " .. BloodQueen_RaidList[y].name .. " " .. (timeleft + BloodQueen_Difficulty[BloodQueen_Size()][2]), "RAID")
                    BloodQueen_Whisper(string.format(BloodQueen_Local[">>Target Dead/Offline! BITE"], newicon, BloodQueen_RaidList[y].name, group, timeleft), target)
                    BloodQueen_Whisper(string.format(BloodQueen_Local[">>is going to bite you"], vampicon, target, timeleft), BloodQueen_RaidList[y].name)
                    BloodQueen_RaidList[y].bitetimer = 0
                    BloodQueen_RaidList[y].bite = 1
                    BloodQueen_RaidList[y].from = target
                    BloodQueen_RaidList[yicon].raidicon = icon
                    BloodQueen_RaidList[yicon].raidicontimer = timeleft + BloodQueen_Difficulty[BloodQueen_Size()][2]
                    BloodQueen_SetRaidTarget("raid" .. BloodQueen_RaidList[yicon].raidid, icon)
                    if BloodQueen_Config.reportAssign then
                        BloodQueen_Report(string.format(BloodQueen_Local["Report Bite"], vampicon, target, newicon, BloodQueen_RaidList[y].name))
                    end
                    whisp = true
                    break
                else
                    SendAddonMessage("BloodQueenGTA", "BITE " .. target .. " nil 0", "RAID")
                    BloodQueen_Whisper(BloodQueen_Local[">>Target Dead/Offline! BITE ANYONE FAST<<"], target)
                    whisp = true
                    break
                end
            else
                SendAddonMessage("BloodQueenGTA", "BITE " .. target .. " " .. BloodQueen_RaidList[y].name .. " " .. (BloodQueen_Config.warnTimer + BloodQueen_Difficulty[BloodQueen_Size()][2]), "RAID")
                BloodQueen_Whisper(string.format(BloodQueen_Local[">>BITE"], newicon, BloodQueen_RaidList[y].name, group, BloodQueen_Config.warnTimer), target)
                BloodQueen_Whisper(string.format(BloodQueen_Local[">>is going to bite you"], vampicon, target, BloodQueen_Config.warnTimer), BloodQueen_RaidList[y].name)
                BloodQueen_RaidList[y].bitetimer = 0
                BloodQueen_RaidList[y].bite = 1
                BloodQueen_RaidList[y].from = target
                BloodQueen_RaidList[yicon].raidicon = BloodQueen_Icon
                BloodQueen_RaidList[yicon].raidicontimer = BloodQueen_Config.warnTimer + BloodQueen_Difficulty[BloodQueen_Size()][2]
                BloodQueen_SetRaidTarget("raid" .. BloodQueen_RaidList[yicon].raidid, BloodQueen_Icon)
                if BloodQueen_Config.reportAssign then
                    BloodQueen_Report(string.format(BloodQueen_Local["Report Bite"], vampicon, target, newicon, BloodQueen_RaidList[y].name))
                end
                whisp = true
                break
            end
        end
    end

    if not whisp then
        BloodQueen_Whisper(BloodQueen_Local[">>THERE'S NO ONE LEFT TO BITE GG<<"], target)
    end

    -- Atualiza a lista com o novo alvo
    for y = 1, BloodQueen_Size() do
        if BloodQueen_RaidList[y].name == target then
            BloodQueen_RaidList[y].target = BloodQueen_RaidList[x].name  -- Atualiza o alvo correto
            break
        end
    end

    -- Reseta o alvo para "Loading..." após a mordida ser completada
    BloodQueen_RaidList[x].target = "Loading..."

    -- Envia mensagem informando que a mordida ocorreu
    SendAddonMessage("BloodQueenGTA", "BITE_COMPLETE " .. BloodQueen_RaidList[x].name .. " " .. target, "RAID")

    -- Atualiza a lista de vampiros na interface
    AtualizarListaVampiros()
end

local function CheckBuffsAndHideFrames(framePrincipal, frameNomes)
    local allBuffsGone = true
    for x = 1, BloodQueen_Size() do
        local raidEntry = BloodQueen_RaidList[x]
        if raidEntry and raidEntry.name ~= "" then
            local timer1 = BloodQueen_GetTimers(raidEntry.raidid)
            local timer2 = BloodQueen_GetTimersBiting(raidEntry.raidid)
            if timer1 < 10000 or timer2 < 10000 then
                allBuffsGone = false
                break
            end
        end
    end

    if not InCombatLockdown() and allBuffsGone then
        frameNomes:Hide()
        framePrincipal:Hide()
    end
end


function BloodQueen_IconCycle()
    BloodQueen_Icon = BloodQueen_Icon - 1
    if BloodQueen_Icon == 0 then
        BloodQueen_Icon = 8
    end
end

function BloodQueen_CheckList(tab,name)
	for z=1,table.getn(tab) do
		if (tab[z]["name"]==name) then
			return false;
		end
	end
	return true;
end

function BloodQueen_Reset()
    BloodQueenResetRaidList()
    local i = 1

    for l = 1, #BloodQueen_List do
        for r = 1, GetNumRaidMembers() do
            local name, _, group = GetRaidRosterInfo(r)
            if name == BloodQueen_List[l][1] and group <= BloodQueen_Difficulty[BloodQueen_Size()][1] and BloodQueen_CheckList(BloodQueen_RaidList, name) then
                BloodQueen_RaidList[i] = {
                    name = name, raidid = r, bite = 0, bitetimer = 0, warn = 0,
                    warntimer = 0, from = 0, raidicon = false, raidicontimer = 0, mc = 0, type = BloodQueen_List[l][2]
                }
                i = i + 1
            end
        end
    end

    if i <= BloodQueen_Size() then
        for h = 1, GetNumRaidMembers() do
            local name, _, group = GetRaidRosterInfo(h)
            if group <= BloodQueen_Difficulty[BloodQueen_Size()][1] then
                local found = false
                for j = 1, BloodQueen_Size() do
                    if name == BloodQueen_RaidList[j].name then
                        found = true
                        break
                    end
                end
                if not found then
                    BloodQueen_RaidList[i] = {
                        name = name, raidid = h, bite = 0, bitetimer = 0, warn = 0,
                        warntimer = 0, from = 0, raidicon = false, raidicontimer = 0, mc = 0, type = 0
                    }
                    i = i + 1
                end
            end
        end
    end

    BloodQueen_Icon = 8
    BloodQueen_Run = {true, 0}
    BloodQueen_Print(string.format(BloodQueen_Local["firstbite"], BloodQueen_Size()), 2)

    if IsRaidLeader() then
        BloodQueen_SendPriorityList()
    end
end

function BloodQueen_Test()
    B_Save_OnClick()
    local diff = GetRaidDifficulty()
    if diff == 1 or diff == 3 then
        diff = 10
    elseif diff == 2 or diff == 4 then
        diff = 25
    end
    if diff == 25 or diff == 10 then
        BloodQueenResetTestRaidList()
        local i = 1
        for l = 1, #BloodQueen_List do
            for r = 1, GetNumRaidMembers() do
                local name, _, group = GetRaidRosterInfo(r)
                if name == BloodQueen_List[l][1] and group <= BloodQueen_Difficulty[diff][1] and BloodQueen_CheckList(BloodQueen_TestRaidList, name) then
                    BloodQueen_TestRaidList[i] = {
                        name = name, raidid = r, bite = 0, bitetimer = 0, warn = 0,
                        warntimer = 0, from = 0, raidicon = false, raidicontimer = 0, mc = 0, type = BloodQueen_List[l][2]
                    }
                    i = i + 1
                end
            end
        end
        if i <= diff then
            for h = 1, GetNumRaidMembers() do
                local _, _, group = GetRaidRosterInfo(h)
                if group <= BloodQueen_Difficulty[diff][1] then
                    local found
                    for j = 1, diff do
                        if UnitName("raid" .. h) == BloodQueen_TestRaidList[j].name then
                            found = 1
                            break
                        end
                    end
                    if not found then
                        BloodQueen_TestRaidList[i] = {
                            name = UnitName("raid" .. h), raidid = h, bite = 0, bitetimer = 0, warn = 0,
                            warntimer = 0, from = 0, raidicon = false, raidicontimer = 0, mc = 0, type = 0
                        }
                        i = i + 1
                    end
                end
            end
        end
        BloodQueen_Print(string.format(BloodQueen_Local["man detected"], diff), 2)
        BloodQueen_Print(BloodQueen_Local["Priority Setup for self raid:"], 2)
        if BloodQueen_Config.useDual then
            local x = 1
            BloodQueen_Print(BloodQueen_Local["Melee:"], 2)
            for i = 1, diff do
                if BloodQueen_TestRaidList[i].type == 1 and BloodQueen_TestRaidList[i].name ~= "" then
                    BloodQueen_Print(x .. " - " .. BloodQueen_TestRaidList[i].name, 1)
                    x = x + 1
                end
            end
            BloodQueen_Print(BloodQueen_Local["Ranged:"], 2)
            for i = 1, diff do
                if BloodQueen_TestRaidList[i].type == 2 and BloodQueen_TestRaidList[i].name ~= "" then
                    BloodQueen_Print(x .. " - " .. BloodQueen_TestRaidList[i].name, 1)
                    x = x + 1
                end
            end
            BloodQueen_Print(BloodQueen_Local["Undifferentiated:"], 2)
            for i = 1, diff do
                if BloodQueen_TestRaidList[i].type == 0 and BloodQueen_TestRaidList[i].name ~= "" then
                    BloodQueen_Print(x .. " - " .. BloodQueen_TestRaidList[i].name, 1)
                    x = x + 1
                end
            end
        else
            for i = 1, diff do
                if BloodQueen_TestRaidList[i].name ~= "" then
                    BloodQueen_Print(i .. " - " .. BloodQueen_TestRaidList[i].name, 1)
                end
            end
        end
    end
end

function BloodQueen_GetTimersBiting(id)
    if id ~= 0 then
        for t = 1, 10 do
            if UnitDebuff("raid" .. id, t) then
                local name, _, _, _, _, _, expirationTime = UnitDebuff("raid" .. id, t)
                if name == GetSpellInfo(70877) then -- Frenzied Bloodthirst
                    return expirationTime - GetTime()
                end
            else
                return 10000
            end
        end
    end
    return 10000
end

function BloodQueen_GetTimers(id)
	if id ~= 0 then
		for t=1,10 do
			if (UnitDebuff("raid"..id,t)) then
				local name, _, _, _, _, _, expirationTime= UnitDebuff("raid"..id,t);
				if (name == GetSpellInfo(70867)) then --essence of the blood queen
					return expirationTime-GetTime();
				end
			else
				return 10000;
			end
		end
	end
	return 10000;
end

function BloodQueen_GetMC(id)
	if id ~= 0 then
		for t=1,10 do
			if (UnitDebuff("raid"..id,t)) then
				if ( UnitDebuff("raid"..id,t) == GetSpellInfo(70923)) then
					return true;
				end
			else
				return false;
			end
		end
	end
	return false;
end
function BloodQueen_GetGhostPlayer()
	for t=1,GetNumRaidMembers() do
		if (UnitName("player") == UnitName("raid"..t)) then
			for x=1,10 do
				if (UnitDebuff("raid"..t,x)) then
					local _, _, _, _, _, _, _, _, _, _, spellId = UnitDebuff("raid"..t,x);
					if (spellId == 8326) then -- if ghost, reset mod
						return true;
					end
				else
					return false;
				end
			end
			break;
		end
	end
	return false;
end
function BloodQueen_GetGhostID(id)
	for x=1,10 do
		if (UnitDebuff("raid"..id,x)) then
			local _, _, _, _, _, _, _, _, _, _, spellId = UnitDebuff("raid"..id,x);
			if (spellId == 8326) then -- if ghost, reset mod
				return true;
			end
		else
			return false;
		end
	end
	return false;
end

function BloodQueen_OnUpdate(self, arg1)
    if BloodQueen_Run[1] then
        for x = 1, BloodQueen_Size() do
            local raidEntry = BloodQueen_RaidList[x]
            if raidEntry.bite ~= 2 then
                if BloodQueen_GetTimers(raidEntry.raidid) ~= 10000 then
                    raidEntry.bite = 2
                    if raidEntry.type == 0 and BloodQueen_Config.useDual then
                        raidEntry.type = 2
                    end
                    raidEntry.bitetimer = 0
                    if BloodQueen_Config.reportBite then
                        BloodQueen_Report(string.format(BloodQueen_Local["Report Vampire"], BloodQueen_BiteNumber(), raidEntry.name))
                    end
                end
            elseif BloodQueen_GetTimers(raidEntry.raidid) < BloodQueen_Config.warnTimer and raidEntry.warn == 0 and raidEntry.mc == 0 then
                raidEntry.warntimer = 0
                raidEntry.warn = 1
                BloodQueen_Bite(x, UnitName("raid" .. raidEntry.raidid), nil, nil, raidEntry.type)
            elseif BloodQueen_GetMC(raidEntry.raidid) and raidEntry.mc == 0 then
                raidEntry.mc = 1
                if BloodQueen_Config.reportMC then
                    BloodQueen_Report(string.format(BloodQueen_Local["Report MC"], raidEntry.name))
                end
            end
            if raidEntry.bite == 1 then
                local _, _, group, _, _, _, _, online, isDead = GetRaidRosterInfo(raidEntry.raidid)
                if isDead or not online then
                    raidEntry.bite = 0
                    BloodQueen_SetRaidTarget("raid" .. raidEntry.raidid, 0)
                    if BloodQueen_Config.reportAssign then
                        BloodQueen_Report(string.format(BloodQueen_Local["target died/disconnected!"], raidEntry.from))
                    end
                    BloodQueen_Bite(x, raidEntry.from, raidEntry.bitetimer, raidEntry.raidicon, raidEntry.type)
                    raidEntry.bitetimer = 0
                    raidEntry.raidicon = false
                    raidEntry.raidicontimer = 0
                else
                    raidEntry.bitetimer = raidEntry.bitetimer + arg1
                    if raidEntry.bitetimer > BloodQueen_Config.warnTimer + BloodQueen_Difficulty[BloodQueen_Size()][3] then
                        raidEntry.bite = 0
                        raidEntry.bitetimer = 0
                    end
                end
            end
            if raidEntry.warn == 1 then
                raidEntry.warntimer = raidEntry.warntimer + arg1
                if raidEntry.warntimer > BloodQueen_Config.warnTimer + BloodQueen_Difficulty[BloodQueen_Size()][3] then
                    raidEntry.warn = 0
                    raidEntry.warntimer = 0
                end
            end
            if raidEntry.raidicon then
                raidEntry.raidicontimer = raidEntry.raidicontimer - arg1
                if raidEntry.raidicontimer < 0 then
                    raidEntry.raidicon = false
                    raidEntry.raidicontimer = 0
                    BloodQueen_SetRaidTarget("raid" .. raidEntry.raidid, 0)
                end
            end
        end
        BloodQueen_Run[2] = BloodQueen_Run[2] + arg1
        if (BloodQueen_Run[2] > 350 and not InCombatLockdown()) or BloodQueen_GetGhostPlayer() then
            BloodQueen_Run[1] = false
            BloodQueen_Run[2] = 0
        end
    else
        for i = 1, GetNumRaidMembers() do
            if BloodQueen_GetTimers(i) ~= 10000 then
                BloodQueen_Reset()
            end
        end
    end
end


-----------
--FRAME--
-----------

function BloodQueen_SendPriorityList()
    if IsRaidLeader() then
        local priorityList = {}
        for _, v in ipairs(BloodQueen_List) do
            table.insert(priorityList, v[1] .. "," .. tostring(v[2]))
        end
        SendAddonMessage("BloodQueenGTA", "PRIORITY_LIST " .. table.concat(priorityList, ";"), "RAID")
    end
end


function BloodQueen_ReceivePriorityList(message)
    BloodQueen_List = {}
    local list = {strsplit(";", message)}
    for _, v in ipairs(list) do
        local name, prioType = strsplit(",", v)
        table.insert(BloodQueen_List, {name, tonumber(prioType)})
    end
    BloodQueen_ListFix()
    AtualizarListaVampiros()
end



-- Função para criar o frame principal para "VAMPIROS"
function CriarFramePrincipal()
    local framePrincipal = CreateFrame("Frame", "MeuAddonFramePrincipal", UIParent)
    framePrincipal:SetSize(250, 30)
    framePrincipal:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, -100)
    framePrincipal:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        edgeSize = 16,
        insets = {left = 8, right = 6, top = 8, bottom = 8},
    })
    framePrincipal:SetBackdropColor(0, 0, 0, 0.7)

    local textoPrincipal = framePrincipal:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    textoPrincipal:SetPoint("CENTER", framePrincipal, "CENTER", 0, 0)
    textoPrincipal:SetText("VAMPIROS : : ALVOS")

    framePrincipal:SetMovable(true)
    framePrincipal:EnableMouse(true)

    framePrincipal:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            self:StartMoving()
        end
    end)

    framePrincipal:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            self:StopMovingOrSizing()
        end
    end)

    framePrincipal:Show()  -- Mostra o frame principal

    return framePrincipal, textoPrincipal
end

function CriarFrameNomesVampiros(framePrincipal)
    local frameNomes = CreateFrame("Frame", "MeuAddonFrameNomes", UIParent)
    frameNomes:SetSize(500, 200)  -- Tamanho inicial do frame
    frameNomes:SetPoint("TOPLEFT", framePrincipal, "BOTTOMLEFT", 0, -5)
    frameNomes:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        edgeSize = 16,
        insets = {left = 8, right = 6, top = 8, bottom = 8},
    })
    frameNomes:SetBackdropColor(0, 0, 0, 0.7)

    frameNomes:SetMovable(true)
    frameNomes:EnableMouse(true)

    frameNomes:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            self:StartMoving()
        end
    end)

    frameNomes:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            self:StopMovingOrSizing()
        end
    end)

    local listaNomes = {}

    function AtualizarListaVampiros()
		for _, nomeFrame in ipairs(listaNomes) do
			nomeFrame:Hide()
		end
		wipe(listaNomes)
	
		local yOffset = -10
		local xOffset = 10
		local columnCounter = 0
		local vampirosEncontrados = false
		local listaVampiros = {}
	
		for raidIndex = 1, #BloodQueen_RaidList do
			if BloodQueen_RaidList[raidIndex].bite == 2 then
				local nomeVampiro = BloodQueen_RaidList[raidIndex].name
				local raidIcon = BloodQueen_RaidList[raidIndex].raidicon
				local iconeTextura = raidIcon and GetRaidTargetIndex("raid" .. BloodQueen_RaidList[raidIndex].raidid) or 0
				local iconeMarcacao = iconeTextura > 0 and "{rt" .. iconeTextura .. "}" or ""
	
				if not listaVampiros[nomeVampiro] then
					listaVampiros[nomeVampiro] = true
					local jogadorSerMordido = BloodQueen_RaidList[raidIndex].target or "Loading..."
					local textoCompleto = nomeVampiro .. " : " .. iconeMarcacao .. " : " .. jogadorSerMordido
	
					local textoNome = frameNomes:CreateFontString(nil, "OVERLAY", "GameFontNormal")
					textoNome:SetPoint("TOPLEFT", frameNomes, "TOPLEFT", xOffset, yOffset)
					textoNome:SetText(textoCompleto)
					yOffset = yOffset - 20
	
					table.insert(listaNomes, textoNome)
					vampirosEncontrados = true
	
					columnCounter = columnCounter + 1
					if columnCounter == 5 then
						columnCounter = 0
						yOffset = -10
						xOffset = xOffset + 250
					end
				end
			end
		end
	
		local numColumns = math.ceil(#listaNomes / 5)
		local alturaNecessaria = (math.min(#listaNomes, 5) * 20) + 20
		local larguraNecessaria = numColumns * 250
	
		frameNomes:SetHeight(alturaNecessaria)
		frameNomes:SetWidth(larguraNecessaria)
	
		if vampirosEncontrados then
			frameNomes:Show()
			framePrincipal:Show()
		else
			frameNomes:Hide()
			framePrincipal:Hide()
		end
	end
	
    return frameNomes, AtualizarListaVampiros
end

function ResetTargets()
    for raidIndex = 1, #BloodQueen_RaidList do
        if BloodQueen_RaidList[raidIndex].bite == 2 then
            BloodQueen_RaidList[raidIndex].target = "Loading..."
        end
    end
    AtualizarListaVampiros()
end

-- Função para inicializar o addon e conectar com o evento de atualização
local function InicializarAddon()
    local framePrincipal, textoPrincipal = CriarFramePrincipal()
    local frameNomes, AtualizarListaVampiros = CriarFrameNomesVampiros(framePrincipal)

    local addonFrame = CreateFrame("Frame")
    addonFrame:SetScript("OnUpdate", function(self, elapsed)
        AtualizarListaVampiros()
        CheckBuffsAndHideFrames(framePrincipal, frameNomes)
    end)

    addonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    addonFrame:RegisterEvent("RAID_TARGET_UPDATE")
    addonFrame:RegisterEvent("CHAT_MSG_ADDON")
    addonFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    addonFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" or event == "RAID_TARGET_UPDATE" then
            AtualizarListaVampiros()
            CheckBuffsAndHideFrames(framePrincipal, frameNomes)
        elseif event == "CHAT_MSG_ADDON" then
            local prefix, message, _, sender = ...
            if prefix == "BloodQueenGTA" then
                if message:sub(1, 4) == "BITE" then
                    local _, _, playerName, targetName = message:find("^BITE%s+(%S+)%s+(%S+)")
                    --print("BITE received: playerName=", playerName, ", targetName=", targetName)  -- Debug log
                    if playerName and targetName then
                        for _, playerInfo in ipairs(BloodQueen_RaidList) do
                            if playerInfo.name == playerName then
                                playerInfo.target = targetName
                                break
                            end
                        end
                        AtualizarListaVampiros()
                        CheckBuffsAndHideFrames(framePrincipal, frameNomes)
                    end
                elseif message:sub(1, 13) == "BITE_COMPLETE" then
                    local _, _, playerName, targetName = message:find("^BITE_COMPLETE%s+(%S+)%s+(%S+)")
                    --print("BITE_COMPLETE received: playerName=", playerName, ", targetName=", targetName)  -- Debug log
                    if playerName then
                        for _, playerInfo in ipairs(BloodQueen_RaidList) do
                            if playerInfo.name == playerName then
                                playerInfo.target = "Loading..."
                                break
                            end
                        end
                        AtualizarListaVampiros()
                        CheckBuffsAndHideFrames(framePrincipal, frameNomes)
                    end
                elseif message:sub(1, 13) == "PRIORITY_LIST" then
                    BloodQueen_ReceivePriorityList(message:sub(15))
                    AtualizarListaVampiros()
                    CheckBuffsAndHideFrames(framePrincipal, frameNomes)
                end
            end
        end
    end)

    addonFrame:Show()
end


InicializarAddon()
AtualizarListaVampiros()



-------
--XML--
-------
function BloodQueen_LoadProfile(id)
    local profile = BloodQueen_Profile[id]
    BloodQueen_List = profile.list
    BloodQueen_Config.reportChannel = profile.reportChannel
    BloodQueen_Config.useIconsVamp = profile.useIconsVamp
    BloodQueen_Config.warnTimer = profile.warnTimer
    BloodQueen_Config.useIcons = profile.useIcons
    BloodQueen_Config.useDual = profile.useDual
    BloodQueen_Config.useDualTrade = profile.useDualTrade
    BloodQueen_Config.useRecount = profile.useRecount
    BloodQueen_Config.useSkada = profile.useSkada
    BloodQueen_Config.useDetails = profile.useDetails
    BloodQueen_Config.reportMC = profile.reportMC
    BloodQueen_Config.reportBite = profile.reportBite
    BloodQueen_Config.reportAssign = profile.reportAssign
    BloodQueen_Config.whisperAssign = profile.whisperAssign
end
function BloodQueen_SaveProfile(id)
    local profile = BloodQueen_Profile[id]
    profile.list = BloodQueen_List
    profile.reportChannel = BloodQueen_Config.reportChannel
    profile.useIconsVamp = BloodQueen_Config.useIconsVamp
    profile.warnTimer = BloodQueen_Config.warnTimer
    profile.useIcons = BloodQueen_Config.useIcons
    profile.useDual = BloodQueen_Config.useDual
    profile.useDualTrade = BloodQueen_Config.useDualTrade
    profile.useRecount = BloodQueen_Config.useRecount
    profile.useSkada = BloodQueen_Config.useSkada
    profile.useDetails = BloodQueen_Config.useDetails
    profile.reportMC = BloodQueen_Config.reportMC
    profile.reportBite = BloodQueen_Config.reportBite
    profile.reportAssign = BloodQueen_Config.reportAssign
    profile.whisperAssign = BloodQueen_Config.whisperAssign
end
function BloodQueen_NewProfile(name)
    if name then
        local found
        for _, profile in ipairs(BloodQueen_Profile) do
            if profile.name == name then
                found = true
                break
            end
        end
        if not found then
            table.insert(BloodQueen_Profile, {
                name = name,
                list = {},
                reportChannel = "RAID_WARNING",
                warnTimer = 5,
                useIcons = true,
                useIconsVamp = false,
                useDual = false,
                useDualTrade = true,
                useRecount = false,
                useSkada = false,
                useDetails = false,
                reportMC = true,
                reportBite = true,
                reportAssign = false,
                whisperAssign = true,
            })
            BloodQueen_Profile[0] = #BloodQueen_Profile
            UIDropDownMenu_Initialize(BQ_ProfileBox, B_ProfileBox)
            B_ProfileBox()
            BloodQueen_OnShow()
        end
    end
end
function BloodQueen_DeleteProfile()
    if BloodQueen_Profile[0] ~= 0 and BloodQueen_Profile[0] ~= 1 then
        table.remove(BloodQueen_Profile, BloodQueen_Profile[0])
        BloodQueen_Profile[0] = #BloodQueen_Profile
        UIDropDownMenu_Initialize(BQ_ProfileBox, B_ProfileBox)
        B_ProfileBox()
        BloodQueen_OnShow()
    end
end
function BloodQueen_OnShow()
    BloodQueen_LoadProfile(BloodQueen_Profile[0])
    BQ_ProfileInput:SetText(BloodQueen_Profile[BloodQueen_Profile[0]].name)
    BloodQueenOP_PrioType1:Hide()
    BloodQueenOP_PrioType2:Hide()
    BloodQueenOP_Prio:Hide()
    BQ_EditTitle:Hide()
    BQ_EditTitleType1:Hide()
    BQ_EditTitleType2:Hide()
    BQ_Recount:Hide()
    BQ_Details:Hide()
    BQ_Skada:Hide()
    BQ_PopulateTables()
    BQ_Trade:SetChecked(BloodQueen_Config.useDualTrade)

    if BloodQueen_Config.useDual then
        BloodQueenOP_PrioType1:Show()
        BloodQueenOP_PrioType2:Show()
        BQ_EditTitleType1:Show()
        BQ_EditTitleType2:Show()
        BQ_Trade:Show()
    else
        BQ_EditTitle:Show()
        BloodQueenOP_Prio:Show()
        BQ_Trade:Hide()
    end

    if not Recount then
        BloodQueen_Config.useRecount = false
    else
        BQ_Recount:Show()
    end

    if not Details then
        BloodQueen_Config.useDetails = false
    else
        BQ_Details:Show()
    end

    if not Skada then
        BloodQueen_Config.useSkada = false
    else
        BQ_Skada:Show()
    end

    if (BloodQueen_Config.useRecount or BloodQueen_Config.useSkada or BloodQueen_Config.useDetails) and not BloodQueen_Config.useDual then
        BloodQueenOP_B_Raid:Disable()
        BloodQueenOP_B_Save:Disable()
        BloodQueenOP_B_Guild:Disable()
        BloodQueenOP_B_Revert:Disable()
        BloodQueenOP_B_Test:Disable()

        if BloodQueen_Config.useRecount then
            BloodQueenOP_PrioEdit:SetText(string.format(BloodQueen_Local["PrioListDamageMeter"], "Recount"))
            BQ_Mode:SetText(BloodQueen_Local["Mode Damage Meter"])
        elseif BloodQueen_Config.useSkada then
            BloodQueenOP_PrioEdit:SetText(string.format(BloodQueen_Local["PrioListDamageMeter"], "Skada"))
            BQ_Mode:SetText(BloodQueen_Local["Mode Damage Meter"])
        elseif BloodQueen_Config.useDetails then
            BloodQueenOP_PrioEdit:SetText(string.format(BloodQueen_Local["PrioListDamageMeter"], "Details"))
            BQ_Mode:SetText(BloodQueen_Local["Mode Damage Meter"])
        end
    elseif (BloodQueen_Config.useRecount or BloodQueen_Config.useSkada or BloodQueen_Config.useDetails) and BloodQueen_Config.useDual then
        BloodQueenOP_B_Raid:Enable()
        BloodQueenOP_B_Save:Enable()
        BloodQueenOP_B_Guild:Enable()
        BloodQueenOP_B_Revert:Enable()
        if BloodQueen_Config.useDualTrade then
            BQ_Mode:SetText(BloodQueen_Local["Mode Dual Prio Damage Meter Trade"])
        else
            BQ_Mode:SetText(BloodQueen_Local["Mode Dual Prio Damage Meter"])
        end
    else
        BloodQueenOP_B_Raid:Enable()
        BloodQueenOP_B_Save:Enable()
        BloodQueenOP_B_Guild:Enable()
        BloodQueenOP_B_Revert:Enable()
        BloodQueenOP_B_Test:Enable()
        if BloodQueen_Config.useDual then
            if BloodQueen_Config.useDualTrade then
                BQ_Mode:SetText(BloodQueen_Local["Mode Dual Prio Trade"])
            else
                BQ_Mode:SetText(BloodQueen_Local["Mode Dual Prio"])
            end
        else
            BQ_Mode:SetText(BloodQueen_Local["Mode Normal Prio"])
        end
    end

    BQ_Recount:SetChecked(BloodQueen_Config.useRecount)
    BQ_Details:SetChecked(BloodQueen_Config.useDetails)
    BQ_Skada:SetChecked(BloodQueen_Config.useSkada)
    getglobal("BloodQueenOP_B_SliderTimerHigh"):SetText("40")
    getglobal("BloodQueenOP_B_SliderTimerLow"):SetText("1")
    BloodQueenOP_B_SliderTimer:SetMinMaxValues(1, 40)
    BloodQueenOP_B_SliderTimer:SetValueStep(1)
    
    -- Adicionando verificação e depuração do valor
    if BloodQueen_Config.warnTimer then
        BloodQueenOP_B_SliderTimer:SetValue(BloodQueen_Config.warnTimer)
    else
        print("Erro: BloodQueen_Config.warnTimer não está definido.")
    end

    BQ_Icons:SetChecked(BloodQueen_Config.useIcons)
    BQ_IconsVamp:SetChecked(BloodQueen_Config.useIconsVamp)
    BQ_Dual:SetChecked(BloodQueen_Config.useDual)
    BQ_ReportMC:SetChecked(BloodQueen_Config.reportMC)
    BQ_ReportAssign:SetChecked(BloodQueen_Config.reportAssign)
    BQ_ReportBite:SetChecked(BloodQueen_Config.reportBite)
    BQ_WhispBite:SetChecked(BloodQueen_Config.whisperAssign)
    UIDropDownMenu_Initialize(BQ_ReportBox, B_ReportBox)
    UIDropDownMenu_SetSelectedValue(BQ_ReportBox, BloodQueen_Config.reportChannel)
end

function B_SliderTimer(self)
    BloodQueen_Config.warnTimer = self:GetValue()
    local text = string.format(BloodQueen_Local["Timer Slider"], BloodQueen_Config.warnTimer)
    BloodQueenOP_B_SliderTimerText:SetText(text)
    BloodQueen_SaveProfile(BloodQueen_Profile[0])
end

function B_Revert_OnClick()
    BloodQueen_OnShow()
end
function BQ_PopulateTables()
    local text1 = "\n"
    local text2 = "\n"
    local premier1 = 1
    local premier2 = 1

    for _, listEntry in ipairs(BloodQueen_List) do
        if listEntry[2] == 2 then
            if premier2 == 1 then
                text2 = listEntry[1]
                premier2 = 0
            else
                text2 = text2 .. "\n" .. listEntry[1]
            end
        else
            if premier1 == 1 then
                text1 = listEntry[1]
                premier1 = 0
            else
                text1 = text1 .. "\n" .. listEntry[1]
            end
        end
    end

    BloodQueenOP_PrioEditType1:SetText(text1)
    BloodQueenOP_PrioEditType2:SetText(text2)
    local text = " "
    local premier = 1

    for _, listEntry in ipairs(BloodQueen_List) do
        if premier == 1 then
            text = listEntry[1]
            premier = 0
        else
            text = text .. "\n" .. listEntry[1]
        end
    end

    BloodQueenOP_PrioEdit:SetText(text)
end
function B_ReportBox()
    local info = {}
    info.func = BQ_ReportBoxOnClick

    info.text = BloodQueen_Local["Raid Warning"]
    info.value = "RAID_WARNING"
    UIDropDownMenu_AddButton(info)

    info.text = BloodQueen_Local["Raid Chat"]
    info.value = "RAID"
    UIDropDownMenu_AddButton(info)

    info.text = BloodQueen_Local["Officer Chat"]
    info.value = "OFFICER"
    UIDropDownMenu_AddButton(info)

    if IsAddOnLoaded("Details") then
        info.text = "Details"
        info.value = "DETAILS"
        UIDropDownMenu_AddButton(info)
    end

    UIDropDownMenu_SetSelectedValue(BQ_ReportBox, BloodQueen_Config.reportChannel)
end

function B_ReportBoxInit(self)
	UIDropDownMenu_Initialize(self, B_ReportBox);
end
function BQ_ReportBoxOnClick(self)
    UIDropDownMenu_SetSelectedValue(BQ_ReportBox, self.value)
    BloodQueen_Config.reportChannel = self.value
    BloodQueen_SaveProfile(BloodQueen_Profile[0])
end
function B_ProfileBox()
    for i, profile in ipairs(BloodQueen_Profile) do
        local info = {}
        info.func = BQ_ProfileBoxOnClick
        info.text = profile.name
        info.value = i
        UIDropDownMenu_AddButton(info)
    end
    UIDropDownMenu_SetSelectedValue(BQ_ProfileBox, BloodQueen_Profile[0])
end

function B_ProfileBoxInit(self)
	UIDropDownMenu_Initialize(self, B_ProfileBox);
end
function BQ_ProfileBoxOnClick(self)
    UIDropDownMenu_SetSelectedValue(BQ_ProfileBox, self.value)
    BloodQueen_Profile[0] = self.value
    BloodQueen_OnShow()
end

function BQ_DualToggle()
    BloodQueen_Config.useDual = not BloodQueen_Config.useDual
    if not BloodQueen_Config.useRecount and not BloodQueen_Config.useSkada and not BloodQueen_Config.useDetails then
        B_Save_OnClick(1)
    end
    BloodQueen_SaveProfile(BloodQueen_Profile[0])
    BloodQueen_OnShow()
end
function BQ_RecountPrio()
    BloodQueen_Config.useRecount = not BloodQueen_Config.useRecount
    if BloodQueen_Config.useRecount then
        BloodQueen_Config.useSkada = false
        BloodQueen_Config.useDetails = false
    end
    BloodQueen_SaveProfile(BloodQueen_Profile[0])
    BloodQueen_OnShow()
end
function BQ_SkadaPrio()
    BloodQueen_Config.useSkada = not BloodQueen_Config.useSkada
    if BloodQueen_Config.useSkada then
        BloodQueen_Config.useRecount = false
        BloodQueen_Config.useDetails = false
    end
    BloodQueen_SaveProfile(BloodQueen_Profile[0])
    BloodQueen_OnShow()
end
function BQ_DetailsPrio()
    BloodQueen_Config.useDetails = not BloodQueen_Config.useDetails
    if BloodQueen_Config.useDetails then
        BloodQueen_Config.useRecount = false
        BloodQueen_Config.useSkada = false
    end
    BloodQueen_SaveProfile(BloodQueen_Profile[0])
    BloodQueen_OnShow()
end
function BQ_DualTrade()
    BloodQueen_Config.useDualTrade = not BloodQueen_Config.useDualTrade
    BloodQueen_SaveProfile(BloodQueen_Profile[0])
    BloodQueen_OnShow()
end
function BQ_ReportMCToggle()
    BloodQueen_Config.reportMC = not BloodQueen_Config.reportMC
    BloodQueen_SaveProfile(BloodQueen_Profile[0])
    BloodQueen_OnShow()
end
function BQ_ReportAssignToggle()
    BloodQueen_Config.reportAssign = not BloodQueen_Config.reportAssign
    if not BloodQueen_Config.reportAssign then
        BloodQueen_Config.whisperAssign = true
    end
    BloodQueen_SaveProfile(BloodQueen_Profile[0])
    BQ_ReportAssign:SetChecked(BloodQueen_Config.reportAssign)
    BQ_WhispBite:SetChecked(BloodQueen_Config.whisperAssign)
end
function BQ_WhispBiteToggle()
    BloodQueen_Config.whisperAssign = not BloodQueen_Config.whisperAssign
    if not BloodQueen_Config.whisperAssign then
        BloodQueen_Config.reportAssign = true
    end
    BQ_WhispBite:SetChecked(BloodQueen_Config.whisperAssign)
    BQ_ReportAssign:SetChecked(BloodQueen_Config.reportAssign)
end
function BQ_ReportBiteToggle()
    BloodQueen_Config.reportBite = not BloodQueen_Config.reportBite
    BloodQueen_SaveProfile(BloodQueen_Profile[0])
    BQ_ReportBite:SetChecked(BloodQueen_Config.reportBite)
end
function B_Guild_OnClick()
    local text = ""
    local premier = 1
    local offline = GetGuildRosterShowOffline()
    local selection = GetGuildRosterSelection()
    SetGuildRosterShowOffline(1)
    SetGuildRosterSelection(0)
    GetGuildRosterInfo(0)

    for i = 1, GetNumGuildMembers() do
        local name = GetGuildRosterInfo(i)
        if premier == 1 then
            text = name
            premier = 0
        else
            text = text .. "\n" .. name
        end
    end

    SetGuildRosterShowOffline(offline)
    SetGuildRosterSelection(selection)

    if text ~= "" then
        if BloodQueen_Config.useDual then
            BloodQueenOP_PrioEditType1:SetText(text)
        else
            BloodQueenOP_PrioEdit:SetText(text)
        end
    end
end
function B_Raid_OnClick()
    if BloodQueen_Config.useDual then
        local text1 = ""
        local text2 = ""
        local premier1 = 1
        local premier2 = 1

        for i = 1, GetNumRaidMembers() do
            local name, _, group, _, _, class = GetRaidRosterInfo(i)
            if class == "WARRIOR" or class == "ROGUE" or class == "DEATHKNIGHT" then
                if premier1 == 1 then
                    text1 = name
                    premier1 = 0
                else
                    text1 = text1 .. "\n" .. name
                end
            elseif (class == "PALADIN" or class == "SHAMAN" or class == "DRUID") and UnitManaMax("raid" .. i) < 16000 and UnitManaMax("raid" .. i) > 1 then
                if premier1 == 1 then
                    text1 = name
                    premier1 = 0
                else
                    text1 = text1 .. "\n" .. name
                end
            else
                if premier2 == 1 then
                    text2 = name
                    premier2 = 0
                else
                    text2 = text2 .. "\n" .. name
                end
            end
        end

        if text1 ~= "" then
            BloodQueenOP_PrioEditType1:SetText(text1)
        end

        if text2 ~= "" then
            BloodQueenOP_PrioEditType2:SetText(text2)
        end
    else
        local text = ""
        local premier = 1

        for i = 1, GetNumRaidMembers() do
            local name, _, group, _, _, class = GetRaidRosterInfo(i)
            if premier == 1 then
                text = name
                premier = 0
            else
                text = text .. "\n" .. name
            end
        end

        if text ~= "" then
            BloodQueenOP_PrioEdit:SetText(text)
        end
    end
end
function B_Save_OnClick(self)
    if not IsRaidLeader() then
        print("Apenas o Raid Leader pode salvar a lista de prioridades.")
        return
    end

    BloodQueen_List = {}
    if BloodQueen_Config.useDual then
        local i = 1
        local text = BloodQueenOP_PrioEditType1:GetText()

        if text ~= "" then
            for line in text:gmatch("[^\r\n]+") do
                BloodQueen_List[i] = {line, 1}
                i = i + 1
            end
        end

        text = BloodQueenOP_PrioEditType2:GetText()

        if text ~= "" then
            for line in text:gmatch("[^\r\n]+") do
                BloodQueen_List[i] = {line, 2}
                i = i + 1
            end
        end
    else
        local i = 1
        local text = BloodQueenOP_PrioEdit:GetText()

        if text ~= "" then
            for line in text:gmatch("[^\r\n]+") do
                BloodQueen_List[i] = {line, 0}
                i = i + 1
            end
        end
    end

    BloodQueen_SaveProfile(BloodQueen_Profile[0])

    if not self then
        BloodQueen_Reset()
    end
end


function B_Edit_OnClick()
    local text = ""
    local premier = 1
    local offline = GetGuildRosterShowOffline()
    local selection = GetGuildRosterSelection()
    SetGuildRosterShowOffline(1)
    SetGuildRosterSelection(0)
    GetGuildRosterInfo(0)

    for i = 1, GetNumGuildMembers() do
        local name = GetGuildRosterInfo(i)
        if premier == 1 then
            text = name
            premier = 0
        else
            text = text .. "\n" .. name
        end
    end

    SetGuildRosterShowOffline(offline)
    SetGuildRosterSelection(selection)

    if text ~= "" then
        BQ_EditBox:SetText(text)
        BQ_EditFrame:Show()
    end
end

function B_EditSubmit()
    local text = BQ_EditBox:GetText()

    if text ~= "" then
        if BloodQueen_Config.useDual then
            BloodQueenOP_PrioEditType1:SetText(text)
        else
            BloodQueenOP_PrioEdit:SetText(text)
        end
    end

    BQ_EditFrame:Hide()
end

function B_EditClose()
    BQ_EditFrame:Hide()
end

function BloodQueen_ListFix(self)
	i=1;
	while(i<=table.getn(BloodQueen_List)) do
		if (BloodQueen_List[i][1] == "") then
			tremove(BloodQueen_List,i);
		else
			i=i+1;
		end
	end
end
function BQ_IconsToggle()
    BloodQueen_Config.useIcons = not BloodQueen_Config.useIcons
    BloodQueen_SaveProfile(BloodQueen_Profile[0])
end
function BQ_IconsVampToggle()
    BloodQueen_Config.useIconsVamp = not BloodQueen_Config.useIconsVamp
    BloodQueen_SaveProfile(BloodQueen_Profile[0])
end
function BloodQueen_split (self,delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( self, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( self, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( self, delimiter, from  )
	end
	table.insert( result, string.sub( self, from  ) )
	return result
end
function BloodQueen_GetWords(str,nr)
	local ret = {};
	local pos=0;
	while(true) do
		local word;
		_,pos,word=string.find(str, "^ *([^%s]+) *", pos+1);
		if(not word) then
			if (nr) then
				return ret[nr];
			else
				return ret;
			end
		end
		table.insert(ret, word);
	end
end
function BloodQueen_Cmd(self)
    if not InCombatLockdown() then
        local playerName = UnitName("player")
        BloodQueenOP:Show();
    end
end

function BQ_Panel(self)
	local panel = CreateFrame("Frame")
	panel.name = "BloodQueen";

	local button = CreateFrame('Button', nil, panel, 'UIPanelButtonTemplate')
	button:SetText("Configure BloodQueen")
	button:SetWidth(155)
	button:SetHeight(25)	
	button:SetPoint("TOPLEFT", 15, -15)
	button:SetScript("OnClick",function() 	
		InterfaceOptionsFrame.lastFrame = nil;
		HideUIPanel(InterfaceOptionsFrame);
		BloodQueen_Cmd();
		end)
	InterfaceOptions_AddCategory(panel)
	--Localization
	BQ_Title:SetText(BloodQueen_Local["BloodQueen"].." Bite Manager "..BloodQueen_Version);
	BQ_TitleMode:SetText(BloodQueen_Local["Mode selection:"]);
	BQ_EditTitle:SetText(BloodQueen_Local["Priority List:"]);
	BQ_EditTitleType1:SetText(BloodQueen_Local["Melee List:"]);
	BQ_EditTitleType2:SetText(BloodQueen_Local["Ranged List:"]);
	BloodQueenOP_B_RaidText:SetText(BloodQueen_Local["Retrieve List from Raid"]);
	BloodQueenOP_B_Revert:SetText(BloodQueen_Local["Revert to last save"]);
	BloodQueenOP_B_Test:SetText(BloodQueen_Local["Save List current raid prio"]);
	BloodQueenOP_B_Save:SetText(BloodQueen_Local["Save new Priority"]);
	BloodQueenOP_B_Guild:SetText(BloodQueen_Local["Retrieve List from Guild"]);
	
	BQ_ReportBoxT:SetTextColor(1,1,1);
	BQ_ReportBoxT:SetText(BloodQueen_Local["Report to"]);
	
	BQ_ProfileBoxT:SetTextColor(1,1,1);
	BQ_ProfileBoxT:SetText(BloodQueen_Local["Profile"]);
	BQ_ProfileBoxNew:SetText(BloodQueen_Local["New"]);
	
	
	BQ_IconsText:SetTextColor(1,1,1);
	BQ_IconsText:SetText(BloodQueen_Local["Set Raid Icons"]);
	BQ_IconsVampText:SetTextColor(1,1,1);
	BQ_IconsVampText:SetText(BloodQueen_Local["Vampire"]);
	BQ_WhispBiteText:SetTextColor(1,1,1);
	BQ_WhispBiteText:SetText(BloodQueen_Local["Whisper Assigns"]);
	BQ_ReportBiteText:SetTextColor(1,1,1);
	BQ_ReportBiteText:SetText(BloodQueen_Local["Report Vampires"]);
	BQ_ReportAssignText:SetTextColor(1,1,1);
	BQ_ReportAssignText:SetText(BloodQueen_Local["Report Assigns"]);
	BQ_ReportMCText:SetTextColor(1,1,1);
	BQ_ReportMCText:SetText(BloodQueen_Local["Report MCs"]);
	BQ_DualText:SetTextColor(1,1,1);
	BQ_DualText:SetText(BloodQueen_Local["Dual Prio"]);
	BQ_TradeText:SetTextColor(1,1,1);
	BQ_TradeText:SetText(BloodQueen_Local["Reverse first Bite"]);
	BQ_RecountText:SetTextColor(1,1,1);
	BQ_RecountText:SetText(BloodQueen_Local["Recount Prio"]);
	BQ_SkadaText:SetTextColor(1,1,1);
	BQ_SkadaText:SetText(BloodQueen_Local["Skada Prio"]);
	BQ_DetailsText:SetTextColor(1,1,1);
	BQ_DetailsText:SetText(BloodQueen_Local["Details Prio"]);
	BQ_Author:SetText( "Beeka\nVersion 1.0.8" ) ;
	BQ_Author:SetTextColor( 0,1,0 ) ;
end

function BloodQueen_OnEvent(self, event, ...)
    if event == "RAID_ROSTER_UPDATE" and BloodQueen_Run[1] then
        for x = 1, BloodQueen_Size() do
            local raidEntry = BloodQueen_RaidList[x]
            if UnitName("raid" .. raidEntry.raidid) == raidEntry.name or raidEntry.name == "" then
                -- Mantém
            else
                local found
                for y = 1, GetNumRaidMembers() do
                    local name = GetRaidRosterInfo(y)
                    if name == raidEntry.name then
                        raidEntry.raidid = y
                        found = true
                    end
                end
                if not found then
                    BloodQueen_RaidList[x] = createEmptyRaidEntry()
                end
            end
        end
    elseif event == "CHAT_MSG_ADDON" and ... == "BloodQueenGTA" then
        local prefix, message = strsplit(" ", select(2, ...), 2)
        if prefix == "PRIORITY_LIST" then
            BloodQueen_ReceivePriorityList(message)
        end
    end
end


local BloodQueen_ScriptFrame = CreateFrame("Frame")
BloodQueen_ScriptFrame:SetScript("OnUpdate", BloodQueen_OnUpdate)
BloodQueen_ScriptFrame:SetScript("OnEvent", BloodQueen_OnEvent)
BloodQueen_ScriptFrame:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
BloodQueen_ScriptFrame:RegisterEvent("RAID_ROSTER_UPDATE")
BloodQueen_ScriptFrame:RegisterEvent("CHAT_MSG_ADDON")
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", BloodQueenFilterWhisper)
SlashCmdList["BLOODQUEEN"] = BloodQueen_Cmd
SLASH_BLOODQUEEN1 = "/bq"
SLASH_BLOODQUEEN2 = "/bloodqueen"
DEFAULT_CHAT_FRAME:AddMessage("BloodQueen Addon Loaded v" .. BloodQueen_Version, 1, 1, 0)


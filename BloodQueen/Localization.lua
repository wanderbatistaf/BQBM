if (GetLocale() == "zhTW") then --thanks 1sa
	BloodQueen_Local = {
		--console
		["Load"] = "BloodQueen %s  已被載入";
		["firstbite"] = "第一咬已被檢測到, 設置模式為 %d 人。祝您好運！";
		["man detected"] = "%d 人被檢測到";
		["Priority Setup for this raid:"] = "本次團隊的優先列表設置：";
		["Melee:"] = "近戰：";
		["Ranged:"] = "遠程：";
		["Undifferentiated:"] = "未指定：";
		["New priority list saved"] = "新的優先列表已儲存";
		["Raid Roster changed, updating."] = "團隊成員變更，正在更新列表。";
		--whisper
		[">>BITE"] = ">>請咬 %s%s  - 小組 %d (%d 秒)<<";
		[">>is going to bite you"] = ">>%s%s 將在 %d 秒後咬你,請注意!";
		[">>Target Dead/Offline! BITE"] = ">>被分配的目標已死亡/離綫! 請轉換目標為 %s%s - 小組 %d (%d  秒)<<";
		[">>Target Dead/Offline! BITE ANYONE FAST<<"] = " >>被分配的目標已死亡/離綫! 立即咬你周圍的任何人！<<";
		[">>THERE'S NO ONE LEFT TO BITE GG<<"] = ">>沒有可咬的人了！RE重來 <<";
		--report
		["Report Bite"] = "%s%s  咬了 %s%s";
		["Report Vampire"] = "精華 #%d %s";
		["Vampire"] = "精華";
		["Report MC"] = "%s >> 由於沒有咬人，被控制了";
		["target died/disconnected!"] = " %的分配目標已死亡/斷線";
		--xml
		["Timer Slider"] = "設置目標在精華消失前 %d 秒，\n提醒其儘快咬人";
		["BloodQueen"] = "BloodQueen";
		["Mode selection:"] = "模式設置：";
		["Priority List:"] = "優先列表：";
		["Melee List:"] = "近戰列表：";
		["Ranged List:"] = "遠程列表：";
		["Retrieve List from Raid"] = "從團隊中讀取列表";
		["Revert to last save"] = "返回上一次保存的列表";
		["Save List current raid prio"] = "保存並發佈本次團隊的優先列表";
		["Save new Priority"] = "保存新的優先列表";
		["Retrieve List from Guild"] = "從公會中讀取列表";
		["Report to"] = "報告至";
		["Set Raid Icons"] = "設置團隊標記";
		["Whisper Assigns"] = "開啟密語";
		["Report Assigns"] = "開啟報告";
		["Report Vampires"] = "報告精華";
		["Report MCs"] = "報告被控制";
		["Dual Prio"] = "雙優先";
		["Reverse first Bite"] = "反咬模式";
		["Recount Prio"] = "Recount數據優先";
		["Skada Prio"] = "Skada數據優先";
		["Raid Warning"] = "團隊報警";
		["Raid Chat"] = "團隊頻道";
		["Officer Chat"] = "官員頻道";
		["Default"] = "默認設置";
		["New"] = "新的";
		["Profile"] = "個人檔案";
		--modes
		["Mode Dual Prio Damage Meter Trade"] = "在這個模式中， 所有分配的被咬目 標講取決於他們的 D.P.S. (近戰咬近戰, 遠程咬遠程, 但是第一咬將反過來)";
		["Mode Dual Prio Damage Meter"] = "在這個模式中， 所有分配的被咬目 標講取決於他們的 D.P.S. (近戰咬近戰, 遠程咬遠程)";
		["Mode Dual Prio Trade"] = "在這個模式中， 所有分配的被咬目 標講取決於設置的優先列表 (近戰咬近戰, 遠程咬遠程, 但是第一咬將反過來)";
		["Mode Dual Prio"] = "在這個模式中， 所有分配的被咬目 標講取決於設置的優先列表 (近戰咬近戰,遠程咬遠程)";
		["Mode Normal Prio"] = "在這個模式中， 所有分配的被咬目 標講取決於設置的 優先列表";
		["Mode Damage Meter"] = "在這個模式中， 所有分配的被咬目 標講取決於他們的 D.P.S. ";
		["PrioListDamageMeter"] = "取決於 %s 數據的優先列表";
	}
elseif (GetLocale() == "zhCN") then --thanks 1sa
	BloodQueen_Local={
		--console
		["Load"] = "BloodQueen %s 已被载入";
		["firstbite"] = "第一咬已被探测到, 模式设置为%d人。祝您好运！";
		["man detected"] = "%d人已被探测到";
		["Priority Setup for this raid:"] = "为本次团队设置优先列表：";
		["Melee:"] = "近战：";
		["Ranged:"] = "远程:";
		["Undifferentiated:"] = "未指定:";
		["New priority list saved"] = "新的优先列表已被保存";
		["Raid Roster changed, updating."] = "团队成员变更，正在更新中。";
		--whisper
		[">>BITE"] = ">>咬 %s%s - 小队 %d (%d  秒)<<";
		[">>is going to bite you"] = ">>%s%s 将在 %d 秒后咬你!";
		[">>Target Dead/Offline! BITE"] = ">>原分配目标已死亡/离线! 咬 %s%s - 小队 %d (%d  秒)<<";
		[">>Target Dead/Offline! BITE ANYONE FAST<<"] = ">>原分配目标已死亡/离线，请尽快咬身边的任何人！<<";
		[">>THERE'S NO ONE LEFT TO BITE GG<<"] = ">>没有人可以咬了，放弃重来<<";
		--report
		["Report Bite"] = "%s%s 咬了 %s%s";
		["Report Vampire"] = "精华 #%d %s";
		["Vampire"] = "精华";
		["Report MC"] = " %s >> 咬人失败，已被控制";
		["target died/disconnected!"] = "%s的目标死亡/离线了！";
		--xml
		["Timer Slider"] = "设置目标的精华消失 %d秒前\n尽快咬人";
		["BloodQueen"] = "BloodQueen";
		["Mode selection:"] = "模式选择：";
		["Priority List:"] = "优先列表：";
		["Melee List:"] = "近战列表：";
		["Ranged List:"] = "远程列表:";
		["Retrieve List from Raid"] = "从团队中读取列表";
		["Revert to last save"] = "返回上次保存结果";
		["Save List current raid prio"] = "保存并列出目前团队的优先列表";
		["Save new Priority"] = "保存新的优先列表";
		["Retrieve List from Guild"] = "从公会中读取列表";
		["Report to"] = "报告至";
		["Set Raid Icons"] = "设置团队标记";
		["Whisper Assigns"] = "允许密语";
		["Report Assigns"] = "允许报告";
		["Report Vampires"] = "报告精华";
		["Report MCs"] = "报告被控制";
		["Dual Prio"] = "双优先";
		["Reverse first Bite"] = "反咬模式";
		["Recount Prio"] = "Recount数据优先";
		["Skada Prio"] = "Skada数据优先";
		["Raid Warning"] = "团队警告";
		["Raid Chat"] = "团队频道";
		["Officer Chat"] = "官员频道";
		["Default"] = "默认设置";
		["New"] = "新的";
		["Profile"] = "个人设置";
		--modes
		["Mode Dual Prio Damage Meter Trade"] = "在这个模式中， 所有的被咬目 标讲根据DPS来决定 (近战咬近战， 远程咬远程, 但是第一咬会反过来)";
		["Mode Dual Prio Damage Meter"] = "在这个模式中， 所有的被咬目 标讲根据DPS来决定 (近战咬近战, 远程咬远程)";
		["Mode Dual Prio Trade"] = "在这个模式中， 所有的目标根 据事先设定的 优先列表来选择 (近战咬近战, 远程咬远程, 但是第一咬会反过来)";
		["Mode Dual Prio"] = "在这个模式中， 所有的目标根据事先 设定的优先列表来选择 (近战咬近战, 远程咬远程)";
		["Mode Normal Prio"] = "在这个模式中， 所有的目标根据事 先设定的优先 列表来选择";
		["Mode Damage Meter"] = "在这个模式中， 所有的被咬目标 讲根据DPS来决定";
		["PrioListDamageMeter"] = "%s 数据决定优先列表";
	}
elseif (GetLocale() == "deDE") then --thanks Rerox and Andy84
	BloodQueen_Local={
		--console
		["Load"] = "BloodQueen %s geladen";
		["firstbite"] = "Erster Biss erkannt, Einstellungen für %d-Spieler-Schlachtzug aktiviert. Viel Erfolg!";
		["man detected"] = "%d Spieler erkannt";
		["Priority Setup for this raid:"] = "Prioritäteneinstellungen für diesen Schlachtzug:";
		["Melee:"] = "Nahkämpfer:";
		["Ranged:"] = "Fernkämpfer:";
		["Undifferentiated:"] = "Undifferenziert:";
		["New priority list saved"] = "Neue Priotitätenliste gespeichert";
		["Raid Roster changed, updating."] = "Schlachtzug-Zusammenstellung geändert, aktualisiere.";
		--whisper
		[">>BITE"] = " >>Beiße %s%s - Gruppe %d (%d Sekunden)<<";
		[">>is going to bite you"] = ">>%s%s beißt dich in %d Sekunden!";
		[">>Target Dead/Offline! BITE"] = ">>Zielt ist tot/offline! Beiße %s%s - Gruppe %d (%d Sekunden)<<";
		[">>Target Dead/Offline! BITE ANYONE FAST<<"] = ">>Ziel ist tot/offline! Beiße irgendwen, schnell<<";
		[">>THERE'S NO ONE LEFT TO BITE GG<<"] = ">>KEINER MEHR ZUM BEIßEN ÜBRIG<<";
		--report
		["Report Bite"] = "%s%s beiße %s%s";
		["Report Vampire"] = "Vampir #%d %s";
		["Vampire"] = "Vampir";
		["Report MC"] = "%s >> Gedankenkontrolle";
		["target died/disconnected!"] = "%s's Ziel gestorben/disconnected!";
		--xml
		["Timer Slider"] = "Ziel %d Sekunden vor Ablauf\n des Schadens-Buffs zuweisen";
		["BloodQueen"] = "BloodQueen";
		["Mode selection:"] = "Modus-Auswahl:";
		["Priority List:"] = "Prioritätenliste:";
		["Melee List:"] = "Nahkämpferliste:";
		["Ranged List:"] = "Fernkämpferliste:";
		["Retrieve List from Raid"] = "Empfange Liste von Schlachtzug";
		["Revert to last save"] = "Zurück zur letzten gespeicherten version";
		["Save List current raid prio"] = "Aktuelle Schlachtzug-Prioritäten auflisten";
		["Save new Priority"] = "Speichere neue Priotitäten";
		["Retrieve List from Guild"] = "Empfange Liste von Gilde";
		["Report to"] = "Berichte zu";
		["Set Raid Icons"] = "Setzte Raidzeichen";
		["Whisper Assigns"] = "Flüstere Zuweisungen";
		["Report Assigns"] = "Berichte Zuweisungen";
		["Report Vampires"] = "Berichte Vampire";
		["Report MCs"] = "Berichte Gedankenkontrolle";
		["Dual Prio"] = "Doppelte Prioritäten";
		["Reverse first Bite"] = "Gegenläufiger erster Biss";
		["Recount Prio"] = "Recount Prioritäten";
		["Skada Prio"] = "Skada Prioritäten";
		["Raid Warning"] = "Schlachtzugwarnung";
		["Raid Chat"] = "Schlachtzug-Chat";
		["Officer Chat"] = "Offiziers-Chat";
		["Default"] = "Vorgabe";
		["New"] = "Neu";
		["Profile"] = "Profil";
		--modes
		["Mode Dual Prio Damage Meter Trade"] = "In diesem Modus Werden alle Ziele nach ihrer Position im Damagemeter bestimmt. Dabei wird jeweils ihre separate Liste berücksichtigt (Nahkämpfer beißt Nahkämpfer, Fernkämpfer beißt Fernkämpfer, aber der erste Biss ist gegenläufig)";
		["Mode Dual Prio Damage Meter"] = "In diesem Modus werden alle Ziele nach ihrer Position im Damagemeter bestimmt. Dabei wird jeweils ihre separate Liste berücksichtigt (Nahkämpfer beißt Nahkämpfer, Fernkämpfer beißt Fernkämpfer)";
		["Mode Dual Prio Trade"] = "In diesem Modus werden alle Ziele nach ihrer Prioritätenliste bestimmt (Nahkämpfer beißt Nahkämpfer, Fernkämpfer beißt Fernkämpfer, aber der erste Biss ist gegenläufig)";
		["Mode Dual Prio"] = "In diesem Modus werden alle Ziele nach ihrer Prioritätenliste bestimmt (Nahkämpfer beißt Nahkämpfer, Fernkämpfer beißt Fernkämpfer)";
		["Mode Normal Prio"] = "In diesem Modus werden alle Ziele nach ihrer Prioritätenliste bestimmt";
		["Mode Damage Meter"] = "In diesem Modus werden alle Ziele nach ihrer Position im Damagemeter bestimmt";
		["PrioListDamageMeter"] = "%s Damage Meter basierte Prioritätenliste";
	};
elseif (GetLocale() == "ruRU") then --thanks Kadrkadr and mobvideo 
	BloodQueen_Local={
		--console
		["Load"] = "BloodQueen %s загружен";
		["firstbite"] = "Первый укус обнаружен, включен режим для %d игроков. Удачи!";
		["man detected"] = "Обнаружен режим на %d игроков";
		["Priority Setup for this raid:"] = "Установка приоритетов для этого рейда:";
		["Melee:"] = "Ближний бой:";
		["Ranged:"] = "Дальний бой:";
		["Undifferentiated:"] = "Неопределенное:";
		["New priority list saved"] = "Новый список приоритетов сохранен";
		["Raid Roster changed, updating."] = "Реестр рейда изменился, обновление.";
		--whisper
		[">>BITE"] = ">>УКУСИ %s%s - Группа %d (%d сек.)<<";
		[">>is going to bite you"] = ">>%s%s укусит вас через %d секунд!";
		[">>Target Dead/Offline! BITE"] = ">>Цель мертва/оффлайн! УКУСИ %s%s - Группа %d (%d секунд.)<<";
		[">>Target Dead/Offline! BITE ANYONE FAST<<"] = ">>Цель мертва/оффлайн! БЫСТРО УКУСИ КОГО-НИБУДЬ<<";
		[">>THERE'S NO ONE LEFT TO BITE GG<<"] = ">>БОЛЬШЕ НЕ КОГО УКУСИТЬ ППЦ<<";
		--report
		["Report Bite"] = "%s%s УКУС %s%s";
		["Report Vampire"] = "Вампир #%d %s";
		["Vampire"] = "Вампир";
		["Report MC"] = "%s >> Под контролем";
		["target died/disconnected!"] = "Цель игрока %s умерла/отключена!";
		--xml
		["Timer Slider"] = "Назначить цель за %d секунд\n до окончания бафа";
		["BloodQueen"] = "BloodQueen";
		["Mode selection:"] = "Выбор режима:";
		["Priority List:"] = "Список приоритетов:";
		["Melee List:"] = "Бойцы ближнего боя:";
		["Ranged List:"] = "Бойцы дальнего боя:";
		["Retrieve List from Raid"] = "Получить список из рейда";
		["Revert to last save"] = "Вернуться к последнему сохранению";
		["Save List current raid prio"] = "Сохранить и показать текущий приоритет рейда";
		["Save new Priority"] = "Сохранить новый приоритет";
		["Retrieve List from Guild"] = "Получить список из Гильдии";
		["Report to"] = "Отчет в";
		["Set Raid Icons"] = "Назначение иконок рейда";
		["Whisper Assigns"] = "Шепнуть назначения";
		["Report Assigns"] = "Отчет по назначениям";
		["Report Vampires"] = "Отчет по вампирам";
		["Report MCs"] = "Отчет по попавшим под контроль";
		["Dual Prio"] = "Двойной приоритет";
		["Reverse first Bite"] = "Поменять первый укус";
		["Recount Prio"] = "Приоритет по Recount";
		["Skada Prio"] = "Приоритет по Skada";
		["Raid Warning"] = "Предупреждения рейду";
		["Raid Chat"] = "Рейд чат";
		["Officer Chat"] = "Офицерский чат";
		["Default"] = "По умолчанию";
		["New"] = "Новый";
		["Profile"] = "Профиль";
		--modes
		["Mode Dual Prio Damage Meter Trade"] = "В этом режиме все цели выбраны в соответствии с нанесенным уроном, учитывая индивидуальные списки (игроки ближнего боя кусают игроков ближнего боя, игроки дальнего боя кусают игроков дальнего боя, но самый первый должен быть укушен игрок противоположный)";
		["Mode Dual Prio Damage Meter"] = "В этом режиме все цели выбраны в соответствии с наносимым уроном, учитывая индивидуальные списки (игроки ближнего боя кусают игроков ближнего боя, аналогично для игроков дальнего боя)";
		["Mode Dual Prio Trade"] = "В этом режиме все цели выбраны в соответствии списку приоритетов (игроки ближнего боя кусают игроков ближнего боя, аналогично для игроков дальнего боя, но сначала кусают себе противоположных)";
		["Mode Dual Prio"] = "В этом режиме все цели выбраны в соответствии списку приоритетов (игроки ближнего боя кусают игроков ближнего боя, аналогично для игроков дальнего боя)";
		["Mode Normal Prio"] = "В этом режиме все цели выбраны в соответствии списку приоритетов";
		["Mode Damage Meter"] = "В этом режиме все цели выбраны в соответствии наносимому урону";
		["PrioListDamageMeter"] = "Список приоритетов в\nсоответствии с %s";
	};
else
	BloodQueen_Local={
		--console
		["Load"] = "BloodQueen %s loaded";
		["firstbite"] = "First bite detected, modo habilitado para %dman. Boa sorte!";
		["man detected"] = "%dman detected";
		["Priority Setup for this raid:"] = "Priority Setup for this raid:";
		["Melee:"] = "Melee:";
		["Ranged:"] = "Ranged:";
		["Undifferentiated:"] = "Undifferentiated:";
		["New priority list saved"] = "New priority list saved";
		["Raid Roster changed, updating."] = "Raid Roster changed, updating.";
		--whisper
		[">>BITE"] = ">>BITE %s%s - Group %d (%d seconds)<<";
		[">>is going to bite you"] = ">>%s%s is going to bite you in %d seconds!";
		[">>Target Dead/Offline! BITE"] = ">>Target Dead/Offline! BITE %s%s - Group %d (%d seconds)<<";
		[">>Target Dead/Offline! BITE ANYONE FAST<<"] = ">>Target Dead/Offline! BITE ANYONE FAST<<";
		[">>THERE'S NO ONE LEFT TO BITE GG<<"] = ">>THERE'S NO ONE LEFT TO BITE GG<<";
		--report
		["Report Bite"] = "%s%s BITE %s%s";
		["Report Vampire"] = "Vampire #%d %s";
		["Vampire"] = "Vampire";
		["Report MC"] = "%s >> MindControl";
		["target died/disconnected!"] = "%s's target died/disconnected!";
		--xml
		["Timer Slider"] = "Atribua o alvo em %d segundos\n antes que o buff expire";
		["BloodQueen"] = "BloodQueen";
		["Mode selection:"] = "Mode selection:";
		["Priority List:"] = "Priority List:";
		["Melee List:"] = "Melee List:";
		["Ranged List:"] = "Ranged List:";
		["Retrieve List from Raid"] = "Retrieve List from Raid";
		["Revert to last save"] = "Revert to last save";
		["Save List current raid prio"] = "Save and List current raid prio";
		["Save new Priority"] = "Save new Priority";
		["Retrieve List from Guild"] = "Retrieve List from Guild";
		["Report to"] = "Report to";
		["Set Raid Icons"] = "Set Raid Icons";
		["Whisper Assigns"] = "Whisper Assigns";
		["Report Assigns"] = "Report Assigns";
		["Report Vampires"] = "Report Vampires";
		["Report MCs"] = "Report MCs";
		["Dual Prio"] = "Dual Prio";
		["Reverse first Bite"] = "Reverse first Bite";
		["Recount Prio"] = "Recount Prio";
		["Skada Prio"] = "Skada Prio";
		["Details Prio"] = "Details Prio";
		["Raid Warning"] = "Raid Warning";
		["Raid Chat"] = "Raid Chat";
		["Officer Chat"] = "Officer Chat";
		["Default"] = "Default";
		["New"] = "New";
		["Profile"] = "Profile";
		--modes
		["Mode Dual Prio Damage Meter Trade"] = "Neste modo todos os alvos são escolhidos de acordo com o medidor de dano, respeitando cada lista individual (melee morde melee, ranged morde ranged, mas a primeira bite é oposto)";
		["Mode Dual Prio Damage Meter"] = "Neste modo todos os alvos são escolhidos de acordo com o medidor de dano, respeitando cada lista individual (melee morde melee, ranged morde ranged)";
		["Mode Dual Prio Trade"] = "Neste modo todos os alvos são escolhidos de acordo com listas de prioridade (melee morde melee, ranged morde ranged, mas primeiro morde é oposto)";
		["Mode Dual Prio"] = "Neste modo todos os alvos são escolhidos de acordo com listas de prioridade (melee morde melee, ranged morde ranged)";
		["Mode Normal Prio"] = "Neste modo todos os alvos são escolhidos de acordo com lista de prioridade";
		["Mode Damage Meter"] = "Neste modo todos os alvos são escolhidos de acordo com medidor de dano";
		["PrioListDamageMeter"] = "%s Damage Meter\nLista de Prioridade Baseada";
	};
end
--"frFR"
--"koKR"
--"zhCN"
--"esES"
--"esMX"

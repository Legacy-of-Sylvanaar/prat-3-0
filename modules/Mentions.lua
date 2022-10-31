---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2006-2020  Prat Development Team
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to:
--
-- Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor,
-- Boston, MA  02110-1301, USA.
--
--
-------------------------------------------------------------------------------

Prat:AddModuleToLoad(function()
  local function dbg(...) end

  --@debug@
  function dbg(...) Prat:PrintLiteral(...) end

  --@end-debug@

  local PRAT_MODULE = Prat:RequestModuleName("Mentions")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE, "AceHook-3.0")

  -- define localized strings
  local PL = module.PL


  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = false,
    }
  })

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["module_name"] = "Mentions",
    ["module_desc"] = "Support mentioning other players in chat",
    module_info = "THIS MODULE IS EXPERIMENTAL= It adds the ability to @mention people in chat to alert them>",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Mentions")@
PL:AddLocale(PRAT_MODULE, "enUS", L)



--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Mentions")@
PL:AddLocale(PRAT_MODULE, "itIT", L)



--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Mentions")@
PL:AddLocale(PRAT_MODULE, "ptBR", L)



--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Mentions")@
PL:AddLocale(PRAT_MODULE, "frFR", L)



--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Mentions")@
PL:AddLocale(PRAT_MODULE, "deDE", L)



--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Mentions")@
PL:AddLocale(PRAT_MODULE, "koKR",  L)


--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Mentions")@
PL:AddLocale(PRAT_MODULE, "esMX",  L)


--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Mentions")@
PL:AddLocale(PRAT_MODULE, "ruRU",  L)


--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Mentions")@
PL:AddLocale(PRAT_MODULE, "zhCN",  L)


--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Mentions")@
PL:AddLocale(PRAT_MODULE, "esES",  L)


--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Mentions")@
PL:AddLocale(PRAT_MODULE, "zhTW",  L)
end
--@end-non-debug@]===]

  local toggleOption = {
    name = function(info) return info.handler.PL[info[#info] .. "_name"] end,
    desc = function(info) return info.handler.PL[info[#info] .. "_desc"] end,
    type = "toggle",
  }

  Prat:SetModuleOptions(module.name, {
    name = PL.module_name,
    desc = PL.module_desc,
    type = "group",
    args = {
      info = {
        name = PL.module_info,
        type = "description",
      }
    }
  })

  local CLR = Prat.CLR

  local function GetChatCLR(name)
    if name == nil then return CLR.COLOR_NONE end

    local type = strsub(name, 10);
    local info = ChatTypeInfo[type];
    if not info then
      return CLR.COLOR_NONE
    end
    return CLR:GetHexColor(info)
  end

  local function ChatType(text, type) return CLR:Colorize(GetChatCLR(type), text) end

  local function channelLink(name, type, channel)
    return "|Hchannel:" .. type .. ":" .. (channel or "0") .. "|h[" .. ChatType(name, "CHAT_MSG_" .. type) .. "]|h"
  end

  local function handleMention(match, m)
    if m == nil then return end

--    dbg(match, m)
    local name = match:sub(2)
    local event = "CHAT_MSG_" .. m.CTYPE
    local from = "(in " .. _G[event] .. ") "
--    dbg(from)
    SendChatMessage(from .. m.MESSAGE, "WHISPER", GetDefaultLanguage("player"), name);
  end

  Prat:SetModulePatterns(module, {
    { pattern = "@%S+", matchfunc = handleMention, priority = 47, type = "OUTBOUND" }
  })

  function module:OnModuleEnable()
    self:RegisterTabComplete()
    Prat.RegisterChatEvent(self, "Prat_FrameMessage")
--    self:SecureHook("ChatEdit_OnChar")
  end

  function module:Prat_FrameMessage(arg, message, frame, event)
--    message.MESSAGE:gsub("%(in ([^)]+)%)", function(type) end)
  end

  function module:ChatEdit_OnChar(frame)
    local start, index

    index = frame:GetCursorPosition()

--    dbg("OnChar", frame:GetText())
    local regex = "@(%S+)"
    local text = frame:GetText()

    while text:byte(index) ~= 32 do
      if text:byte(index) == 64 then
        start = index + 1
        break;
      end
      index = index - 1

      if index <= 0 then
        break
      end
    end
    local target
    if start then
      target = text:sub(start, frame:GetCursorPosition())
    end
    if (target) then --if they typed a command with a autocompletable target
      AutoCompleteEditBox_SetAutoCompleteSource(frame, GetAutoCompleteResults,
        AUTOCOMPLETE_LIST_TEMPLATES.ONLINE_NOT_BNET.include,  AUTOCOMPLETE_LIST_TEMPLATES.ONLINE_NOT_BNET.exclude)
--    dbg(target)
      local utf8Position = frame:GetUTF8CursorPosition();
      local allowFullMatch = false;
      local nameToShow = frame.autoCompleteSource(target, 1, utf8Position, allowFullMatch, unpack(frame.autoCompleteParams))[1];
--    dbg(nameToShow)
      if (nameToShow and nameToShow.name) then
        local name = Ambiguate(nameToShow.name, "all");
        --We're going to be setting the text programatically which will clear the userInput flag on the editBox.
        --So we want to manually update the dropdown before we change the text.
        AutoComplete_Update(frame, target, utf8Position);
        if strsub(name, 1, 1) ~= "|" then
          target = escapePatternSymbols(target);

          local newTarget = name;

--        dbg(newTarget, text, target, frame:GetCursorPosition())
        local newText = text:sub(1, frame:GetCursorPosition() - target:len())..newTarget..text:sub(frame:GetCursorPosition()+1)
          frame:SetText(newText);
--          frame:HighlightText(strlen(text), strlen(command) + strlen(whitespace) + strlen(newTarget));
        end
      end
    end
  end

  function module:RegisterTabComplete()
    local CLR = Prat.CLR
    local AceTab = LibStub("AceTab-3.0")
    local tabcompleteName = "mentions-tab-complete"
    local servernames = Prat.Addon:GetModule("ServerNames", true)
    local playernames = Prat.Addon:GetModule("PlayerNames", true)

    if not AceTab:IsTabCompletionRegistered(tabcompleteName) then
      local foundCache = {}
      AceTab:RegisterTabCompletion(tabcompleteName, "@",
        function(t, ...)
          --          dbg(t, ...)
          for name in pairs(playernames.Classes) do
            table.insert(t, name)
          end
        end,
        function(u, cands, ...)
          local candcount = #cands
          if candcount <= playernames.db.profile.tabcompletelimit then
            local text
            for key, cand in pairs(cands) do
              if servernames then
                local plr, svr = key:match("([^%-]+)%-?(.*)")

                cand = CLR:Player(cand, plr, playernames:getClass(key))

                if svr then
                  svr = servernames:FormatServer(nil, servernames:GetServerKey(svr))
                  cand = cand .. (svr and ("-" .. svr) or "")
                end
              else
                cand = CLR:Player(cand, cand, playernames:getClass(cand))
              end


              text = text and (text .. ", " .. cand) or cand
            end
            return "   " .. text
          else
            return "   " .. ("Too many matches (%d possible)"):format(candcount)
          end
        end,
        nil,
        function(name)
          return name:gsub(Prat.MULTIBYTE_FIRST_CHAR, string.upper, 1):match("^[^%-]+")
        end)
    end
  end
end)
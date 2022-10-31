Prat:AddModuleToLoad(function()
  local PRAT_MODULE = Prat:RequestModuleName("Search")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE)

  local PL = module.PL

  local dbg = function() end
  --@debug@
  dbg = function(...) Prat:PrintLiteral(...) end
  --@end-debug@

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    module_name = "Search",
    module_desc = "Adds the ability to search the chatframes.",
    module_info = "This module adds search boxes on the chat frames, and the /find commands to search the chat history\n\nUsage:\n\n /find <text>",
    err_tooshort = "Search term is too short",
    err_notfound = "Not Found",
    find_results = "Find Results:",
    bnet_removed = "<BNET REMOVED>",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/
  --[===[@non-debug@
 do
     local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Search")@

   PL:AddLocale(PRAT_MODULE, "enUS",L)


--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Search")@

   PL:AddLocale(PRAT_MODULE, "frFR",L)


--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Search")@

   PL:AddLocale(PRAT_MODULE, "deDE",L)


--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Search")@

   PL:AddLocale(PRAT_MODULE, "koKR",L)


--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Search")@

   PL:AddLocale(PRAT_MODULE, "esMX",L)


--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Search")@

   PL:AddLocale(PRAT_MODULE, "ruRU",L)


--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Search")@

   PL:AddLocale(PRAT_MODULE, "zhCN",L)


--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Search")@

   PL:AddLocale(PRAT_MODULE, "esES",L)


--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Search")@

   PL:AddLocale(PRAT_MODULE, "zhTW",L)

 end
 --@end-non-debug@]===]




  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = true,
      searchactivealpha = 1.0,
      searchinactivealpha = 0.1
    }
  })


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


  function module:StashSearch(frame)
    frame:SetAlpha(self.db.profile.searchinactivealpha)
    frame:SetWidth(30)
  end

  function module:UnstashSearch(frame)
    frame:SetAlpha(self.db.profile.searchactivealpha)
    frame:SetWidth(130)
  end

  function module:CreateSearchBox(chatFrame)
    local name = chatFrame:GetName()
    local f = CreateFrame("EditBox", name .. "ChatSearchEditBox", chatFrame, "SearchBoxTemplate")

    f:SetWidth(130)
    f:SetHeight(16)
    f:SetFrameStrata("HIGH")
    f:SetPoint("TOPRIGHT", chatFrame, "TOPRIGHT")
    f:SetScript("OnEnter", function()
      local hoverAlpha = self.db.profile.searchinactivealpha + (self.db.profile.searchactivealpha - self.db.profile.searchinactivealpha) / 2
      if f:HasFocus() then self:UnstashSearch(f) else f:SetAlpha(hoverAlpha) end
    end)
    f:SetScript("OnLeave", function()
      if f:HasFocus() then self:UnstashSearch(f) else self:StashSearch(f) end
    end)
    f:SetScript("OnEditFocusLost", function() self:StashSearch(f) end)
    f:SetScript("OnEditFocusGained", function() self:UnstashSearch(f) end)
    f:SetScript("OnEscapePressed", function() f:ClearFocus() end)
    f:SetScript("OnEnterPressed", function(frame)
      local query = f:GetText()
      if query and query:len() > 0 then
        module:Find(query, true, frame:GetParent())
      end
    end)
    f.anim = f:CreateAnimationGroup()
    f.anim.fade1 = f.anim:CreateAnimation("Alpha")
    f.anim.fade1:SetFromAlpha(self.db.profile.searchactivealpha)
    f.anim.fade1:SetDuration(3)
    f.anim.fade1:SetToAlpha(self.db.profile.searchinactivealpha)
    f.anim.fade1:SetSmoothing("IN")
    f.anim:SetScript("OnFinished", function(...)
      if f:HasFocus() then
        self:UnstashSearch(f)
      else
        self:StashSearch(f)
      end
    end)

    f.anim:Play()

    return f
  end

  Prat:SetModuleInit(module, function(self)
    self.searchBoxes = {}
  end)

  function module:Prat_FramesUpdated(info, name, chatFrame, ...)
    if not self.searchBoxes[name] then
      self.searchBoxes[name] = self:CreateSearchBox(chatFrame)
    end
  end

  function module:OnModuleEnable()
    Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)

    for name, frame in pairs(Prat.HookedFrames) do
      if not self.searchBoxes[name] then
        self.searchBoxes[name] = self:CreateSearchBox(frame)
      end
    end

    for _, f in pairs(self.searchBoxes) do
      f:Show()
    end
  end

  function module:OnModuleDisable()
    for _, f in pairs(self.searchBoxes) do
      f:Hide()
    end
  end


  SLASH_FIND1 = "/find"
  SlashCmdList["FIND"] = function(msg) module:Find(msg, true) end

  local foundlines = {}
  local scrapelines = {}

  local CLR = Prat.CLR
  local function SearchTerm(term) return CLR:Colorize("ffff40", term) end

  function module:Find(word, all, frame)
    if not self.db.profile.on then
      return
    end

    if frame == nil then
      frame = SELECTED_CHAT_FRAME
    end

    if not word then return end

    if #word <= 1 then
      frame:ScrollToBottom()
      self:Output(frame, PL.err_tooshort)
      return
    end

    if frame:GetNumMessages() == 0 then
      frame:ScrollToBottom()
      self:Output(frame, PL.err_notfound)
      return
    end

    self.lastsearch = word

    self:ScrapeFrame(frame, nil, true)

    for _, v in ipairs(scrapelines) do
      if v.message and v.message:find(Prat.CaseInsensitveWordPattern(word)) then
        if all then
          table.insert(foundlines, v)
        else
          return
        end
      end
    end

    self.lastsearch = nil

    frame:ScrollToBottom()

    if all and #foundlines > 0 then
      self:Output(frame, "-------------------------------------------------------------")
      self:Output(frame, PL.find_results .. ": " .. SearchTerm(word))

      Prat.loading = true -- prevent double timestamp
      for _, v in ipairs(foundlines) do
        frame:AddMessage(v.message:gsub("|K.-|k", PL.bnet_removed), v.r, v.g, v.b)
      end
      Prat.loading = nil
      self:Output(frame, "-------------------------------------------------------------")
    else
      self:Output(frame, PL.err_notfound)
    end

    wipe(foundlines)
    wipe(scrapelines)
  end

  function module:ScrapeFrame(frame)
    wipe(scrapelines)

    for i=frame:GetNumMessages(),1,-1 do
      local msg = frame.historyBuffer:GetEntryAtIndex(i)

      if msg and msg.message then
        table.insert(scrapelines, msg)
      end
    end
  end

  return
end) -- Prat:AddModuleToLoad
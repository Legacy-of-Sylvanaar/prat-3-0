--[[ BEGIN STANDARD HEADER ]] --

-- Imports
local _G = _G
local SVC_NAMESPACE = SVC_NAMESPACE

-- Isolate the environment
setfenv(1, select(2, ...))

--[[ END STANDARD HEADER ]] --

local stack = _G.debugstack()
if stack:match("ns\\") then
  FolderLocation = stack:match("ns\\(.-)\\")
elseif stack:match("ns/") then
  FolderLocation = _G.debugstack():match("ns/(.-)/"):gsub("/", "\\")
end


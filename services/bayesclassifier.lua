--[[
	SpamBayes for WoW, a lightweight bayesian antispam for World of Warcraft
	Algorithm of probabilities converted in Lua from SpamBayes Python built by
	a combination of work from Gary Robinson and Tim Peters and many contributers
	Copyright @ 2010 Arnaud Dovi (Merah@AthelLoren, ad@heapoverflow.com)

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

--[[
$Rev:: 41                    $:  Revision of last commit
$Author:: arnaud             $:  Author of last commit
$Date:: 2012-09-02 23:53:50 #$:  Date of last commit
$WoW:: 5.0.5.16030           $:  Client of the last tests
]]

--[[ BEGIN STANDARD HEADER ]] --

-- Imports
local ipairs            = ipairs
local math_exp          = math.exp
local math_frexp        = math.frexp
local math_floor        = math.floor
local math_min          = math.min
local math_sqrt         = math.sqrt
local math_log          = math.log
local math_abs          = math.abs
local pairs             = pairs
local LN2               = math.log(2) -- used frequently by chi-combining

-- Isolate the environment
setfenv(1, select(2, ...))

--[[ END STANDARD HEADER ]] --

local function chi2Q(x2, v)
	-- Return prob(chisq >= x2, with v degrees of freedom).
	-- v must be even.
	-- XXX If x2 is very large, exp(-m) will underflow to 0.
	local term
	local m = x2 / 2.0
	local sum = math_exp(-m)
	local term = math_exp(-m)
	for i = 1, math_floor(v / 2) do
		term = term * (m / i)
		sum  = sum + term
	end
	-- With small x2 and large v, accumulated roundoff error, plus error in
	-- the platform exp(), can cause this to spill a few ULP above 1.0.  For
	-- example, chi2Q(100, 300) on my box has sum == 1.0 + 2.0**-52 at this
	-- point.  Returning a value even a teensy bit over 1.0 is no good.
	return math_min(sum, 1.0)
end

local function probability(db, record)
	-- Compute, store, and return prob(msg is spam | msg contains word).
	-- This is the Graham calculation, but stripped of biases, and
	-- stripped of clamping into 0.01 thru 0.99.  The Bayesian
	-- adjustment following keeps them in a sane range, and one
	-- that naturally grows the more evidence there is to back up
	-- a probability.
	local spamcount = record.spamcount
	local hamcount = record.hamcount
	local pcache = db.probcache[spamcount] and db.probcache[spamcount][hamcount] or nil -- Try the cache first
	if pcache then return pcache end
	local nham = db.nham ~= 0 and db.nham or 1
	local nspam = db.nspam ~= 0 and db.nspam or 1
	local hamratio = hamcount / nham --assert hamcount <= nham, "Token seen in more ham than ham trained."
	local spamratio = spamcount / nspam --assert spamcount <= nspam, "Token seen in more spam than spam trained."
	local prob = spamratio / (hamratio + spamratio)
	local S = 0.45 --local S = options["Classifier", "unknown_word_strength"]
	local StimesX = S * 0.5 --StimesX = S * options["Classifier", "unknown_word_prob"]
	-- Now do Robinson's Bayesian adjustment.
	--
	--         s*x + n*p(w)
	-- f(w) = --------------
	--           s + n
	--
	-- I find this easier to reason about like so (equivalent when
	-- s != 0):
	--
	--        x - p
	--  p +  -------
	--       1 + n/s
	--
	-- IOW, it moves p a fraction of the distance from p to x, and
	-- less so the larger n is, or the smaller s is.
	local n = hamcount + spamcount
	prob = (StimesX + n * prob) / (S + n)
	db.probcache[spamcount] = db.probcache[spamcount] or {} -- Update the cache
	db.probcache[spamcount][hamcount] = prob
	return prob
end

local function wordinfoget(db, word)
	return db.worddb["-"..word] or nil
end

local function wordinfoset(db,word, record) -- "-" forces quote in SavedVariables in Warhammer Online and left as it is for WoW - <Mera>
	if record.hamcount == 0 and record.spamcount == 0 then
		db.worddb["-"..word] = nil
		return
	end
	db.worddb["-"..word] = record
end

local function worddistanceget(db, word)
	local record = wordinfoget(db, word)
	local prob = record == nil and 0.5 or probability(db, record) --prob = options["Classifier", "unknown_word_prob"]
	local distance = math_abs(prob - 0.5)
	return distance, prob, word, record
end

local function _getclues(db, wordstream)
	local minimum_prob_strength = 0.1
	-- The all-unigram scheme just scores the tokens as-is.  A set()
	-- is used to weed out duplicates at high speed.

	local clues = {}
	for _, word in ipairs(wordstream) do
		local tup = { worddistanceget(db, word) }
		--d(tup)
		if tup[1] >= minimum_prob_strength then
			clues[#clues + 1] = tup
		end
	end
	--d(clues)
	--table_sort(clues, function(a,b) return a<b end)
	if #clues > 150 then
		for i = 0, #clues - 150 do --del clues[0 : -options["Classifier", "max_discriminators"]]
			clues[i] = nil
		end
	end
	for _, tup in ipairs(clues) do tup[1] = nil end
	return clues
end

local function add_msg(db, wordstream, is_spam)
	db.probcache = {}    -- nuke the prob cache
	if is_spam then
		db.nspam = db.nspam + 1
	else
		db.nham  = db.nham + 1
	end
	for _, word in ipairs(wordstream) do
		local record = wordinfoget(db, word) or { spamcount = 0, hamcount = 0 }
		if is_spam then
			record.spamcount = record.spamcount + 1
		else
			record.hamcount  = record.hamcount + 1
		end
		wordinfoset(db, word, record)
	end
end

local function verify_cache(db, wordstream, is_spam)
	local tempcache = {}
	local err = false
	for _, word in ipairs(wordstream) do
		local record = wordinfoget(db, word)
		if record ~= nil then
			if is_spam then
				if record.spamcount == 0 then -- the phrase has not been trained or slightly changed - <Mera>
					err = true
					break
				end
				tempcache[word] = record
			else
				if record.hamcount == 0 then
					err = true
					break
				end
				tempcache[word] = record
			end
		else
			err = true
			break
		end
	end
	return err == false and tempcache or nil
end

local function remove_msg(db, wordstream, is_spam)
	db.probcache = {} -- nuke the prob cache
	local vcache = verify_cache(db, wordstream, is_spam) -- if one token does not exist, the phrase has never been trained and no tokens will be deleted  - <Mera>
	if vcache == nil then return 0 end
	for word, record in pairs(vcache) do
		if is_spam then
			record.spamcount = record.spamcount - 1
		else
			record.hamcount = record.hamcount - 1
		end
		wordinfoset(db, word, record)
	end
	if is_spam then
		if db.nspam   > 0 then db.nspam   = db.nspam - 1 end
		if db.cspam   > 0 then db.cspam   = db.cspam - 1 end
	else
		if db.nham    > 0 then db.nham    = db.nham - 1 end
		if db.cham    > 0 then db.cham    = db.cham - 1 end
	end
end

local function chi2_spamprob(db, wordstream, evidence)
	-- Return best-guess probability that wordstream is spam.
	-- wordstream is an iterable object producing words.
	-- The return value is a float in [0.0, 1.0].
	-- If optional arg evidence is True, the return value is a pair
	-- probability, evidence where evidence is a list of
	-- (word, probability) pairs.
	-- We compute two chi-squared statistics, one for ham and one for
	-- spam.  The sum-of-the-logs business is more sensitive to probs
	-- near 0 than to probs near 1, so the spam measure uses 1-p (so
	-- that high-spamprob words have greatest effect), and the ham
	-- measure uses p directly (so that lo-spamprob words have greatest
	-- effect).
	-- For optimization, sum-of-logs == log-of-product, and f.p.
	-- multiplication is a lot cheaper than calling ln().  It's easy
	-- to underflow to 0.0, though, so we simulate unbounded dynamic
	-- range via frexp.  The real product H = this H * 2**Hexp, and
	-- likewise the real product S = this S * 2**Sexp.
	local H, S       = 1.0, 1.0
	local Hexp, Sexp = 0, 0
	local ln         = math_log
	local prob, word, record

	local clues = _getclues(db, wordstream)
	for _, data in ipairs(clues) do
		local e
		prob, word, record = data[2], data[3], data[4]
		S = S * ( 1.0 - prob)
		H = H * prob
		if S < 1e-200 then  -- prevent underflow
			S, e = math_frexp(S)
			Sexp = Sexp + e
		end
		if H < 1e-200 then  -- prevent underflow
			H, e = math_frexp(H)
			Hexp = Hexp + e
		end
	end
	-- Compute the natural log of the product = sum of the logs: ln(x * 2**i) = ln(x) + i * ln(2).
	S = ln(S) + Sexp * LN2
	H = ln(H) + Hexp * LN2
	local n = #clues
	if n then
		S = 1.0 - chi2Q(-2.0 * S, 2*n)
		H = 1.0 - chi2Q(-2.0 * H, 2*n)
		-- How to combine these into a single spam score?  We originally
		-- used (S-H)/(S+H) scaled into [0., 1.], which equals S/(S+H).  A
		-- systematic problem is that we could end up being near-certain
		-- a thing was (for example) spam, even if S was small, provided
		-- that H was much smaller.
		-- Rob Hooft stared at these problems and invented the measure
		-- we use now, the simpler S-H, scaled into [0., 1.].
		prob = (S-H + 1.0) / 2.0
	else prob = 0.5 end
	if evidence then
		-- clues = [(w, p) for p, w, _r in clues]
		-- clues.sort(lambda a, b: cmp(a[1], b[1]))
		-- clues.insert(0, ('*S*', S))
		-- clues.insert(0, ('*H*', H))
		-- return prob, clues
	else
		return prob
	end
end

local defaults = { nham = 0, nspam = 0, cspam = 0, cham = 0, cunsure = 0, probcache = {}, worddb = {}}
function GetClassifier(db)
  local db = db
  for k,v in pairs(defaults) do
    db[k] = db[k] or v
  end
  return {
    getprob = function (...) return chi2_spamprob(db, ...) end,
    learn = function (...) return add_msg(db, ...) end,
    unlearn = function (...) return remove_msg(db, ...) end,
  }
end

--
-- Crash-B-Gone for Tonio

--
-- KosmicTeal (https://github.com/KosmicTeal/)
-- MAIKA and Voctro Labs' fan since 2013; waiting for new Spanish
-- commerical voicebanks since 2013 too
--
-- Original plugin by Yamaha Corporation
--
-- Modified plugin to be used with Tonio from Zero-G
-- (Tonio crashes everytime there's an @ phoneme)
--
function manifest()
    myManifest = {
        name          = "Crash-B-Gone for Tonio",
        comment       = "Converts all @ to V",
        author        = "KosmicTeal",
        pluginID      = "{6fc0f53e-72e6-11eb-9439-0242ac130002}",
        pluginVersion = "1.0.0.0",
        apiVersion    = "3.0.1.0"
    }

    return myManifest
end


function main(processParam, envParam)
	local beginPosTick = processParam.beginPosTick	-- 選択範囲の始点時刻（ローカルTick）.
	local endPosTick   = processParam.endPosTick	-- 選択範囲の終点時刻（ローカルTick）.
	local songPosTick  = processParam.songPosTick	-- カレントソングポジション時刻（ローカルTick）.

	local scriptDir  = envParam.scriptDir		-- Luaスクリプトが配置されているディレクトリパス（末尾にデリミタ "\" を含む）.
	local scriptName = envParam.scriptName		-- Luaスクリプトのファイル名.
	local tempDir    = envParam.tempDir			-- Luaプラグインが利用可能なテンポラリディレクトリパス（末尾にデリミタ "\" を含む）.

	local endStatus = 0

	local convCount = 0

	local note = {}

	VSSeekToBeginNote()

	local retCode, note = VSGetNextNote()
	while (retCode == 1) do
		if( beginPosTick <= note.posTick ) then
			if( endPosTick <= note.posTick ) then
				break
			end
			if( string.find(note.phonemes , "@") ) then
        -- any case
				note.phonemes = string.gsub(note.phonemes,"@ ","V ")
				-- single @ case
				if (note.phonemes == "@") then note.phonemes = "V" end
				
				setPhonemeLock(note, 1)

				retCode = VSUpdateNote(note)
				if (retCode == 0) then
					endStatus = 1
					break
				end
				convCount = convCount + 1
			end
		end

		retCode, note = VSGetNextNote()
	end

	local result = "Tonio won't leak your PC memory anymore."
	VSMessageBox(result,0)

	return endStatus
end


function setPhonemeLock(note, phLock)
	for key, val in pairs(note) do
		if (key == "phLock") then
			note.phLock = phLock
			break
		end
	end

	return
end

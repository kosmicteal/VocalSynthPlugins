--
-- VocaAutoPitch

--
-- KosmicTeal (https://github.com/KosmicTeal/)
-- MegalovaLugin
--

------------- MANIFEST
function manifest()
    myManifest = {
        name          = "VocaAutoPitch",
        comment       = "April Fools 2021 (False auto-tuning plugin)",
        author        = "KosmicTeal",	
        pluginID      = "{1A187643-F250-9B5A-1F5C-F635FFFCAD2B}",
        pluginVersion = "0.4.0.1",
        apiVersion    = "3.0.0.1"
    }
    
    return myManifest
end

	--dlgStatus, signTypeStr  = VSDlgGetStringValue("If you're reading this, happy april fools")
	--dlgStatus, signTypeStr  = VSDlgGetStringValue("As much as an autotuning plugin would be nice")
	--dlgStatus, signTypeStr  = VSDlgGetStringValue("I don't know how to tune in the first place")
	--dlgStatus, signTypeStr  = VSDlgGetStringValue("And I need to do commissions as those are my main hobby")
	--dlgStatus, signTypeStr  = VSDlgGetStringValue("Plus those commissions are my only way of income rn so yeah")
	--dlgStatus, signTypeStr  = VSDlgGetStringValue("Please don't take this april fools joke seriously gdamnit")

------------- CONVERSION SETS FROM STRINGS TO DATA

langTypeListMap = {
	{ langTypeStr = "Japanese",	langType = 0 },  
	{ langTypeStr = "English",	langType = 1 }, 
	{ langTypeStr = "Espanol (Español)",	langType = 2  },  
	{ langTypeStr = "Chinese",	langType = 3  },  
	{ langTypeStr = "Korean",	langType = 4  },  
}
langTypeIDNum = table.getn(langTypeListMap)

function main(processParam, envParam)	

	----------------------------------------------------- Main initalizer
	local beginPosTick = processParam.beginPosTick
	local endPosTick   = processParam.endPosTick
	local songPosTick  = processParam.songPosTick

	local scriptDir  = envParam.scriptDir
	local scriptName = envParam.scriptName
	local tempDir    = envParam.tempDir
	
	----------------------------------------------------- UI creation
	VSDlgSetDialogTitle("VocaAutoPitch - EEDA") 

	local field = {}


	field.name       = "VEL"
	field.caption    = "VEL parameter automatization"
	field.initialVal = "Low, Mid, High"
	field.type = 4				
	dlgStatus  = VSDlgAddField(field)
	
	field.name       = "DYN"
	field.caption    = "DYN parameter automatization"
	field.initialVal = "Low, Mid, High"
	field.type = 4				
	dlgStatus  = VSDlgAddField(field)

	field.name       = "BRE"
	field.caption    = "VEL parameter automatization"
	field.initialVal = "Low, Mid, High"
	field.type = 4				
	dlgStatus  = VSDlgAddField(field)
	
	field.name       = "BRI"
	field.caption    = "BRI parameter automatization"
	field.initialVal = "Low, Mid, High"
	field.type = 4				
	dlgStatus  = VSDlgAddField(field)
	
	field.name       = "CLE"
	field.caption    = "CLE parameter automatization"
	field.initialVal = "Low, Mid, High"
	field.type = 4				
	dlgStatus  = VSDlgAddField(field)
	
	field.name       = "OPE"
	field.caption    = "OPE parameter automatization"
	field.initialVal = "Low, Mid, High"
	field.type = 4				
	dlgStatus  = VSDlgAddField(field)
	
	field.name       = "GEN"
	field.caption    = "GEN parameter automatization"
	field.initialVal = "Low, Mid, High"
	field.type = 4				
	dlgStatus  = VSDlgAddField(field)
	
	field.name       = "POR"
	field.caption    = "POR parameter automatization"
	field.initialVal = "Low, Mid, High"
	field.type = 4				
	dlgStatus  = VSDlgAddField(field)

	field.name       = "XSY"
	field.caption    = "XSY parameter automatization (V4)"
	field.initialVal = "Low, Low, Low"
	field.type = 4				
	dlgStatus  = VSDlgAddField(field)
	
	field.name       = "GWL"
	field.caption    = "GLW parameter automatization (V4)"
	field.initialVal = "Low, Mid?1, High??, V4 GWL reveal level"
	field.type = 4				
	dlgStatus  = VSDlgAddField(field)
	
	field.name       = "PIT"
	field.caption    = "PIT parameter automatization"
	field.initialVal = "A bit, a more, MORE, Ｍ Ｏ Ｒ Ｅ"
	field.type = 4				
	dlgStatus  = VSDlgAddField(field)
	
	field.name       = "language"
	field.caption    = "Voicebank Language"
	field.initialVal = 
		"Japanese" ..
		", English" ..
		", Chinese" ..
		", Espanol (Español)" ..
		", Korean"
	field.type = 4				
	dlgStatus  = VSDlgAddField(field)

	dlgStatus = VSDlgDoModal()
	if (dlgStatus == 2) then
		-- When it was cancelled.
		return 0
	end
	if ((dlgStatus ~= 1) and (dlgStatus ~= 2)) then
		-- When it returned an error.
		return 1
	end


	-- tell software to recollect data
	dlgStatus, langTypeStr  = VSDlgGetStringValue("language")


	-- recollect data (Strings)
	local index = 1
	local langType = ""
	for index, str in ipairs(langTypeListMap) do
		if (langTypeStr == str.langTypeStr) then
			langType = str.langType
		end
	end
	
	-- index = 1
	-- local signType = 0
	-- for index, str in ipairs(signTypeListMap) do
		-- if (signTypeStr == str.signTypeStr) then
			-- signType = str.signType
		-- end
	-- end
	
	-- index = 1
	-- local lengType = 0
	-- for index, str in ipairs(lengTypeListMap) do
		-- if (lengTypeStr == str.lengTypeStr) then
			-- lengType = str.lengType
		-- end
	-- end

	-- index = 1
	-- local signType = 0
	-- for index, str in ipairs(signTypeListMap) do
		-- if (signTypeStr == str.signTypeStr) then
			-- signType = str.signType
		-- end
	-- end
	
	-- index = 1
	-- local lengType = 0
	-- for index, str in ipairs(lengTypeListMap) do
		-- if (lengTypeStr == str.lengTypeStr) then
			-- lengType = str.lengType
		-- end
	-- end

	-- index = 1
	-- local signType = 0
	-- for index, str in ipairs(signTypeListMap) do
		-- if (signTypeStr == str.signTypeStr) then
			-- signType = str.signType
		-- end
	-- end
	
	-- index = 1
	-- local lengType = 0
	-- for index, str in ipairs(lengTypeListMap) do
		-- if (lengTypeStr == str.lengTypeStr) then
			-- lengType = str.lengType
		-- end
	-- end

	-- end query
	local endStatus = 0
	
	-- if (keyType >= 3) then
		-- keyType = keyType - 1
		-- signType = signType + 1
	-- end
	-- resultNotePlace = 12*(valueNote + 2) + keyType * 2 + signType
	
	-- Debug stuff


	----------------------------------------------------- Generation
	
	-- Note to be repeated
	VSUpdateControlAt("DYN",songPosTick,127)
	time_spent = math.random(0,65536)
	
	if (langType == 0) then phon = "t M" 
	elseif (langType == 1) then phon = "th u:"
	else phon = "t u"
	end
	
	local	note = {}                   -- data
	note.posTick  = songPosTick         -- position where it should be placed
	note.durTick  = 180            -- duration
	note.noteNum  = 61     -- which tone is it
	note.velocity = 64             		
	note.lyric    = "tu"       
	note.phonemes = phon    
	
	retCode = VSInsertNote(note)
	
	note.posTick  = songPosTick+180         -- position where it should be placed
	note.durTick  = 180            -- duration
	note.noteNum  = 61     -- which tone is it
	note.velocity = 64             		
	note.lyric    = "tu"       
	note.phonemes = phon    

	retCode = VSInsertNote(note)
	
	note.posTick  = songPosTick+360         -- position where it should be placed
	note.durTick  = 240            -- duration
	note.noteNum  = 71     -- which tone is it
	note.velocity = 64             		
	note.lyric    = "tu"       
	note.phonemes = phon  
	
	retCode = VSInsertNote(note)
	
	note.posTick  = songPosTick+720         -- position where it should be placed
	note.durTick  = 240            -- duration
	note.noteNum  = 66     -- which tone is it
	note.velocity = 64             		
	note.lyric    = "tu"       
	note.phonemes = phon  
	retCode = VSInsertNote(note)
	
		VSMessageBox("Auto-tuning completed in " .. time_spent .. " ms!! ^w^", 0)
		
end

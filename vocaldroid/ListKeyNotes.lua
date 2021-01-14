--
-- ListKeyNotes

--
-- OSformula (https://github.com/OSformula/)
-- MAIKA and Voctro Labs' fan since 2013; waiting for new Spanish
-- commerical voicebanks since 2013 too
--

------------- MANIFEST
function manifest()
    myManifest = {
        name          = "ListKeyNotes",
        comment       = "Create same-length notes in a specific key",
        author        = "OSformula",
        pluginID      = "{DB95F4DD-78DB-FA6E-7FE1-E45D77335FB5}",
        pluginVersion = "1.1.0.0",
        apiVersion    = "3.0.0.1"
    }
    
    return myManifest
end

------------- CONVERSION SETS FROM STRINGS TO DATA
keyTypeListMap = {
	{ keyTypeStr = "C",	keyType = 0  },  
	{ keyTypeStr = "D",	keyType = 1  },  
	{ keyTypeStr = "E",	keyType = 2  },  
	{ keyTypeStr = "F",	keyType = 3  },  
	{ keyTypeStr = "G",	keyType = 4  }, 
	{ keyTypeStr = "A",	keyType = 5  },  
	{ keyTypeStr = "B",	keyType = 6  }
}
keyTypeIDNum = table.getn(keyTypeListMap)

signTypeListMap = {
	{ signTypeStr = " ",	signType = 0  }, 
	{ signTypeStr = "♯",	signType = 1  },
	{ signTypeStr = "♭", 	signType = -1  }
}
singTypeIDNum = table.getn(signTypeListMap)

lengTypeListMap = {
	{ lengTypeStr = "1/4 (Default)",	lengType = 480  },  
	{ lengTypeStr = "1/1",	lengType = 1920  }, 
	{ lengTypeStr = "1/2",	lengType = 960  },  
	{ lengTypeStr = "1/8",	lengType = 240  },  
	{ lengTypeStr = "1/16",	lengType = 120  },  
	{ lengTypeStr = "1/32",	lengType = 60  },
	{ lengTypeStr = "1/64",	lengType = 30  },
}
lengTypeIDNum = table.getn(lengTypeListMap)

function main(processParam, envParam)	

	----------------------------------------------------- Main initalizer
	local beginPosTick = processParam.beginPosTick
	local endPosTick   = processParam.endPosTick
	local songPosTick  = processParam.songPosTick

	local scriptDir  = envParam.scriptDir
	local scriptName = envParam.scriptName
	local tempDir    = envParam.tempDir
	
	----------------------------------------------------- UI creation
	VSDlgSetDialogTitle("ListKeyNotes - Create same-length notes in a specific key") 

	local field = {}


	field.name       = "key"
	field.caption    = "Key"
	field.initialVal =
		"C" ..
		", D" ..
		", E" ..
		", F" ..
		", G" ..
		", A" ..
		", B" 
	field.type = 4				-- table (0=int, 1=bool, 3=string, 4=table)
	dlgStatus  = VSDlgAddField(field)
	
	field.name       = "sign"
	field.caption    = "Signature"
	field.initialVal =
		" " ..
		", ♯" ..
		", ♭"
	field.type = 4
	dlgStatus  = VSDlgAddField(field)
	
	field.name       = "value"
	field.caption    = "Value (between -2 and 8)"
	field.initialVal = "3"
    field.type       = 0
	dlgStatus  = VSDlgAddField(field)
	
	field.name       = "leng"
	field.caption    = "Length"
	field.initialVal =
		"1/4 (Default)" ..
		", 1/1" ..
		", 1/2" ..
		", 1/8" ..
		", 1/16" ..
		", 1/32" ..
		", 1/64"
	field.type = 4
	dlgStatus  = VSDlgAddField(field)
	
	field.name       = "number"
	field.caption    = "Number of notes"
	field.initialVal = "1"
	field.type = 0				-- integer
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
	dlgStatus, keyTypeStr  = VSDlgGetStringValue("key")
	dlgStatus, signTypeStr  = VSDlgGetStringValue("sign")
	dlgStatus, valueNote  = VSDlgGetIntValue("value")
	dlgStatus, lengTypeStr  = VSDlgGetStringValue("leng")
	dlgStatus, numberNotes  = VSDlgGetIntValue("number")

	-- recollect data (Strings)
	local index = 1
	local keyType = 0
	for index, str in ipairs(keyTypeListMap) do
		if (keyTypeStr == str.keyTypeStr) then
			keyType = str.keyType
		end
	end
	
	index = 1
	local signType = 0
	for index, str in ipairs(signTypeListMap) do
		if (signTypeStr == str.signTypeStr) then
			signType = str.signType
		end
	end
	
	index = 1
	local lengType = 0
	for index, str in ipairs(lengTypeListMap) do
		if (lengTypeStr == str.lengTypeStr) then
			lengType = str.lengType
		end
	end

	-- end query
	local endStatus = 0
	
	if (keyType >= 3) then
		keyType = keyType - 1
		signType = signType + 1
	end
	resultNotePlace = 12*(valueNote + 2) + keyType * 2 + signType
	
	-- Debug stuff
	VSMessageBox("Key: " .. keyType .. ". Sign: " .. signType .. ". Value: " .. valueNote .. ". \n Duration:" .. lengType .. ".\n Total Place (C3 is 60):" .. resultNotePlace .. "\n Number of notes:" .. numberNotes, 0)

	----------------------------------------------------- Generation
	
	-- Note to be repeated
	
	local	note = {}                   -- data
	note.posTick  = songPosTick         -- position where it should be placed
	note.durTick  = lengType            -- duration
	note.noteNum  = resultNotePlace     -- which tone is it
	note.velocity = 64             		
	note.lyric    = "na"       
	note.phonemes = "n a"    
	
	-- Loop
	local i = 0
	while i < numberNotes do 
		note.posTick = songPosTick + (lengType * i)
		retCode = VSInsertNote(note)
		i = i + 1 --LUA DOESN'T LET YOU DO I++ WHAT THE FRICK
		if (retCode ~= 1) then
			VSMessageBox("There's been an error while creating the note!", 0)
			return 1
		end
	end
	
end

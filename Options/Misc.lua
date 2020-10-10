local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.misc.args
local LSM = E.Libs.LSM
local M = W:GetModule("Misc")
local MF = W:GetModule("MoveFrames")
local GB = W:GetModule("GameBar")

local format = format
local tonumber = tonumber
local tostring = tostring

local GetClassInfo = GetClassInfo
local GetNumClasses = GetNumClasses
local GetSpellInfo = GetSpellInfo

local C_CVar_GetCVar = C_CVar.GetCVar
local C_CVar_GetCVarBool = C_CVar.GetCVarBool
local C_CVar_SetCVar = C_CVar.SetCVar

options.cvars = {
    order = 1,
    type = "group",
    name = L["CVars Editor"],
    get = function(info)
        return C_CVar_GetCVarBool(info[#info])
    end,
    set = function(info, value)
        C_CVar_SetCVar(info[#info], value and "1" or "0")
    end,
    args = {
        desc = {
            order = 1,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = L["A simple editor for CVars."],
                    fontSize = "medium"
                }
            }
        },
        combat = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Combat"],
            args = {
                floatingCombatTextCombatDamage = {
                    order = 1,
                    type = "toggle",
                    name = L["Floating Damage Text"]
                },
                floatingCombatTextCombatHealing = {
                    order = 2,
                    type = "toggle",
                    name = L["Floating Healing Text"]
                },
                WorldTextScale = {
                    order = 3,
                    type = "range",
                    name = L["Floating Text Scale"],
                    get = function(info)
                        return tonumber(C_CVar_GetCVar(info[#info]))
                    end,
                    set = function(info, value)
                        return C_CVar_SetCVar(info[#info], value)
                    end,
                    min = 0.1,
                    max = 5,
                    step = 0.1
                },
                SpellQueueWindow = {
                    order = 4,
                    type = "range",
                    name = L["Spell Queue Window"],
                    get = function(info)
                        return tonumber(C_CVar_GetCVar(info[#info]))
                    end,
                    set = function(info, value)
                        return C_CVar_SetCVar(info[#info], value)
                    end,
                    min = 0,
                    max = 400,
                    step = 1
                }
            }
        },
        visualEffect = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Visual Effect"],
            args = {
                ffxGlow = {
                    order = 1,
                    type = "toggle",
                    name = L["Glow Effect"]
                },
                ffxDeath = {
                    order = 2,
                    type = "toggle",
                    name = L["Death Effect"]
                },
                ffxNether = {
                    order = 3,
                    type = "toggle",
                    name = L["Nether Effect"]
                }
            }
        },
        tooltips = {
            order = 4,
            type = "group",
            inline = true,
            name = L["Tooltips"],
            args = {
                alwaysCompareItems = {
                    order = 1,
                    type = "toggle",
                    name = L["Auto Compare"]
                },
                showQuestTrackingTooltips = {
                    order = 2,
                    type = "toggle",
                    name = L["Show Quest Info"],
                    desc = L["Add progress information (Ex. Mob 10/25)."]
                }
            }
        },
        mouse = {
            order = 5,
            type = "group",
            inline = true,
            name = L["Mouse"],
            args = {
                rawMouseEnable = {
                    order = 1,
                    type = "toggle",
                    name = L["Raw Mouse"],
                    desc = L["It will fix the problem if your cursor has abnormal movement."]
                },
                rawMouseAccelerationEnable = {
                    order = 2,
                    type = "toggle",
                    name = L["Raw Mouse Acceleration"],
                    desc = L[
                        "Changes the rate at which your mouse pointer moves based on the speed you are moving the mouse."
                    ]
                }
            }
        }
    }
}

options.moveFrames = {
    order = 2,
    type = "group",
    name = L["Move Frames"],
    get = function(info)
        return E.private.WT.misc[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.misc[info[#info]] = value
        E:StaticPopup_Show("PRIVATE_RL")
    end,
    args = {
        desc = {
            order = 0,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = function()
                        if MF.StopRunning then
                            return format(
                                "|cffff0000" .. L["Because of %s, this module will not be loaded."] .. "|r",
                                MF.StopRunning
                            )
                        else
                            return L["This module provides the feature that repositions the frames with drag and drop."]
                        end
                    end,
                    fontSize = "medium"
                }
            }
        },
        moveBlizzardFrames = {
            order = 1,
            type = "toggle",
            name = L["Enable"]
        },
        moveElvUIBags = {
            order = 2,
            type = "toggle",
            name = L["Move ElvUI Bags"]
        },
        remember = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Remember Positions"],
            args = {
                rememberPositions = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    set = function(info, value)
                        E.private.WT.misc[info[#info]] = value
                    end
                },
                clearHistory = {
                    order = 2,
                    type = "execute",
                    name = L["Clear History"],
                    func = function()
                        E.private.WT.misc.framePositions = {}
                    end
                }
            }
        }
    }
}

options.transmog = {
    order = 3,
    type = "group",
    name = L["Transmog"],
    args = {
        desc = {
            order = 1,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = L["This module focus on enhancement of transmog."],
                    fontSize = "medium"
                }
            }
        },
        saveArtifact = {
            order = 2,
            type = "toggle",
            name = L["Save Artifact"],
            desc = L["Allow you to save outfits even if the artifact in it."],
            get = function(info)
                return E.private.WT.misc[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.misc[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        }
    }
}

options.mute = {
    order = 3,
    type = "group",
    name = L["Mute"],
    args = {
        desc = {
            order = 1,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = L["Disable some annoying sound effects."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            get = function(info)
                return E.private.WT.misc.mute.enable
            end,
            set = function(info, value)
                E.private.WT.misc.mute.enable = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        mount = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Mount"],
            get = function(info)
                return E.private.WT.misc.mute[info[#info - 1]][tonumber(info[#info])]
            end,
            set = function(info, value)
                E.private.WT.misc.mute[info[#info - 1]][tonumber(info[#info])] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            args = {}
        }
    }
}

do
    for id in pairs(V.misc.mute.mount) do
        options.mute.args.mount.args[tostring(id)] = {
            order = id,
            type = "toggle",
            name = GetSpellInfo(id)
        }
    end
end

options.pauseToSlash = {
    order = 5,
    type = "group",
    name = L["Pause to slash"],
    args = {
        desc = {
            order = 1,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = L[
                        "This module works with Chinese and Korean, it will correct the text to slash when you input Pause."
                    ],
                    fontSize = "medium"
                }
            }
        },
        pauseToSlash = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            desc = L["Pause to slash (Just for Chinese and Korean players)"],
            get = function(info)
                return E.private.WT.misc[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.misc[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        }
    }
}

options.disableTalkingHead = {
    order = 6,
    type = "group",
    name = L["Disable Talking Head"],
    args = {
        desc = {
            order = 1,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = L["Enable this module will disable Blizzard Talking Head."],
                    fontSize = "medium"
                }
            }
        },
        disableTalkingHead = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            desc = L["Stop talking."],
            get = function(info)
                return E.private.WT.misc[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.misc[info[#info]] = value
            end
        }
    }
}

options.tags = {
    order = 7,
    type = "group",
    name = L["Tags"],
    args = {
        desc = {
            order = 0,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = L["Add more oUF tags. You can use them on UnitFrames configuration."],
                    fontSize = "medium"
                }
            }
        },
        tags = {
            order = 1,
            type = "toggle",
            name = L["Enable"],
            get = function(info)
                return E.private.WT.misc[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.misc[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        }
    }
}

do
    local examples = {}

    examples.health = {
        name = L["Health"],
        noSign = {
            tag = "[health:percent-nosign]",
            text = L["The percentage of current health without percent sign"]
        },
        noStatusNoSign = {
            tag = "[health:percent-nostatus-nosign]",
            text = L["The percentage of health without percent sign and status"]
        }
    }

    examples.power = {
        name = L["Power"],
        noSign = {
            tag = "[power:percent-nosign]",
            text = L["The percentage of current power without percent sign"]
        }
    }

    examples.range = {
        name = L["Range"],
        normal = {
            tag = "[range]",
            text = L["Range"]
        },
        expectation = {
            tag = "[range:expectation]",
            text = L["Range Expectation"]
        }
    }

    examples.color = {
        name = L["Color"],
        player = {
            order = 0,
            tag = "[classcolor:player]",
            text = L["The color of the player's class"]
        }
    }

    local className = {
        WARRIOR = L["Warrior"],
        PALADIN = L["Paladin"],
        HUNTER = L["Hunter"],
        ROGUE = L["Rogue"],
        PRIEST = L["Priest"],
        DEATHKNIGHT = L["Deathknight"],
        SHAMAN = L["Shaman"],
        MAGE = L["Mage"],
        WARLOCK = L["Warlock"],
        MONK = L["Monk"],
        DRUID = L["Druid"],
        DEMONHUNTER = L["Demonhunter"]
    }

    for i = 1, GetNumClasses() do
        local upperText = select(2, GetClassInfo(i))
        examples.color[upperText] = {
            order = i,
            tag = format("[classcolor:%s]", strlower(upperText)),
            text = format(L["The color of %s"], className[upperText])
        }
    end

    local index = 11
    for cat, catTable in pairs(examples) do
        options.tags.args[cat] = {
            order = index,
            type = "group",
            name = catTable.name,
            args = {}
        }
        index = index + 1

        local subIndex = 1
        for key, data in pairs(catTable) do
            if key ~= "name" then
                options.tags.args[cat].args[key] = {
                    order = data.order or subIndex,
                    type = "input",
                    width = "full",
                    name = data.text,
                    get = function()
                        return data.tag
                    end
                }
                subIndex = subIndex + 1
            end
        end
    end
end

options.gameBar = {
    order = 8,
    type = "group",
    name = L["Game Bar"],
    get = function(info)
        return E.db.WT.misc.gameBar[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.misc.gameBar[info[#info]] = value
    end,
    args = {
        desc = {
            order = 1,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = L["Add a game bar for improving QoL."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            desc = L["Toggle the game bar"]
        },
        general = {
            order = 10,
            type = "group",
            name = L["General"],
            get = function(info)
                return E.db.WT.misc.gameBar[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.misc.gameBar[info[#info]] = value
            end,
            args = {
                backdrop = {
                    order = 1,
                    type = "toggle",
                    name = L["Bar Backdrop"],
                    desc = L["Show a backdrop of the bar."]
                },
                backdropSpacing = {
                    order = 2,
                    type = "range",
                    name = L["Backdrop Spacing"],
                    desc = L["The spacing between the backdrop and the buttons."],
                    min = 1,
                    max = 30,
                    step = 1
                },
                spacing = {
                    order = 3,
                    type = "range",
                    name = L["Button Spacing"],
                    desc = L["The spacing between buttons."],
                    min = 1,
                    max = 30,
                    step = 1
                },
                buttonSize = {
                    order = 4,
                    type = "range",
                    name = L["Button Size"],
                    desc = L["The size of the buttons."],
                    min = 2,
                    max = 80,
                    step = 1
                }
            }
        },
        display = {
            order = 11,
            type = "group",
            name = L["Display"],
            get = function(info)
                return E.db.WT.misc.gameBar[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.misc.gameBar[info[#info]] = value
            end,
            args = {
                fadeTime = {
                    order = 1,
                    type = "range",
                    name = L["Fade Time"],
                    desc = L["The animation speed."],
                    min = 0,
                    max = 3,
                    step = 0.01
                },
                normal = {
                    order = 2,
                    type = "group",
                    name = L["Normal"],
                    inline = true,
                    args = {
                        normalColor = {
                            order = 1,
                            type = "select",
                            name = L["Mode"],
                            values = {
                                NONE = L["None"],
                                CLASS = L["Class Color"],
                                VALUE = L["Value Color"],
                                CUSTOM = L["Custom"]
                            }
                        },
                        customNormalColor = {
                            order = 2,
                            type = "color",
                            name = L["Custom Color"],
                            hidden = function()
                                return E.db.WT.misc.gameBar.normalColor ~= "CUSTOM"
                            end,
                            get = function(info)
                                local db = E.db.WT.misc.gameBar[info[#info]]
                                local default = P.misc.gameBar[info[#info]]
                                return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
                            end,
                            set = function(info, r, g, b, a)
                                local db = E.db.WT.misc.gameBar[info[#info]]
                                db.r, db.g, db.b, db.a = r, g, b, a
                            end
                        }
                    }
                },
                hover = {
                    order = 3,
                    type = "group",
                    name = L["Hover"],
                    inline = true,
                    args = {
                        hoverColor = {
                            order = 1,
                            type = "select",
                            name = L["Mode"],
                            values = {
                                NONE = L["None"],
                                CLASS = L["Class Color"],
                                VALUE = L["Value Color"],
                                CUSTOM = L["Custom"]
                            }
                        },
                        customHoverColor = {
                            order = 2,
                            type = "color",
                            name = L["Custom Color"],
                            hidden = function()
                                return E.db.WT.misc.gameBar.hoverColor ~= "CUSTOM"
                            end,
                            get = function(info)
                                local db = E.db.WT.misc.gameBar[info[#info]]
                                local default = P.misc.gameBar[info[#info]]
                                return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
                            end,
                            set = function(info, r, g, b, a)
                                local db = E.db.WT.misc.gameBar[info[#info]]
                                db.r, db.g, db.b, db.a = r, g, b, a
                            end
                        }
                    }
                }
            }
        },
        time = {
            order = 12,
            type = "group",
            name = L["Time"],
            get = function(info)
                return E.db.WT.misc.gameBar.time[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.misc.gameBar.time[info[#info]] = value
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                },
                localTime = {
                    order = 2,
                    type = "toggle",
                    name = L["Local Time"]
                },
                twentyFour = {
                    order = 3,
                    type = "toggle",
                    name = L["24 Hours"]
                },
                flash = {
                    order = 4,
                    type = "toggle",
                    name = L["Flash"]
                },
                font = {
                    order = 5,
                    type = "group",
                    name = L["Font Setting"],
                    inline = true,
                    get = function(info)
                        return E.db.WT.misc.gameBar.time[info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.misc.gameBar.time[info[#info - 1]][info[#info]] = value
                    end,
                    args = {
                        name = {
                            order = 1,
                            type = "select",
                            dialogControl = "LSM30_Font",
                            name = L["Font"],
                            values = LSM:HashTable("font")
                        },
                        style = {
                            order = 2,
                            type = "select",
                            name = L["Outline"],
                            values = {
                                NONE = L["None"],
                                OUTLINE = L["OUTLINE"],
                                MONOCHROME = L["MONOCHROME"],
                                MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
                                THICKOUTLINE = L["THICKOUTLINE"]
                            }
                        },
                        size = {
                            order = 3,
                            name = L["Size"],
                            type = "range",
                            min = 5,
                            max = 60,
                            step = 1
                        }
                    }
                }
            }
        },
        leftButtons = {
            order = 13,
            type = "group",
            name = L["Left Buttons"],
            get = function(info)
                return E.db.WT.misc.gameBar.left[tonumber(info[#info])]
            end,
            set = function(info, value)
                E.db.WT.misc.gameBar.left[tonumber(info[#info])] = value
            end,
            args = {}
        },
        rightButtons = {
            order = 14,
            type = "group",
            name = L["Right Buttons"],
            get = function(info)
                return E.db.WT.misc.gameBar.right[tonumber(info[#info])]
            end,
            set = function(info, value)
                E.db.WT.misc.gameBar.right[tonumber(info[#info])] = value
            end,
            args = {}
        }
    }
}

do
    local availableButtons = GB:GetAvailableButtons()

    for i = 1, 6 do
        options.gameBar.args.leftButtons.args[tostring(i)] = {
            order = i,
            type = "select",
            name = format(L["Button #%d"], i),
            values = availableButtons
        }

        options.gameBar.args.rightButtons.args[tostring(i)] = {
            order = i,
            type = "select",
            name = format(L["Button #%d"], i),
            values = availableButtons
        }
    end
end

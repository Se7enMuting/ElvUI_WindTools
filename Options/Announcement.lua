local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.announcement.args
local A = W:GetModule("Announcement")

local _G = _G
local format = format

local function ImportantColorString(string)
    return F.CreateColorString(string, {r = 0.204, g = 0.596, b = 0.859})
end

local function FormatDesc(code, helpText)
    return ImportantColorString(code) .. " = " .. helpText
end

options.desc = {
    order = 1,
    type = "group",
    inline = true,
    name = L["Description"],
    args = {
        feature_1 = {
            order = 1,
            type = "description",
            name = L["Announcement module is a tool for help you send messages."],
            fontSize = "medium"
        },
        feature_2 = {
            order = 2,
            type = "description",
            name = L["You can customize the sentence templates, channels, etc."],
            fontSize = "medium"
        },
        feature_3 = {
            order = 3,
            type = "description",
            name = L["Besides the raid spells, it also provides numerous features to help you be a friendly player."],
            fontSize = "medium"
        }
    }
}

options.enable = {
    order = 2,
    type = "toggle",
    get = function(info)
        return E.db.WT.announcement[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.announcement[info[#info]] = value
        A:ProfileUpdate()
    end,
    name = L["Enable"]
}

options.interrupt = {
    order = 3,
    type = "group",
    name = L["Interrupt"],
    get = function(info)
        return E.db.WT.announcement.interrupt[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.announcement.interrupt[info[#info]] = value
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
                    name = L["Send messages after the spell has been interrupted."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"]
        },
        onlyInstance = {
            order = 3,
            type = "toggle",
            name = L["Only Instance"],
            desc = L["Disable announcement in open world."]
        },
        player = {
            order = 4,
            type = "group",
            inline = true,
            name = L["Player(Only you)"],
            get = function(info)
                return E.db.WT.announcement.interrupt[info[#info - 1]][info[#info]]
            end,
            set = function(info, value)
                E.db.WT.announcement.interrupt[info[#info - 1]][info[#info]] = value
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    width = "full"
                },
                text = {
                    order = 2,
                    type = "input",
                    name = L["Text"],
                    desc = format(
                        "%s\n%s\n%s\n%s",
                        FormatDesc("%player%", L["Your name"]),
                        FormatDesc("%target%", L["Target name"]),
                        FormatDesc("%player_spell%", L["Your spell link"]),
                        FormatDesc("%target_spell%", L["Interrupted spell link"])
                    ),
                    width = 2.5
                },
                useDefaultText = {
                    order = 3,
                    type = "execute",
                    name = L["Use default text"],
                    func = function(info)
                        E.db.WT.announcement.interrupt[info[#info - 1]].text =
                            P.announcement.interrupt[info[#info - 1]].text
                    end
                },
                example = {
                    order = 4,
                    type = "description",
                    name = function(info)
                        local message = E.db.WT.announcement.interrupt[info[#info - 1]].text
                        message = gsub(message, "%%player%%", UnitName("player"))
                        message = gsub(message, "%%target%%", L["Sylvanas"])
                        message = gsub(message, "%%player_spell%%", GetSpellLink(31935))
                        message = gsub(message, "%%target_spell%%", GetSpellLink(252150))
                        return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
                    end
                },
                channel = {
                    order = 5,
                    type = "group",
                    inline = true,
                    name = L["Channel"],
                    get = function(info)
                        return E.db.WT.announcement.interrupt[info[#info - 2]][info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.announcement.interrupt[info[#info - 2]][info[#info - 1]][info[#info]] = value
                    end,
                    args = {
                        solo = {
                            order = 1,
                            name = L["Solo"],
                            type = "select",
                            values = {
                                NONE = _G.NONE,
                                SELF = L["Self(Chat Frame)"],
                                EMOTE = _G.EMOTE,
                                YELL = _G.YELL,
                                SAY = _G.SAY
                            }
                        },
                        party = {
                            order = 2,
                            name = L["In Party"],
                            type = "select",
                            values = {
                                NONE = _G.NONE,
                                SELF = L["Self(Chat Frame)"],
                                EMOTE = _G.EMOTE,
                                PARTY = _G.PARTY,
                                YELL = _G.YELL,
                                SAY = _G.SAY
                            }
                        },
                        instance = {
                            order = 3,
                            name = L["In Instance"],
                            type = "select",
                            values = {
                                NONE = _G.NONE,
                                SELF = L["Self(Chat Frame)"],
                                EMOTE = _G.EMOTE,
                                PARTY = _G.PARTY,
                                INSTANCE_CHAT = _G.INSTANCE_CHAT,
                                YELL = _G.YELL,
                                SAY = _G.SAY
                            }
                        },
                        raid = {
                            order = 4,
                            name = L["In Raid"],
                            type = "select",
                            values = {
                                NONE = _G.NONE,
                                SELF = L["Self(Chat Frame)"],
                                EMOTE = _G.EMOTE,
                                PARTY = _G.PARTY,
                                RAID = _G.RAID,
                                YELL = _G.YELL,
                                SAY = _G.SAY
                            }
                        }
                    }
                }
            }
        },
        others = {
            order = 5,
            type = "group",
            inline = true,
            name = L["Other Players"],
            get = function(info)
                return E.db.WT.announcement.interrupt[info[#info - 1]][info[#info]]
            end,
            set = function(info, value)
                E.db.WT.announcement.interrupt[info[#info - 1]][info[#info]] = value
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    width = "full"
                },
                text = {
                    order = 2,
                    type = "input",
                    name = L["Text"],
                    desc = format(
                        "%s\n%s\n%s\n%s",
                        FormatDesc("%player%", L["Name of the player"]),
                        FormatDesc("%target%", L["Target name"]),
                        FormatDesc("%player_spell%", L["The spell link"]),
                        FormatDesc("%target_spell%", L["Interrupted spell link"])
                    ),
                    width = 2.5
                },
                useDefaultText = {
                    order = 3,
                    type = "execute",
                    name = L["Use default text"],
                    func = function(info)
                        E.db.WT.announcement.interrupt[info[#info - 1]].text =
                            P.announcement.interrupt[info[#info - 1]].text
                    end
                },
                example = {
                    order = 4,
                    type = "description",
                    name = function(info)
                        local message = E.db.WT.announcement.interrupt[info[#info - 1]].text
                        message = gsub(message, "%%player%%", UnitName("player"))
                        message = gsub(message, "%%target%%", L["Sylvanas"])
                        message = gsub(message, "%%player_spell%%", GetSpellLink(31935))
                        message = gsub(message, "%%target_spell%%", GetSpellLink(252150))
                        return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
                    end
                },
                channel = {
                    order = 5,
                    type = "group",
                    inline = true,
                    name = L["Channel"],
                    get = function(info)
                        return E.db.WT.announcement.interrupt[info[#info - 2]][info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.announcement.interrupt[info[#info - 2]][info[#info - 1]][info[#info]] = value
                    end,
                    args = {
                        party = {
                            order = 1,
                            name = L["In Party"],
                            type = "select",
                            values = {
                                NONE = _G.NONE,
                                SELF = L["Self(Chat Frame)"],
                                EMOTE = _G.EMOTE,
                                PARTY = _G.PARTY,
                                YELL = _G.YELL,
                                SAY = _G.SAY
                            }
                        },
                        instance = {
                            order = 2,
                            name = L["In Instance"],
                            type = "select",
                            values = {
                                NONE = _G.NONE,
                                PARTY = _G.PARTY,
                                SELF = L["Self(Chat Frame)"],
                                EMOTE = _G.EMOTE,
                                INSTANCE_CHAT = _G.INSTANCE_CHAT,
                                YELL = _G.YELL,
                                SAY = _G.SAY
                            }
                        },
                        raid = {
                            order = 3,
                            name = L["In Raid"],
                            type = "select",
                            values = {
                                NONE = _G.NONE,
                                SELF = L["Self(Chat Frame)"],
                                EMOTE = _G.EMOTE,
                                PARTY = _G.PARTY,
                                RAID = _G.RAID,
                                YELL = _G.YELL,
                                SAY = _G.SAY
                            }
                        }
                    }
                }
            }
        }
    }
}

options.goodbye = {
    order = 6,
    type = "group",
    name = L["Goodbye"],
    get = function(info)
        return E.db.WT.announcement.goodbye[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.announcement.goodbye[info[#info]] = value
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
                    name = L["Say goodbye after dungeon completed."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"]
        },
        delay = {
            order = 3,
            name = L["Delay (sec)"],
            desc = format(L["Default is %s."], P.announcement.goodbye.delay),
            type = "range",
            min = 0,
            max = 20,
            step = 1
        },
        text = {
            order = 4,
            type = "input",
            name = L["Text"],
            width = 2.5
        },
        useDefaultText = {
            order = 5,
            type = "execute",
            func = function(info)
                E.db.WT.announcement.goodbye.text = P.announcement.goodbye.text
            end,
            name = L["Default Text"]
        },
        channel = {
            order = 6,
            name = L["Channel"],
            type = "group",
            inline = true,
            get = function(info)
                return E.db.WT.announcement.goodbye[info[#info - 1]][info[#info]]
            end,
            set = function(info, value)
                E.db.WT.announcement.goodbye[info[#info - 1]][info[#info]] = value
            end,
            args = {
                party = {
                    order = 1,
                    name = L["In Party"],
                    type = "select",
                    values = {
                        NONE = _G.NONE,
                        EMOTE = _G.EMOTE,
                        PARTY = _G.PARTY,
                        YELL = _G.YELL,
                        SAY = _G.SAY
                    }
                },
                instance = {
                    order = 2,
                    name = L["In Instance"],
                    type = "select",
                    values = {
                        NONE = _G.NONE,
                        EMOTE = _G.EMOTE,
                        PARTY = _G.PARTY,
                        INSTANCE_CHAT = _G.INSTANCE_CHAT,
                        YELL = _G.YELL,
                        SAY = _G.SAY
                    }
                },
                raid = {
                    order = 3,
                    name = L["In Raid"],
                    type = "select",
                    values = {
                        NONE = _G.NONE,
                        EMOTE = _G.EMOTE,
                        PARTY = _G.PARTY,
                        RAID = _G.RAID,
                        YELL = _G.YELL,
                        SAY = _G.SAY
                    }
                }
            }
        }
    }
}

options.thanksForResurrection = {
    order = 6,
    type = "group",
    name = L["Thanks For Resurrection"],
    get = function(info)
        return E.db.WT.announcement.thanksForResurrection[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.announcement.thanksForResurrection[info[#info]] = value
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
                    name = L["Say thanks to the target who resurrected you."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"]
        },
        delay = {
            order = 3,
            name = L["Delay (sec)"],
            desc = format(L["Default is %s."], P.announcement.thanksForResurrection.delay),
            type = "range",
            min = 0,
            max = 20,
            step = 1
        },
        soulstone = {
            order = 4,
            type = "group",
            inline = true,
            name = GetSpellInfo(20707),
            args = {
                soulstoneText = {
                    order = 1,
                    type = "input",
                    name = L["Text"],
                    desc = format(
                        "%s\n%s\n%s",
                        FormatDesc("%player%", L["Your name"]),
                        FormatDesc("%target%", L["Target name"]),
                        FormatDesc("%spell%", L["The spell link"])
                    ),
                    width = 2.5
                },
                useDefaultText = {
                    order = 2,
                    type = "execute",
                    func = function()
                        E.db.WT.announcement.thanksForResurrection.soulstoneText =
                            P.announcement.thanksForResurrection.soulstoneText
                    end,
                    name = L["Default Text"]
                },
                example = {
                    order = 3,
                    type = "description",
                    name = function()
                        local message = E.db.WT.announcement.thanksForResurrection.soulstoneText
                        message = gsub(message, "%%player%%", UnitName("player"))
                        message = gsub(message, "%%target%%", L["Sylvanas"])
                        message = gsub(message, "%%spell%%", GetSpellLink(61999))
                        return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n"
                    end
                }
            }
        },
        normal = {
            order = 5,
            type = "group",
            inline = true,
            name = L["Other Spells"],
            args = {
                normalText = {
                    order = 1,
                    type = "input",
                    name = L["Text"],
                    desc = format(
                        "%s\n%s\n%s",
                        FormatDesc("%player%", L["Your name"]),
                        FormatDesc("%target%", L["Target name"]),
                        FormatDesc("%spell%", L["The spell link"])
                    ),
                    width = 2.5
                },
                useDefaultText = {
                    order = 2,
                    type = "execute",
                    func = function()
                        E.db.WT.announcement.thanksForResurrection.normalText =
                            P.announcement.thanksForResurrection.normalText
                    end,
                    name = L["Default Text"]
                },
                example = {
                    order = 3,
                    type = "description",
                    name = function()
                        local message = E.db.WT.announcement.thanksForResurrection.normalText
                        message = gsub(message, "%%player%%", UnitName("player"))
                        message = gsub(message, "%%target%%", L["Sylvanas"])
                        message = gsub(message, "%%spell%%", GetSpellLink(61999))
                        return "\n" .. ImportantColorString(L["Example"], db) .. ": " .. message .. "\n"
                    end
                }
            }
        },
        channel = {
            order = 6,
            name = L["Channel"],
            type = "group",
            inline = true,
            get = function(info)
                return E.db.WT.announcement.thanksForResurrection[info[#info - 1]][info[#info]]
            end,
            set = function(info, value)
                E.db.WT.announcement.thanksForResurrection[info[#info - 1]][info[#info]] = value
            end,
            args = {
                solo = {
                    order = 1,
                    name = L["Solo"],
                    type = "select",
                    values = {
                        NONE = _G.NONE,
                        WHISPER = _G.WHISPER,
                        SELF = L["Self(Chat Frame)"],
                        EMOTE = _G.EMOTE,
                        YELL = _G.YELL,
                        SAY = _G.SAY
                    }
                },
                party = {
                    order = 2,
                    name = L["In Party"],
                    type = "select",
                    values = {
                        NONE = _G.NONE,
                        WHISPER = _G.WHISPER,
                        SELF = L["Self(Chat Frame)"],
                        EMOTE = _G.EMOTE,
                        PARTY = _G.Party,
                        YELL = _G.YELL,
                        SAY = _G.SAY
                    }
                },
                instance = {
                    order = 3,
                    name = L["In Instance"],
                    type = "select",
                    values = {
                        NONE = _G.NONE,
                        WHISPER = _G.WHISPER,
                        SELF = L["Self(Chat Frame)"],
                        EMOTE = _G.EMOTE,
                        PARTY = _G.Party,
                        INSTANCE_CHAT = _G.INSTANCE_CHAT,
                        YELL = _G.YELL,
                        SAY = _G.SAY
                    }
                },
                raid = {
                    order = 4,
                    name = L["In Raid"],
                    type = "select",
                    values = {
                        NONE = _G.NONE,
                        WHISPER = _G.WHISPER,
                        SELF = L["Self(Chat Frame)"],
                        EMOTE = _G.EMOTE,
                        PARTY = _G.Party,
                        RAID = _G.RAID,
                        YELL = _G.YELL,
                        SAY = _G.SAY
                    }
                }
            }
        }
    }
}

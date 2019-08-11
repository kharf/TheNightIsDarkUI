

    local _, ns = ...

    local i = 1
    local j = {}
    local k = false

    local _, class = UnitClass'player'
	local colour = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]

    local menu = CreateFrame('Frame', 'modui_elementsmenu', menu)
    menu:SetSize(500, 460)
    menu:SetBackdrop(
        {
            bgFile   = [[Interface\Tooltips\UI-Tooltip-Background]],
            edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
            insets   = {left = 11, right = 12, top = 12, bottom = 11}
        }
    )
    menu:SetBackdropColor(0, 0, 0, 1)
    menu:SetPoint('CENTER', UIParent, 0, 50)
    menu:Hide()
    tinsert(ns.skinb, menu)

    menu.elementcontainer = CreateFrame('Frame', 'modui_elementscontainer', menu)
    menu.elementcontainer:SetSize(380, 330)
    menu.elementcontainer:SetPoint('TOP', menu, 0, -70)
    ns.BD(menu.elementcontainer)

    menu.elementscrollframe = CreateFrame('ScrollFrame', 'modui_elementscrollframe', menu.elementcontainer, 'UIPanelScrollFrameTemplate')
	menu.elementscrollframe:SetFrameLevel(3)
	menu.elementscrollframe:SetPoint('TOPLEFT', menu.elementcontainer, 7, -7)
	menu.elementscrollframe:SetPoint('BOTTOMRIGHT', -35, 7)
    menu.elementscrollframe:Raise()
    menu.elementscrollframe:SetToplevel()

    menu.inner = CreateFrame('Frame', nil, menu.elementscrollframe)
	menu.inner:SetSize(335, 560)
	menu.inner:EnableMouse(true)
	menu.inner:EnableMouseWheel(true)

    menu.x = CreateFrame('Button', 'modui_elementsCloseButton', menu, 'UIPanelCloseButton')
    menu.x:SetPoint('TOPRIGHT', -6, -6)
    menu.x:SetScript('OnClick', function() menu:Hide() end)

    menu.reload = CreateFrame('Button', 'modui_optionsreload', menu, 'UIPanelButtonTemplate')
    menu.reload:SetSize(100, 20)
    menu.reload:SetText'Reload UI'
    menu.reload:SetPoint('BOTTOMRIGHT', menu, -20, 15)
    menu.reload:Hide()
    menu.reload:SetScript('OnClick', ReloadUI)

    menu.reload.description = menu.reload:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
    menu.reload.description:SetPoint('RIGHT', menu.reload, 'LEFT', -10, -1)
    menu.reload.description:SetText'Your new settings require a UI reload to take effect.'

    menu.elementscrollframe.content = menu.inner
    menu.elementscrollframe:SetScrollChild(menu.inner)

    menu.header = menu:CreateTexture(nil, 'ARTWORK')
    menu.header:SetSize(256, 64)
    menu.header:SetPoint('TOP', menu, 0, 12)
    menu.header:SetTexture[[Interface\DialogFrame\UI-DialogBox-Header]]
    tinsert(ns.skin, menu.header)

    menu.header.t = menu:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
    menu.header.t:SetPoint('TOP', menu.header, 0, -14)
    menu.header.t:SetText'modui Elements'

    menu.header.f = CreateFrame('Button', 'modui_optionsheader', menu)
    menu.header.f:SetAllPoints(menu.header.t)
    menu.header.f:SetFrameLevel(menu:GetFrameLevel() + 1)

    local ShowReload = function()
        menu.reload:Show()
    end

    local UpdateAllCheckButtons = function(checked)
        for  _, v in pairs(j) do
            if  checked then
                v:SetChecked(true)
            else
                v:SetChecked(false)
            end
        end
    end

    local AllOnClick = function(self)
        if  self:GetChecked() then
            MODUI_VAR['elements'].all = true
            MODUI_VAR['elements']['aura'].enable = true
            MODUI_VAR['elements']['unit'].enable = true
            UpdateAllCheckButtons(true)
        else
            MODUI_VAR['elements'].all = false
            MODUI_VAR['elements']['aura'].enable = false
            MODUI_VAR['elements']['unit'].enable = false
            UpdateAllCheckButtons(false)
        end
        ShowReload()
    end

    menu.masterswitch = CreateFrame('CheckButton', 'modui_checkbuttonMasterSwitch', menu, 'UICheckButtonTemplate')
    menu.masterswitch:SetSize(19, 19)
    menu.masterswitch:SetPoint('BOTTOMLEFT', menu.elementcontainer, 'TOPLEFT', 33, 10)
    menu.masterswitch:SetChecked(MODUI_VAR['elements']['all'] and true or false)
    menu.masterswitch:SetScript('OnClick', AllOnClick)

    menu.masterswitch.t = _G[menu.masterswitch:GetName()..'Text']
    menu.masterswitch.t:SetJustifyH'LEFT'
    menu.masterswitch.t:SetWidth(330)
    menu.masterswitch.t:SetPoint('LEFT', menu.masterswitch, 'RIGHT', 4, 0)
    menu.masterswitch.t:SetText('Toggle All |c'..colour.colorStr..'modui|r Elements.    |cffff0000Note: Overrides Selections.|r')

    local ToggleChildButton = function(self, table)
        if  self:GetChecked() then
            for _, v in pairs(table) do
                v:Enable()
            end
        else
            for _, v in pairs(table) do
                v:Disable()
            end
        end
    end

    local add = function(name, func, checked, r, g, b, inset, enable)
		local bu = CreateFrame('CheckButton', 'modui_checkbutton'..i, menu.inner, 'UICheckButtonTemplate')
        bu:SetSize(19, 19)
        bu:SetPoint('TOPLEFT',
            i == 1 and menu.inner or _G['modui_checkbutton'..(i - 1)],
            i == 1 and 'TOPLEFT' or 'BOTTOMLEFT',
            i == 1 and 5 or ((k and inset) and 0 or k and -20 or inset and 20 or 0),
            i == 1 and -5 or ((k and inset) and 0 or (k or inset) and -5 or 0)
        )
        bu:SetChecked(checked)
        bu:SetScript('OnClick', func)

        _G[bu:GetName()..'Text']:SetJustifyH'LEFT'
        _G[bu:GetName()..'Text']:SetWidth(270)
        _G[bu:GetName()..'Text']:SetPoint('LEFT', bu, 'RIGHT', 4, 0)
        _G[bu:GetName()..'Text']:SetText(name)
        _G[bu:GetName()..'Text']:SetTextColor(r, g, b)

        if  enable then
            bu:Enable()
        else
            bu:Disable()
        end

        i = i + 1
        tinsert(j, bu)
        k = inset and true or false
        --print(name, inset, k)
	end

    local AddMenu = function()
        add(
            'Actionbar',
            function(self)
                MODUI_VAR['elements']['mainbar'].enable = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['mainbar'].enable and true or false,
            1, .8, 0,
            nil,
            true
        )
        add(
            'Aura',
            function(self)
                MODUI_VAR['elements']['aura'].enable = self:GetChecked() and true or false
                ShowReload()
                ToggleChildButton(
                    self,
                    {
                        _G['modui_checkbutton3'],
                        _G['modui_checkbutton4']
                    }
                )
            end,
            MODUI_VAR['elements']['aura'].enable and true or false,
            1, .8, 0,
            nil,
            true
        )
        add(
            'Statusbars on Auras',
            function(self)
                MODUI_VAR['elements']['aura'].statusbars = self:GetChecked() and true or false
            end,
            MODUI_VAR['elements']['aura'].statusbars and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['aura'].enable and true or false
        )
        add(
            'Custom Value Formatting on Auras',
            function(self)
                MODUI_VAR['elements']['aura'].values = self:GetChecked() and true or false
            end,
            MODUI_VAR['elements']['aura'].values and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['aura'].enable and true or false
        )
        add(
            'Chat',
            function(self)
                MODUI_VAR['elements']['chat'].enable = self:GetChecked() and true or false
                ShowReload()
                ToggleChildButton(
                    self,
                    {
                        _G['modui_checkbutton6'],
                        _G['modui_checkbutton7'],
                        _G['modui_checkbutton8'],
                    }
                )
            end,
            MODUI_VAR['elements']['chat'].enable and true or false,
            1, .8, 0,
            nil,
            true
        )
        add(
            'Events & Custom Chat Text',
            function(self)
                MODUI_VAR['elements']['chat'].events = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['chat'].events and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['chat'].enable and true or false
        )
        add(
            'Chat Style',
            function(self)
                MODUI_VAR['elements']['chat'].style = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['chat'].style and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['chat'].enable and true or false
        )
        add(
            'URLs',
            function(self)
                MODUI_VAR['elements']['chat'].url = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['chat'].url and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['chat'].enable and true or false
        )
        add(
            'Inventory',
            function(self)
                MODUI_VAR['elements']['onebag'].enable = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['onebag'].enable and true or false,
            1, .8, 0,
            nil,
            true
        )
        add(
            'Button For Selling Grey Items at Vendor',
            function(self)
                MODUI_VAR['elements']['onebag'].greys = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['onebag'].greys and true or false,
            1, 1, 1,
            true,
            true
        )
        add(
            'Enemy Castbars',
            function(self)
                MODUI_VAR['elements']['ecastbar'].enable = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['ecastbar'].enable and true or false,
            1, .8, 0,
            nil,
            true
        )
        add(
            'Nameplates',
            function(self)
                MODUI_VAR['elements']['nameplate'].enable = self:GetChecked() and true or false
                ShowReload()
                ToggleChildButton(
                    self,
                    {
                        _G['modui_checkbutton13'],
                        _G['modui_checkbutton14'],
                        _G['modui_checkbutton15'],
                        _G['modui_checkbutton16'],
                    }
                )
            end,
            MODUI_VAR['elements']['nameplate'].enable and true or false,
            1, .8, 0,
            nil,
            true
        )
        add(
            'Show Auras on Nameplates (Note: offline)',
            function(self)
                MODUI_VAR['elements']['nameplate'].aura = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['nameplate'].aura and true or false,
            1, 1, 1,
            true,
            false
        )
        add(
            'Show Combo Points on Nameplate',
            function(self)
                MODUI_VAR['elements']['nameplate'].combo = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['nameplate'].combo and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['nameplate'].enable and true or false
        )
        add(
            'Class Colours on Friendly Nameplates',
            function(self)
                MODUI_VAR['elements']['nameplate'].friendlyclass = self:GetChecked() and true or false
            end,
            MODUI_VAR['elements']['nameplate'].friendlyclass and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['nameplate'].enable and true or false
        )
        add(
            'Icon-based Nameplates for Totems',
            function(self)
                MODUI_VAR['elements']['nameplate'].totem = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['nameplate'].totem and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['nameplate'].enable and true or false
        )
        add(
            'Quest Tracker (Click-through to Quest Log)',
            function(self)
                MODUI_VAR['elements']['tracker'].enable = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['tracker'].enable and true or false,
            1, .8, 0,
            nil,
            true
        )
        add(
            'Tooltip',
            function(self)
                MODUI_VAR['elements']['tooltip'].enable = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['tooltip'].enable and true or false,
            1, .8, 0,
            nil,
            true
        )
        add(
            'Unitframes',
            function(self)
                MODUI_VAR['elements']['unit'].enable = self:GetChecked() and true or false
                ShowReload()
                ToggleChildButton(
                    self,
                    {
                        _G['modui_checkbutton20'],
                        _G['modui_checkbutton21'],
                        _G['modui_checkbutton22'],
                        _G['modui_checkbutton23'],
                        _G['modui_checkbutton24'],
                        _G['modui_checkbutton25'],
                        _G['modui_checkbutton26'],
                    }
                )
            end,
            MODUI_VAR['elements']['unit'].enable and true or false,
            1, .8, 0,
            nil,
            true
        )
        add(
            'Player',
            function(self)
                MODUI_VAR['elements']['unit'].player = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['unit'].player and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['unit'].enable and true or false
        )
        add(
            'Target',
            function(self)
                MODUI_VAR['elements']['unit'].target = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['unit'].target and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['unit'].enable and true or false
        )
        add(
            'Party',
            function(self)
                MODUI_VAR['elements']['unit'].party = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['unit'].party and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['unit'].enable and true or false
        )
        add(
            'Target of Target',
            function(self)
                MODUI_VAR['elements']['unit'].tot = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['unit'].tot and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['unit'].enable and true or false
        )
        add(
            'Pet',
            function(self)
                MODUI_VAR['elements']['unit'].pet = self:GetChecked() and true or false
                ShowReload()
            end,
             MODUI_VAR['elements']['unit'].pet and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['unit'].enable and true or false
        )
        add(
            'Value Colours on Text',
            function(self)
                MODUI_VAR['elements']['unit'].vcolour = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['unit'].vcolour and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['unit'].enable and true or false
        )
        add(
            'Elite/Rare Dragons in Colour (for dark theme UIs)',
            function(self)
                MODUI_VAR['elements']['unit'].rcolour = self:GetChecked() and true or false
                ShowReload()
            end,
            MODUI_VAR['elements']['unit'].rcolour and true or false,
            1, 1, 1,
            true,
            MODUI_VAR['elements']['unit'].enable and true or false
        )
    end

    local OnEvent = function(self, event, addon)
        AddMenu()
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'VARIABLES_LOADED'
    e:SetScript('OnEvent', OnEvent)


    --
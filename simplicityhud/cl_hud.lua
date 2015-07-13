////////////////////////////////////////////////////////////////
//   Author: Triage                                            /
//   Addon: Simplicity hud                                     /
//   Version: 0.15                                             /
////////////////////////////////////////////////////////////////

ply = LocalPlayer()


local hideDarkRPElements = {
  ["DarkRP_LocalPlayerHUD"] = false,
}

local hideDefaultHud = {
  //Hide all of default VGUI
  CHudHealth = true,
  CHudBattery = true
}

local function HideHudElements( name )
  if ( hideDefaultHud [ name ] ) then return false end
  if ( hideDarkRPElements [ name ] ) then return false end
end
hook.Add( "HUDShouldDraw", "HideAllHuds", HideHudElements )

//All of the colors used in the hud
local hudcolors = {
  sidebar = Color( 255, 69, 69, 255 ),
  background_white = Color( 255, 255, 255, 255 ),
  background_grey = Color( 210, 210, 210, 255 ),
  text_black = Color( 24, 24, 24, 255 ),
  text_white = Color( 255, 255, 255, 255 ),
  health_bar = Color( 255, 69, 69, 255 ),
  armor_bar = Color( 34, 6, 255, 255 )
}

// Custom fonts
surface.CreateFont( "Positions", {font = "Arial", size = 15, weight = 600} )
surface.CreateFont( "PlayerName", {font = "Arial", size = 22, weight = 500} )
surface.CreateFont( "Money", {font = "Arial", size = 15, weight = 600} )


local function SimpleFrame()
  draw.RoundedBox( 0, 35, 880, 380, 180, hudcolors.background_white ) --White background
  draw.RoundedBox( 0, 35, 880, 50, 180, hudcolors.sidebar ) --Red right panel
  draw.RoundedBox( 0, 105, 907, 104, 104, hudcolors.background_grey ) --Background behind avatar image
  draw.RoundedBox( 0, 240, 907, 150, 40, hudcolors.background_grey ) --Money backgorund
  draw.RoundedBox( 0, 240, 967, 150, 15, hudcolors.background_grey ) -- Health background bar
  draw.RoundedBox( 0, 240, 997, 150, 15, hudcolors.background_grey ) --Armor background Bar
end

local function GetInformation()
  local playerNick = LocalPlayer():Nick()
  local playerTeam = team.GetName( ply:Team() )
  local playerMoney = LocalPlayer():getDarkRPVar( "money" )
  local playerSalary = LocalPlayer():getDarkRPVar( "salary" )

  local userIcon = "icon16/user.png"
  local adminIcon = "icon16/shield.png"
  local hasLicense = "icon16/page.png"
  local noLicense = "icon16/page_delete.png"

  draw.SimpleText( playerNick, "Positions", 156, 887.5, hudcolors.text_black, TEXT_ALIGN_CENTER )
  draw.SimpleText( playerTeam, "Positions", 156, 1014, hudcolors.text_black, TEXT_ALIGN_CENTER )
  draw.SimpleText( "Money:", "Money", 242, 910, hudcolors.text_black )
  draw.SimpleText( DarkRP.formatMoney( playerMoney ), "Money", 290, 910, hudcolors.text_black )
  draw.SimpleText( "Salary:", "Money", 242, 929, hudcolors.text_black )
  draw.SimpleText( DarkRP.formatMoney( playerSalary ), "Money", 290, 929, hudcolors.text_black )


  if ply:IsUserGroup( "user" ) then
    draw.SimpleText(  "User", "Positions", 156, 1034, hudcolors.text_black, TEXT_ALIGN_CENTER )
    surface.SetMaterial( Material( userIcon ) )
    surface.DrawTexturedRect( 378, 1040, 16, 16 )
  elseif ply:IsUserGroup( "operator" ) then
    draw.SimpleText(  "Operator", "Positions", 156, 1034, hudcolors.text_black, TEXT_ALIGN_CENTER )
    surface.SetMaterial( Material( adminIcon ) )
    surface.DrawTexturedRect( 378, 1040, 16, 16 )
  elseif ply:IsUserGroup( "admin" ) then
    draw.SimpleText(  "Admin", "Positions", 156, 1034, hudcolors.text_black, TEXT_ALIGN_CENTER )
    surface.SetMaterial( Material( adminIcon ) )
    surface.DrawTexturedRect( 378, 1040, 16, 16 )
  elseif ply:IsUserGroup( "superadmin" ) then
    draw.SimpleText(  "Super Admin", "Positions", 156, 1034, hudcolors.text_black, TEXT_ALIGN_CENTER )
    surface.SetMaterial( Material( adminIcon ) )
    surface.DrawTexturedRect( 378, 1040, 16, 16 )
  elseif ply:IsUserGroup( "developer" ) then
    draw.SimpleText(  "Developer", "Positions", 156, 1034, hudcolors.text_black, TEXT_ALIGN_CENTER )
    surface.SetMaterial( Material( adminIcon ) )
    surface.DrawTexturedRect( 378, 1040, 16, 16 )
  else
    draw.SimpleText(  "No Rank", "Positions", 156, 1034, hudcolors.text_black, TEXT_ALIGN_CENTER )
  end

  if ply:getDarkRPVar("HasGunlicense") then
    surface.SetMaterial( Material( hasLicense ) )
    surface.DrawTexturedRect( 397, 1042, 16, 16 )
  else
    surface.SetMaterial( Material( noLicense ) )
    surface.DrawTexturedRect( 397, 1042, 16, 16 )
  end
end

local function Vitals()
  local playerHealth = LocalPlayer():Health()
  local playerArmor = LocalPlayer():Armor()
  local maxHealth = LocalPlayer():GetMaxHealth()
  local playedSound = surface.PlaySound( "HL1/fvox/armor_gone.wav" )
  local maxArmor = 100
  local maxWidth = 150
  local hw = playerHealth / maxHealth * maxWidth -- Do not touch this equation. If you want to change the width, do so with the above variable. Same goes for the other variable below
  local aw = playerArmor / 100 * maxWidth

  draw.RoundedBox( 0, 240, 967, hw, 15, hudcolors.health_bar ) -- Health Bar
  draw.RoundedBox( 0, 240, 997, aw, 15, hudcolors.armor_bar ) -- Armor Bar

  if ply:Alive() then
    draw.SimpleText( playerHealth, "Default", 313, 968, hudcolors.text_white, TEXT_ALIGN_CENTER ) -- Health Value
  else
    draw.SimpleText( "You're Dead!", "Default", 313, 968, hudcolors.text_white, TEXT_ALIGN_CENTER ) -- Dead Value
  end

  if playerArmor == 0 then
    draw.SimpleText( "Armor Depleted", "Default", 313, 998, hudcolors.text_white, TEXT_ALIGN_CENTER ) -- Armor Depleted
  else
    draw.SimpleText( playerArmor, "Default", 313, 998, hudcolors.text_white, TEXT_ALIGN_CENTER ) -- Armor Value
  end
end

// Draw all of our elements
local function DrawVGUI()
  SimpleFrame()
  GetInformation()
  Vitals()
end
hook.Add( "HUDPaint", "SimplictyHUD", DrawVGUI )


// Draw outside of hook for FPS reasons
hook.Add( "HUDPaint", "playerModel", function()
  local ply = LocalPlayer()
  local model = ply:GetModel()

  if !IsValid( ply ) then return end

  if !playerModel || !ispanel( playerModel ) then
    playerModel = vgui.Create( "DModelPanel" )
    playerModel:SetSize( 90, 90 )
    playerModel:SetPos( 116, 914 )
    playerModel:SetModel( model )
    playerModel.Model = model
    function playerModel:LayoutEntity( Entity ) return end
  end

  local headpos = playerModel.Entity:GetBonePosition( playerModel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
    playerModel:SetLookAt( headpos )
    playerModel:SetCamPos( headpos-Vector( -15, 5, 0 ) )
    playerModel.Entity:SetEyeTarget( headpos-Vector( -15, 0, 0 ) )

  if ply:GetModel() != playerModel.Model then
    playerModel:SetModel( model )
    playerModel.Model = model
  end
end)

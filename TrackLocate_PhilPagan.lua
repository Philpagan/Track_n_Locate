local lastTime = 0
local time
local LaAd = "N/A" --latitudePilot en degrés
local LaAr -- idem en radians
local LoAd = "N/A" --longitudePilot en degrés
local LoAr -- idem en radians
local LaBd = "N/A" --latitudeRacer en degrés
local LaBr -- idem en radians
local LoBd = "N/A" --longitudeRacer en degrés
local LoBr -- idem en radians
local CoordOk = false -- indique que les coordonnées GPS sont présentes et correctes et donc, que le racer est en bon ordre de vol, avec transmission de données télémétriques
local ACTd --angle centre terrestre en degrés
local ACTr -- idem en radians
local Dist = "N/A" --distance entre A et B, en mètres
local DistT = "N/A" -- Dist + commentaires
local Altitude = "N/A" --altitude en m : absolue avant décollage, puis relative ensuite
local nbSats = "N/A" --nbre de satellites
local Capd = "N/A" --cap en degrés
local Capr -- idem en radians
local CapNWSE = "N/A"
local TabCapsNWSE={"N","NNW","NW","WNW","W","WSW","SW","SSW","S","SSE","SE","ESE","E","ENE","NE","NNE","N"} -- CapNWSE
local TabCapsDeg={349,326,304,281,259,236,214,191,169,146,124,101,79,56,34,11,0} -- Capd min correspondant
local FlagDisplayMain = true -- indique si on affiche l'écran principal ou l'écran secondaire des coordonnées GPS brutes
local gpsId
local gpsTable
local RecFile = "./SCRIPTS/TELEMETRY/TrkLoc.txt" -- fichier d'enregistrement des dernières coord GPS valides
local var1

function rnd(num,	decimals) -- si besoin, non utilisé ici
		local	mult	=	10^(decimals	or	0)
		return	math.floor(num	*	mult	+	0.5)	/	mult
end

function getGPS() -- récupération des données GPS 
    gpsTable = getValue(gpsId)
    if (type(gpsTable) == "table") then
        LaAd = gpsTable["pilot-lat"]
        LoAd = gpsTable["pilot-lon"]
        LaBd = gpsTable["lat"]
        LoBd = gpsTable["lon"]
        if LaAd ~= nil and LaAd ~= 1 and LoAd ~= nil and LoAd ~= 1 and LaBd ~= nil and LaBd ~= 1 and LoBd ~= nil and LoBd ~= 1 then
            -- cas de valeurs = 1 : constaté en live, décrochage de la réception GPS ? A filtrer donc vu qu'on vole rarement au-dessus de l'Atlantique dans le Golfe de Guinée :)
            CoordOk = true
        else
            CoordOk = false
        end
    else
        CoordOk = false
    end
end

function processGpsHeadingDistance() --traitement des coordonnées, calcul du cap et de la distance
    if CoordOk then
        LaAr = math.rad(LaAd)
        LoAr = math.rad(LoAd)
        LaBr = math.rad(LaBd)
        LoBr = math.rad(LoBd)
        -- Détermination du cap en degrés
        Capr = math.atan(math.cos(LaBr)* math.sin(LoBr-LoAr)/(math.cos(LaAr) * math.sin(LaBr)-math.sin(LaAr)*math.cos(LaBr)*math.cos(LoBr-LoAr)))
        Capd = math.floor(math.deg(Capr)) -- avant correction 180° éventuelle
        -- correction éventuelle
        if LaAr>LaBr then
            Capd=Capd+180
        elseif LoAr<LoBr then
            Capd = Capd
        else
            Capd = Capd + 360
        end
        -- détermination du cap en NWSE
        for i=1,17 do
            if Capd >= TabCapsDeg[i] then
                CapNWSE = TabCapsNWSE[i]
                break
            end
        end
        
        -- détermination de la distance  
        ACTr=math.acos(math.sin(LaAr)*math.sin(LaBr)+math.cos(LaAr)*math.cos(LaBr)*math.cos(LoBr-LoAr))
        ACTd=math.deg(ACTr)
        Dist= math.floor(1852*60*ACTd)
        
    else
        -- on en fait surtout rien : mémorisation des données en cas de perte de retour télémétrie    
    end
end

function displayMain212x64() -- affichage pour X9D X9D+
    -- moitié gauche de l'écran
    lcd.drawText(1,6,"GPS",INVERS)
    lcd.drawText(30,6,nbSats.." Sats",0)
    lcd.drawText(1,28,"DIRECTION",INVERS)
    lcd.drawText(1,50,"ALTITUDE",INVERS)
    
    essai = getValue("Alt")
    -- moitié droite de l'écran
    lcd.drawText(80,6,"Lat : "..LaBd,0)
    lcd.drawText(80,16,"Lon : "..LoBd,0)
    lcd.drawText(80,28,"Dist : "..Dist.." m",0)
    lcd.drawText(80,38,"Cap : "..CapNWSE.." au "..Capd,0)
    lcd.drawText(80,50,"Relative : "..Altitude.." m",0)
end

function displayMain128x64() -- affichage pour X7, Tango2, Xlite
    -- moitié gauche de l'écran
    lcd.drawText(1,1,"GPS",INVERS)
    lcd.drawText(3,11,nbSats.." Sats",0)
    lcd.drawText(1,23,"DIR",INVERS)
    lcd.drawText(1,45,"ALT",INVERS)
    
    essai = getValue("Alt")
    -- moitié droite de l'écran
    lcd.drawText(45,1,"Lat : "..LaBd,0)
    lcd.drawText(45,11,"Lon : "..LoBd,0)
    lcd.drawText(45,23,"Dist : "..Dist.." m",0)
    lcd.drawText(45,33,"Cap : "..CapNWSE.." au "..Capd,0)
    lcd.drawText(45,45,"Relative : "..Altitude.." m",0)
end

function displayCoordOnly212x64() -- affichage des coord GPS seulement (pour capture par Google Lens)
    local str1 = readCoordSD()
    local str2
    local str3
    if CoordOk  then
        str3 = "Localisation actuelle"
        str2 = LaBd .. "," .. LoBd
    else
        str3 = "Localisation enregistree"
        str2 = str1
    end
    lcd.drawText(20,1,str3,0)
    lcd.drawText(20,24,str2,DBLSIZE)
end

function displayCoordOnly128x64() -- affichage des coord GPS seulement (pour capture par Google Lens)
    local str1 = readCoordSD()
    local str2
    local str3
    if CoordOk  then
        str3 = "Localisation actuelle"
        str2 = LaBd .. "," .. LoBd
    else
        str3 = "Localisation enregistree"
        str2 = str1
    end
    lcd.drawText(2,1,str3,0)
    lcd.drawText(2,26,str2,MIDSIZE)
end

function recCoord2SD() -- enregistrement des coord GPS sur SD
    local file = io.open(RecFile,"w") --efface les données existantes
    local str1
    str1 = LaBd .. "," .. LoBd
    io.write(file,str1)
    io.close(file)
end

function readCoordSD() -- lecture des coord GPS sur SD
    local file = io.open(RecFile,"r")
    local str1 = io.read(file,100)
    io.close(file)
    return str1
end

local function init() -- is  called  once  when  model  is  loaded
    
	-- Récupération de l'identifiant du capteur GPS
	local fieldinfo = getFieldInfo("GPS")
	gpsId = fieldinfo['id']
    
end

local function background() -- is  called  periodically  (always,  the  screen  visibility  does  not  matter)
    
	time = getTime()
    
    -- Acquisition des données toutes les 500ms
    if time > lastTime + 50 then
        lastTime = time
        
        -- Lecture des données GPS
        nbSats = getValue("Sats")
        getGPS()

        -- sauvegardes sur SD
        if CoordOk then
            recCoord2SD()
        end

        -- Lecture altitude
        var1 = getValue("Alt")
        if var1 ~= 0 then -- si pas de retour de télémétrie, getValue retourne une valeur nulle
            Altitude = getValue("Alt")
        end
    end 
    
end

local function run(event) -- is called periodically when custom telemetry screen is visible

    -- traitement GPS, Cap, Distance
    processGpsHeadingDistance()

    -- choix de l'affichage sur "Meny key long press" : toggle écran principal / écran secondaire
    if event == EVT_MENU_LONG then
        FlagDisplayMain = not FlagDisplayMain
    end

    -- AFFICHAGE
    lcd.clear()

    if LCD_W > 128 then
        if FlagDisplayMain then
            displayMain212x64()
        else
            displayCoordOnly212x64()
        end
    else
        if FlagDisplayMain then
            displayMain128x64()
        else
            displayCoordOnly128x64()
        end
    end

end
  
return { init=init, background=background, run=run }
local playlist_file = "clasica.m3u"
local titles = {}

local function cargar_titulos()
    local f = io.open(playlist_file, "r")
    if not f then return end
    local ultimo_titulo = nil
    for line in f:lines() do
        local t = line:match("^#EXTINF:%-?%d+,(.*)$")
        if t then
            ultimo_titulo = t
        elseif line:match("^https?://") then
            titles[line] = ultimo_titulo
            ultimo_titulo = nil
        end
    end
    f:close()
end

cargar_titulos()

mp.register_event("file-loaded", function()
    local url = mp.get_property("path")
    local titulo = titles[url]
    io.write((titulo or mp.get_property("media-title") or "") .. "\n")
    io.flush()
end)

local function mostrar_ayuda()
    io.write("  + Pausar: p\n")
    io.write("  + Reanudar: p\n")
    io.write("  + Pista siguiente: >\n")
    io.write("  + Pista anterior: <\n")
    io.write("  + Parar del todo: q\n")
    io.write("  + Orden aleatorio: z\n")
    io.write("  + Orden original: Z\n")
    io.write("  + Mostrar esta ayuda: h\n\n")
    io.flush()
end

mp.add_key_binding("h", "mostrar-ayuda", mostrar_ayuda)

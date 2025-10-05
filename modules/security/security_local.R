# modules/security/security_local.R/mod_security_local_ui
mod_security_local_ui <- function(id) {
  # Cria um namespace para este módulo
  ns <- NS(id)
  
  tabItem(
    tabName = "security_local",
    # =============
    # [1] VALUE BOX
    # =============
    # ===============================
    # [2] QUANTITATIVO DE OCORRÊNCIAS 
    # ===============================
    box(
      title = HTML("<h5><strong>QUANTITATIVO DE OCORRÊNCIAS - MAPA DE CALOR</strong></h5>"),
      maximizable = TRUE,
      solidHeader = TRUE,
      status = "primary", #background = "gray",
      collapsible = TRUE,
      width = 12, 
      height = "800px",
      tabBox(
        maximizable = TRUE,
        solidHeader = FALSE,
        status = "primary", #background = "gray",
        collapsible = FALSE,
        width = 12, height = "700px",
        tabPanel(
          title = "NÍVEL ESTADUAL", icon = icon("globe"),
          leafletOutput(ns("quant_map_pa"), width = "100%", height = "650px")
        ),
        tabPanel(
          title = "NÍVEL RI GUAJARÁ", icon = icon("search-location"),
          leafletOutput(ns("quant_map_ri"), width = "100%", height = "650px")
        )
      )
    )
    # ===============================
    # [2] QUANTITATIVO DE OCORRÊNCIAS 
    # ===============================
  )
}

# modules/security/security_local.R/mod_security_local_server
mod_security_local_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # =============
    # [1] VALUE BOX
    # =============
    # ===============================
    # [2] QUANTITATIVO DE OCORRÊNCIAS
    # ===============================
    # -----------------
    # [2.1] MAPA - PARÁ
    # -----------------
    output$quant_map_pa <- renderLeaflet({
      # Município alvo
      muni.target <- "BENEVIDES"
      
      # Subconjunto só do município alvo
      df.map_target <- df.map_pa |> 
        filter(`MUNICÍPIO(S)` == muni.target)
      
      # Paleta de Cores
      palet <- colorNumeric(
        palette = "Blues",
        domain = df.map_pa$Quantitativo,
        na.color = "transparent"
      )
      
      # Mapa (Pará)
      leaflet(
        df.map_pa,
        options = leafletOptions(
          minZoom = 6,
          maxZoom = 40,
          zoomControl = F
        )
      ) |>
        addProviderTiles(provider = providers$OpenStreetMap.Mapnik) |>
        # Adiciona os polígonos do shapefile
        addPolygons(
          # Customização visual
          weight = 1,                             # Largura da linha
          color = "black",                        # Cor da linha
          fillColor = ~palet(Quantitativo),       # Cor de preenchimento
          fillOpacity = 1,                        # Transparência do preenchimento
          highlightOptions = highlightOptions(
            weight = 3,              # Aumenta a largura da linha ao passar o mouse
            color = "purple",      # Muda a cor da linha para o mouse
            bringToFront = TRUE      # Traz o polígono para a frente
          ),
          label = ~paste0(
            "<p style='font-size: 15.5px;'><strong>", `MUNICÍPIO(S)`, "</strong><br>",
            "Nº de Ocorrências: ", format(Quantitativo, decimal.mark = ",", big.mark = "."), "</p>"
          ) |> lapply(HTML)
        ) |>
        
        # Camada do município em destaque
        addPolygons(
          data = df.map_target,
          weight = 10,                 # borda bem mais grossa
          color = "red",               # borda vermelha
          fillColor = ~palet(Quantitativo),
          fillOpacity = 1,         # mais opaco
          label = ~paste0(
            "<p style='font-size: 15.5px;'><strong>", `MUNICÍPIO(S)`, "</strong><br>",
            "Nº de Ocorrências: ", format(Quantitativo, decimal.mark = ",", big.mark = "."), "</p>"
          ) |> lapply(HTML)
        ) |>
        
        addLegend(
          pal = palet,
          values = ~Quantitativo,
          title = "Quantitativo",
          opacity = 1,
          labFormat = labelFormat(
            big.mark = ".",
            digits = 0
          )
        ) |>
        setView(lng = -52.5240980965055, lat = -4.139674601570512, zoom = 5) |>
        addEasyButton(
          easyButton(
            icon = "fa-globe", title = "RESETAR O ZOOM",
            onClick = htmlwidgets::JS("function(btn, map){map.setView([-4.139674601570512, -52.5240980965055], 5);}")
          )
        )
    })
    # ---------------
    # [2.2] MAPA - RI
    # ---------------
    output$quant_map_ri <- renderLeaflet({
      # Município alvo
      muni.target <- "BENEVIDES"
      
      # Subconjunto só do município alvo
      df.map_target <- df.map_ri |> 
        filter(`MUNICÍPIO(S)` == muni.target)
      
      # Paleta de Cores
      palet <- colorNumeric(
        palette = "Blues",
        domain = df.map_ri$Quantitativo,
        na.color = "transparent"
      )
      
      # Teste Inicial de Mapa (Pará)
      leaflet(
        df.map_ri,
        options = leafletOptions(
          minZoom = 6,
          maxZoom = 40,
          zoomControl = F
        )
      ) |>
        addProviderTiles(provider = providers$OpenStreetMap.Mapnik) |>
        # Adiciona os polígonos do shapefile
        addPolygons(
          # Customização visual
          weight = 1,                             # Largura da linha
          color = "black",                        # Cor da linha
          fillColor = ~palet(Quantitativo),       # Cor de preenchimento
          fillOpacity = 0.80,                     # Transparência do preenchimento
          highlightOptions = highlightOptions(
            weight = 3,         # Aumenta a largura da linha ao passar o mouse
            color = "purple",   # Muda a cor da linha para o mouse
            bringToFront = TRUE # Traz o polígono para a frente
          ),
          label = ~paste0(
            "<p style='font-size: 15.5px;'><strong>", `MUNICÍPIO(S)`, "</strong><br>",
            "Nº de Ocorrências: ", format(Quantitativo, decimal.mark = ",", big.mark = "."), "</p>"
          ) |> lapply(HTML)
        ) |>
        
        # Camada do município em destaque
        addPolygons(
          data = df.map_target,
          weight = 10,                 # borda bem mais grossa
          color = "red",               # borda vermelha
          fillColor = ~palet(Quantitativo),
          fillOpacity = 1,         # mais opaco
          label = ~paste0(
            "<p style='font-size: 15.5px;'><strong>", `MUNICÍPIO(S)`, "</strong><br>",
            "Nº de Ocorrências: ", format(Quantitativo, decimal.mark = ",", big.mark = "."), "</p>"
          ) |> lapply(HTML)
        ) |>
        
        addLegend(
          pal = palet,
          values = ~Quantitativo,
          title = "Quantitativo",
          opacity = 0.80,
          labFormat = labelFormat(
            big.mark = ".",
            digits = 0
          )
        ) |>
        setView(lng = -48.290590814562975, lat = -1.2269949863242262, zoom = 10) |>
        addEasyButton(
          easyButton(
            icon = "fa-globe", title = "RESETAR O ZOOM",
            onClick = htmlwidgets::JS("function(btn, map){map.setView([-1.2269949863242262, -48.290590814562975], 10);}")
          )
        )
    })
    # =================
    # [*] Fim do Módulo
    # =================
  })
}
# modules/security/security_overview.R/mod_security_overview_ui
mod_security_overview_ui <- function(id) {
  # Cria um namespace para este módulo
  ns <- NS(id)
  
  tabItem(
    tabName = "security_overview",
    # =============
    # [1] VALUE BOX
    # =============
    # ==================================================
    # [2] QUANTITATIVO DE OCORRÊNCIAS - ANÁLISE TEMPORAL
    # ==================================================
    box(
      title = HTML("<h5><strong>QUANTITATIVO DE OCORRÊNCIAS - ANÁLISE TEMPORAL</strong></h5>"),
      #maximizable = TRUE,
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
          echarts4rOutput(ns("quant_ts_pa_benv"), width = "100%", height = "600px")
        ),
        tabPanel(
          title = "NÍVEL RI GUAJARÁ", icon = icon("search-location"),
          echarts4rOutput(ns("quant_ts_ri_benv"), width = "100%", height = "600px")
        ),
        tabPanel(
          title = "NÍVEL MUNICIAPAL", icon = icon("location"),
          fluidRow(
            selectInput(
              ns("select_muni_ts"),
              "SELECIONE O MUNICÍPIO DE COMPARAÇÃO:",
              choices = RI[!RI == "Benevides"],
              selected = "Belém"
            )
          ),
          echarts4rOutput(ns("quant_ts_muni_benv"), width = "100%", height = "550px")
        )
        
      )
    )
  )
}

# modules/security/security_overview.R/mod_security_overview_server
mod_security_overview_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # =============
    # [1] VALUE BOX
    # =============
    # ==================================================
    # [2] QUANTITATIVO DE OCORRÊNCIAS - ANÁLISE TEMPORAL
    # ==================================================
    # --------------------------------------------------------------------------------
    # [2.1] Comparar o Nº de Ocorrências no Estado do Pará e no Município de Benevides
    # --------------------------------------------------------------------------------
    output$quant_ts_pa_benv <- renderEcharts4r({
      quant.ts |>
        # ------------------------------------
      # Construção do Gráfico com o Echart4r
      # ------------------------------------
      e_chart(x = DATA) |>
        # Adiciona a série do Quantitativo
        e_line(serie = `Quantitativo - Pará`, color = "darkblue") |>
        e_line(serie = `Quantitativo - Benevides`, color = "darkred", y_index = 1) |>
        # Formatação dos labels iterativos
        e_tooltip(
          trigger = "axis", 
          extraCssText = "font-size:20px", # width: 250px; padding:10px;
          formatter = htmlwidgets::JS(
            "
            function(params){
              let res = params[0].axisValueLabel + '<br/>';
              params.forEach(function(p) {
                res += p.marker + p.seriesName + ': ' + p.value[1].toLocaleString('pt-BR').bold() + '<br/>';
              });
              return res;
            }
            "
          )
        ) |>
        # Configurações do eixo y
        e_y_axis(
          name = "Nº de Ocorrências no Estado do Pará",
          nameLocation = "middle",
          nameGap = 75,
          nameTextStyle = list(fontWeight = "bold", fontSize = 16, color = "gray"),
          axisLine = list(show = F, lineStyle = list(color = "darkblue")),
          splitLine = list(show = T),
          axisLabel = list(
            formatter = htmlwidgets::JS(
              "
              function(value){
                return value.toLocaleString('pt-BR');
              }
              "
            )
          )
        ) |>
        # Configurações do eixo y
        e_y_axis(
          index = 1,
          name = "Nº de Ocorrências no Município de Benevides",
          nameLocation = "middle",
          nameGap = 75,
          nameTextStyle = list(fontWeight = "bold", fontSize = 16, color = "gray"),
          axisLine = list(show = F, lineStyle = list(color = "darkred")),
          splitLine = list(show = T),
          axisLabel = list(
            formatter = htmlwidgets::JS(
              "
              function(value){
                return value.toLocaleString('pt-BR');
              }
              "
            )
          )
        ) |>
        # Configurações de legenda
        e_legend(
          textStyle = list(
            fontSize = 16,      # aumenta o tamanho da fonte
            fontWeight = "bold" # deixa em negrito (opcional)
          )
        ) |>
        # Cria um ambiente de zoom
        e_datazoom()
    })
    # -------------------------------------------------------------------------------------------------
    # [2.2] Comparar o Nº de Ocorrências na Região de Integração do Guajará e no Município de Benevides
    # -------------------------------------------------------------------------------------------------
    output$quant_ts_ri_benv <- renderEcharts4r({
      quant.ts |>
        # ------------------------------------
      # Construção do Gráfico com o Echart4r
      # ------------------------------------
      e_chart(x = DATA) |>
        # Adiciona a série do Quantitativo
        e_line(serie = `Quantitativo - RI`, color = "darkgreen") |>
        e_line(serie = `Quantitativo - Benevides`, color = "darkred", y_index = 1) |>
        # Formatação dos labels iterativos
        e_tooltip(
          trigger = "axis", 
          extraCssText = "font-size:18px", # width: 250px; padding:10px;
          formatter = htmlwidgets::JS(
            "
            function(params){
              let res = params[0].axisValueLabel + '<br/>';
              params.forEach(function(p) {
                res += p.marker + p.seriesName + ': ' + p.value[1].toLocaleString('pt-BR').bold() + '<br/>';
              });
              return res;
            }
            "
          )
        ) |>
        # Configurações do eixo y
        e_y_axis(
          name = "Nº de Ocorrências na Região de Integração do Guajará",
          nameLocation = "middle",
          nameGap = 75,
          nameTextStyle = list(fontWeight = "bold", fontSize = 16, color = "gray"),
          axisLine = list(show = F, lineStyle = list(color = "darkgreen")),
          splitLine = list(show = T),
          axisLabel = list(
            formatter = htmlwidgets::JS(
              "
              function(value){
                return value.toLocaleString('pt-BR');
              }
              "
            )
          )
        ) |>
        # Configurações do eixo y
        e_y_axis(
          index = 1,
          name = "Nº de Ocorrências no Município de Benevides",
          nameLocation = "middle",
          nameGap = 75,
          nameTextStyle = list(fontWeight = "bold", fontSize = 16, color = "gray"),
          axisLine = list(show = F, lineStyle = list(color = "darkred")),
          splitLine = list(show = T),
          axisLabel = list(
            formatter = htmlwidgets::JS(
              "
              function(value){
                return value.toLocaleString('pt-BR');
              }
              "
            )
          )
        ) |>
        # Configurações de legenda
        e_legend(
          textStyle = list(
            fontSize = 16,      # aumenta o tamanho da fonte
            fontWeight = "bold" # deixa em negrito (opcional)
          )
        ) |>
        # Cria um ambiente de zoom
        e_datazoom()
    })
    # ---------------------------------------------------------------------------------------------------
    # [2.3] Comparar o Nº de Ocorrências no Município de [escolha do usuário] e no Município de Benevides
    # ---------------------------------------------------------------------------------------------------
    quant.ts_filter <- reactive({
      # Ajuste para que o filtro funcione perfeitamente
      df <- quant.ts |>
        tidyr::pivot_longer(
          cols = -DATA,
          names_to = "Origem",
          values_to = "Quantitativo",
          names_prefix = "Quantitativo - "
        )
      
      # Atualiza o input
      req(input$select_muni_ts)
      
      # Filtro
      if (input$select_muni_ts == "Belém") {
        df <- df |> filter(Origem == "Belém")
      } else {
        df <- df |> filter(Origem == input$select_muni_ts)
      }
      
      # Adicionando os dados de Benevides
      df <- df |> right_join(quant.ts, by = "DATA") |> 
        select(DATA, Origem, Quantitativo, `Quantitativo - Benevides`)
      
      # Retornar os dados
      return(df)
    })
    
    output$quant_ts_muni_benv <- renderEcharts4r({
      muni <- quant.ts_filter() |> select(Origem) |> unique() |> as.character()
      muni_label <- paste0("Quantitativo - ", muni)
      fsize <- ifelse(muni == RI[5] | muni == RI[6], 14, 16)
      
      quant.ts_filter() |>
        # ------------------------------------
        # Construção do Gráfico com o Echart4r
        # ------------------------------------
        e_chart(x = DATA) |>
        # Adiciona a série do Quantitativo
        e_line(serie = Quantitativo, name = muni_label, color = "darkorange") |>
        e_line(serie = `Quantitativo - Benevides`, color = "darkred", y_index = 1) |>
        # Formatação dos labels iterativos
        e_tooltip(
          trigger = "axis", 
          extraCssText = "font-size:20px", # width: 250px; padding:10px;
          formatter = htmlwidgets::JS(
            "
            function(params){
              let res = params[0].axisValueLabel + '<br/>';
              params.forEach(function(p) {
                res += p.marker + p.seriesName + ': ' + p.value[1].toLocaleString('pt-BR').bold() + '<br/>';
              });
              return res;
              
              
            }
            "
          )
        ) |>
        # Configurações do eixo y
        e_y_axis(
          name = paste0("Nº de Ocorrências no Município de ", muni),
          nameLocation = "middle",
          nameGap = 75,
          nameTextStyle = list(
            fontWeight = "bold", 
            fontSize = fsize, 
            color = "gray"
          ),
          axisLine = list(show = F, lineStyle = list(color = "darkorange")),
          splitLine = list(show = T),
          axisLabel = list(
            formatter = htmlwidgets::JS(
              "
              function(value){
                return value.toLocaleString('pt-BR');
              }
              "
            )
          )
        ) |>
        # Configurações do eixo y
        e_y_axis(
          index = 1,
          name = "Nº de Ocorrências no Município de Benevides",
          nameLocation = "middle",
          nameGap = 75,
          nameTextStyle = list(fontWeight = "bold", fontSize = 16, color = "gray"),
          axisLine = list(show = F, lineStyle = list(color = "darkred")),
          splitLine = list(show = T),
          axisLabel = list(
            formatter = htmlwidgets::JS(
              "
              function(value){
                return value.toLocaleString('pt-BR');
              }
              "
            )
          )
        ) |>
        # Configurações de legenda
        e_legend(
          textStyle = list(
            fontSize = 16,      # aumenta o tamanho da fonte
            fontWeight = "bold" # deixa em negrito (opcional)
          )
        ) |>
        # Cria um ambiente de zoom
        e_datazoom()
    })
    # =================
    # [*] Fim do Módulo
    # =================
  })
}
# ==========================
# [1] CONFIGURAÇÕES INICIAIS
# ==========================
source("global.R")

# ===================================
# [2] FrontEnd - Interface do Usuário
# ===================================
ui <- dashboardPage(
  title = "Relatório de Gestão",
  
  # ===============
  # [2.1] Cabeçalho
  # ===============
  header = dashboardHeader(
    titleWidth = 220,
    title = dashboardBrand(
      title = tags$strong("BENEVIDES"),
      image = "BRASÃO_BENEV.jpeg",
      color = "primary"
    ),
    skin = "primary",
    disable = FALSE
  ),
  
  # ===================
  # [2.2] Barra Lateral
  # ===================
  sidebar = dashboardSidebar(
    width = 220,
    sidebarMenu(
      menuItem("PROJETO", tabName = "project", icon = icon("diagram-project")),
      menuItem("EDUCAÇÃO", tabName = "education", icon = icon("book")),
      menuItem("EMPREGO E RENDA", tabName = "income", icon = icon("person-walking-luggage")),
      menuItem(
        "SEGURANÇA", tabName = "security", icon = icon("shield"),
        menuSubItem("VISÃO GERAL", tabName = "security_overview", icon = icon("dashboard")),
        menuSubItem("LOCAL DAS OCORRÊNCIAS", tabName = "security_local", icon = icon("map-location-dot")),
        menuSubItem("PERFIL DA VÍTIMA", tabName = "security_profile_auth", icon = icon("person-circle-plus")),
        menuSubItem("PERFIL DA AUTOR", tabName = "security_profile_vic", icon = icon("people-robbery"))
      )
    )
  ), 
  
  # ===================
  # [2.3] Corpo do Dash
  # ===================
  body = dashboardBody(
    # Tag para Expansão
    tags$head(
      tags$script(
        HTML(
          "
          // Este código 'escuta' por um clique em qualquer botão de maximizar
          $(document).on('click', '[data-card-widget=\"maximize\"]', function(){
            // Ele espera um curto período (350ms) para a animação da caixa terminar
            setTimeout(function() {
              // E então dispara um evento de 'resize' na janela.
              // Todos os gráficos (echarts4r, leaflet) escutam por este evento
              // e se redimensionam para caber no novo espaço.
              $(window).trigger('resize');
            }, 350);
          });
          "
        )
      ),
      
      tags$head(
        tags$style(
          HTML(
            "
            .card-tools [data-card-widget='maximize'] .fas {
              color: gray !important;
            }
            .card-tools [data-card-widget='maximize']:hover .fas {
              color: darkgray !important;
            }
            "
          )
        )
      ),
      
      
      tags$script(
        HTML(
          "
          <style>
          /* Aplica o estilo a todos os elementos dentro do contêiner da tabela DT.
             Isso afeta o cabeçalho de busca, o corpo da tabela e o rodapé. */
          .dt-fonte-total {
              font-size: 20px; /* Defina o tamanho da fonte desejado aqui */
          }
          /* Se houver elementos que não herdaram (como as tags de entrada), force o estilo */
          .dt-fonte-total select, .dt-fonte-total input {
              font-size: 20
              px !important;
          }
          </style>
          "
        )
      )
    ),
    #
    tabItems(
      # ====================
      # [2.3.1] ABA: Projeto
      # ====================
      tabItem(
        tabName = "project",
        tabBox(
          id = "tabs", width = 12, height = "600px",
          tabPanel(strong("INTRODUÇÃO"), icon = icon("book")),
          tabPanel(strong("MATERIAL E MÉTODOS"), icon = icon("chart-bar")),
          tabPanel(strong("RECURSO COMPUTACIONAL"), icon = icon("desktop")),
          tabPanel(strong("EQUIPE TÉCNICA"), icon = icon("user"))
        )
      ),
      # =====================
      # [2.3.2] ABA: Educação
      # =====================
      # ============================
      # [2.3.3] ABA: Emprego & Renda
      # ============================
      # ======================
      # [2.3.4] ABA: Segurança
      # ======================
      mod_security_local_ui("security_local"),
      mod_security_overview_ui("security_overview")
    )
  ),
  
  # ============
  # [2.4] Rodapé
  # ============
  footer = dashboardFooter(
    left = strong(paste0("Atualizado em ",  format(lubridate::today(), format = "%d/%m/%Y"))),
    right = strong("Faculdade de Estatística")
  )
)

# =============================
# [3] BackEnd - Camada Servidor
# =============================
server <- function(input, output) {
  # ==============
  # [3.1] Educação
  # ==============
  # =====================
  # [3.2] Emprego e Renda
  # =====================
  # ===============
  # [3.3] Segurança
  # ===============
  mod_security_local_server("security_local")
  mod_security_overview_server("security_overview")
}

# ============================
# [4] Produto Final: Dashboard
# ============================
shinyApp(ui, server)
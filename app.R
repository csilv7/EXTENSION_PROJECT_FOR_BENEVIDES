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
      color = "lightblue"
    ),
    skin = "lightblue"
  ),
  
  # ===================
  # [2.2] Barra Lateral
  # ===================
  sidebar = dashboardSidebar(
    width = 220,
    sidebarMenu(
      menuItem("PROJETO", tabName = "project", icon = icon("diagram-project")),
      menuItem("EDUCAÇÃO", tabName = "education", icon = icon("book")),
      #menuItem("SAÚDE", tabName = "medical", icon = icon("notes-medical")),
      menuItem("SEGURANÇA", tabName = "security", icon = icon("shield")),
      menuItem("EMPREGO E RENDA", tabName = "income", icon = icon("person-walking-luggage"))
    )
  ), 
  
  # ===================
  # [2.3] Corpo do Dash
  # ===================
  body = dashboardBody(
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
      )
      # =====================
      # [2.3.2] ABA: Educação
      # =====================
      # ======================
      # [2.3.2] ABA: Segurança
      # ======================
      # ============================
      # [2.3.2] ABA: Emprego & Renda
      # ============================
    )
  ),
  
  # ------------
  # [2.4] Rodapé
  # ------------
  footer = dashboardFooter(
    left = strong(paste0("Atualizado em ",  format(lubridate::today(), format = "%d/%m/%Y"))),
    right = strong("Faculdade de Estatística")
  )
)

# -----------------------------
# [3] BackEnd - Camada Servidor
# -----------------------------
server <- function(input, output) {
  # --------------------------
  # [3.3] SUB-ABA: VISÃO GERAL
  # --------------------------
  # --------------------------
  # [3.4] SUB-ABA: VISÃO GEOGR
  # --------------------------
}

# ----------------------------
# [4] Produto Final: Dashboard
# ----------------------------
shinyApp(ui, server)
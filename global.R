# ==========================
# [1] CONFIGURAÇÕES INICIAIS
# ==========================

# Funcionalidades do Painel
library(shiny)
library(bs4Dash)
library(htmltools)
library(htmlwidgets)

# Leitura de Dados
#library(readxl)

# Tratamento/Manipulações de Dados
library(dplyr)
#library(tidyr)
#library(purrr)
library(stringr)

# Nuvem de Palavras
#library(tm)
#library(wordcloud2)

# Diagrama de Sankey
#library(networkD3)

# Tabelas 
#library(DT)

# Visualizações
library(echarts4r)

# Mapas
library(sf)
library(leaflet)


# ==================
# [2] CARREGAR DADOS
# ==================
# ==============
# [2.2] EDUCAÇÃO
# ==============

#CME_PAE <- readRDS("dataset/CME_DATASET_PAE.rds")
#source("preprocessingDataset/CME_PAE.R")

# =====================
# [2.2] EMPREGO E RENDA
# =====================

#ESPECIALIDADES_CBMPA <- readRDS("dataset/ADJ_ESPECIALIDADES_CBMPA.rds")
#source("preprocessingDataset/ESPECIALIDADES_CBMPA.R")

# ===============
# [2.3] SEGURANÇA
# ===============
# -------------------
# [2.3.1] CONSOLIDADO
# -------------------
data.consolid <- readRDS("dataset/security/consolid_pa.rds") |> 
  right_join(
    by = "MUNICÍPIO(S)",
    geobr::read_municipality(code_muni = "PA", year = 2024) |>
      mutate(`MUNICÍPIO(S)` = str_to_upper(stringi::stri_trans_general(name_muni, "Latin-ASCII"))) |>
      select(`MUNICÍPIO(S)`, geom)
  )

# ==================
# [3] OBJETOS USUAIS
# ==================

# ---------------------------
# [3.1] DIVISÃO POR RI & IBGE
# ---------------------------
# # Divisão por RI (Guajará)
# RI <- c("Belém", "Ananindeua", "Marituba", "Benevides", "Santa Bárbara do Pará")
# 
# # RI Ajustado
# RI.adj <- str_to_upper(stringi::stri_trans_general(RI, "Latin-ASCII"))
# 
# # Divisão por RM (IBGE)
# RM <- c("Belém", "Ananindeua", "Marituba", "Benevides", "Santa Bárbara do Pará", "Santa Izabel do Pará", "Castanhal", "Barcarena")

# ----------------------
# [3.2] DIVISÃO POR RISP
# ----------------------
# regions_by_risp <- list(
#   "1ª Região da Capital" = c("Belém"),
#   "2ª Região da Capital" = c("Ananindeua", "Marituba", "Benevides", "Santa Bárbara do Pará"),
#   "3ª Região do Guamá" = c(
#     "Castanhal", "Curuçá", "Igarapé-Açu", "Inhangapi", "Magalhães Barata", "Maracanã", "Marapanim",
#     "São Domingos do Capim", "São Francisco do Pará", "Terra Alta", "Santa Izabel do Pará",
#     "Santo Antônio do Tauá", "Bujaru", "Concórdia do Pará", "Tomé-Açu", "Vigia",
#     "São Caetano de Odivelas", "Colares", "São João da Ponta", "São Miguel do Guamá",
#     "Santa Maria do Pará", "Mãe do Rio", "Irituia"
#   ),
#   "4ª Região do Tocantins" = c(
#     "Barcarena", "Acará", "Cametá", "Oeiras do Pará", 
#     "Limoeiro do Ajuru", "Mocajuba", "Baião", "Abaetetuba", 
#     "Igarapé-Miri", "Moju"
#   ),
#   "5ª Região do Marajó Oriental" = c(
#     "Cachoeira do Arari", "Muaná", "Ponta de Pedras", "Salvaterra",
#     "Santa Cruz do Arari", "Soure"
#   ),
#   "6ª Região do Caeté" = c(
#     "Salinópolis", "Santarém Novo", "São João de Pirabas", "Capanema", "Capitão Poço",
#     "Garrafão do Norte", "Ourém", "Nova Esperança do Piriá", "Cachoeira do Piriá", "Bonito",
#     "Nova Timboteua", "Peixe-Boi", "Primavera", "Quatipuru", "Santa Luzia do Pará",
#     "Bragança", "Tracuateua", "Augusto Corrêa", "Viseu"
#   ),
#   "7ª Região do Capim" = c("Paragominas", "Aurora do Pará", "Dom Eliseu", "Ipixuna do Pará", "Ulianópolis"),
#   "8ª Região do Marajó Ocidental" = c(
#     "Breves", "Afuá", "Anajás", "Bagre", "Chaves", "Curralinho", "Gurupá",
#     "Melgaço", "Portel", "São Sebastião da Boa Vista"
#   ),
#   "9ª Região do Lago de Tucuruí" = c(
#     "Tucuruí", "Breu Branco", "Novo Repartimento", "Pacajá", "Tailândia",
#     "Goianésia do Pará", "Jacundá"
#   ),
#   "10ª Região de Carajás" = c(
#     "Marabá", "Abel Figueiredo", "Bom Jesus do Tocantins", "Brejo Grande do Araguaia",
#     "Itupiranga", "Nova Ipixuna", "Palestina do Pará", "São Domingos do Araguaia",
#     "Rondon do Pará", "São Geraldo do Araguaia", "São João do Araguaia",
#     "Parauapebas", "Curionópolis", "Canaã dos Carajás", "Eldorado do Carajás", "Piçarra"
#   ),
#   "11ª Região do Xingu" = c(
#     "Altamira", "Anapu", "Brasil Novo", "Medicilândia", "Porto de Moz",
#     "Senador José Porfírio", "Uruará", "Vitória do Xingu"
#   ),
#   "12ª Região do Baixo Amazonas" = c(
#     "Santarém", "Alenquer", "Almeirim", "Belterra", "Curuá", "Faro", "Juruti",
#     "Monte Alegre", "Óbidos", "Oriximiná", "Prainha", "Mojuí dos Campos",
#     "Terra Santa"
#   ),
#   "13ª Região do Araguaia" = c(
#     "Redenção", "Conceição do Araguaia", "Cumaru do Norte", "Floresta do Araguaia",
#     "Pau D'Arco", "Santa Maria das Barreiras", "Santana do Araguaia"
#   ),
#   "14ª Região do Alto Xingu" = c(
#     "Água Azul do Norte", "Bannach", "Ourilândia do Norte", "Rio Maria", "Sapucaia",
#     "São Félix do Xingu", "Tucumã", "Xinguara"
#   ),
#   "15ª Região do Tapajós" = c(
#     "Itaituba", "Aveiro", "Jacareacanga", "Novo Progresso", "Placas", "Rurópolis",
#     "Trairão"
#   )
# )

# ==================
# [4] FUNÇÕES USUAIS
# ==================

# ==================
# [5] CHAMAR MÓDULOS
# ==================
# ===============
# [5.3] SEGURANÇA
# ==================
source("modules/security/security_local.R")
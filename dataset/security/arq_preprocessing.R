# import os
# import re
# import pandas as pd
# 
# # Definindo diretório p/ tarefa
# path_of_files = r"C:/Users/user/Documents/PROJETO EXTENSÃO/SEGURANÇA - BRENO & EMERSON"
# 
# # Listar os arquivos .xlsx
# files = [f for f in os.listdir(path_of_files) if f.endswith(".xlsx")]
# 
# # Criar pasta para salvar em PKL (equivalente ao RDS)
# rds_path = os.path.join(path_of_files, "arq_pkl")
# 
# os.makedirs(rds_path, exist_ok=True)
# 
# # Função para ler, salvar individualmente e preparar para consolidação
# def read_and_convert(file):
#   # Nome do arquivo sem extensão
#   name = os.path.splitext(file)[0]
# 
# # Ler o arquivo Excel
# df = pd.read_excel(os.path.join(path_of_files, file))
# 
# # Salvar individualmente em PKL
# df.to_pickle(os.path.join(rds_path, f"{name}.pkl"))
# 
# # Extrair o ano do nome do arquivo
# year_match = re.search(r"d{4}", name)
# year = int(year_match.group()) if year_match else None
# 
# # Adicionar coluna ANO
# df["ANO"] = year
# 
# return df
# 
# # Aplicar função a todos os arquivos
# list_data = [read_and_convert(f) for f in files]
# 
# # Consolidar todos em um único DataFrame
# data_consolid = pd.concat(list_data, ignore_index=True)
# 
# # Salvar o consolidado em PKL
# data_consolid.to_pickle(os.path.join(path_of_files, "consolid.pkl"))

# ===============
# [1] Visão Geral
# ===============

# Pacotes Necessários
library(dplyr)
library(stringr)

# # Definindo diretório p/ tarefa
# path.of.files <- "C:/Users/user/Documents/PROJETO EXTENSÃO/SEGURANÇA - BRENO & EMERSON"
# 
# # Divisão por RI (Guajará)
# RI <- c(
#   "Belém", "Ananindeua", "Marituba", 
#   "Benevides", "Santa Bárbara do Pará", "Santo Antônio do Tauá"
# )
# 
# # RI Ajustado
# RI.adj <- str_to_upper(stringi::stri_trans_general(RI, "Latin-ASCII"))
# 
# # Divisão por RM (IBGE)
# RM <- c(
#   "Belém", "Ananindeua", "Marituba", 
#   "Benevides", "Santa Bárbara do Pará", 
#   "Santa Izabel do Pará", "Castanhal", "Barcarena"
# )
# 
# # Listar os arquivos .xlsx
# files <- list.files(path = path.of.files, pattern = ".xlsx", full.names = T)
# 
# # Criar pasta para salvar em RDS
# dir.create(path = file.path(path.of.files, "arq_rds"))
# 
# # Função para ler, salvar individualmente e preparar para consolidação
# read_and_convert <- function(file) {
#   # Extrair o nome do arquivo sem extensão
#   name <- tools::file_path_sans_ext(x = basename(file))
#   
#   # Ler o arquivo Excel
#   data.df <- readxl::read_excel(file)
#   
#   # Salvar individualmente em RDS
#   saveRDS(data.df, file = file.path(path.of.files, "arq_rds", paste0(name, ".rds")))
#   
#   # Extrair o ano do nome do arquivo
#   year <- str_extract(string = name, pattern = "d{4}")
#   
#   # Adicionar coluna ano
#   data.df <- data.df |> mutate(ANO = as.integer(year))
#   
#   # Retornar os Dados Consolidados
#   return(data.df)
# }
# 
# # Aplicar função a todos os arquivos
# list.data <- purrr::map(files, read_and_convert)
# 
# # Consolidar todos em um único data frame
# data.consolid <- bind_rows(list.data)
# 
# # Salvar o consolidado em RDS
# saveRDS(
#   object = data.consolid, 
#   file = "C:/Users/user/Documents/PROJETO EXTENSÃO/dataset/security/consolid_pa.rds"
# )
# 
# # Filtrar Região de Integração e Salvar o consolidado em RDS
# saveRDS(
#   object = data.consolid |> filter(`REGIÃO DE INTEGRAÇÃO` == "REGIAO GUAJARA"), 
#   file = "C:/Users/user/Documents/PROJETO EXTENSÃO/dataset/security/consolid_ri.rds"
# )

# --------------------------------------
# [2.1] Análise Temporal das Ocorrências
# --------------------------------------

# Função que cria coluna de datas
add_time_cols <- function(data) {
  data |>
    mutate(
      # Mapeamento do mês (reutilizado)
      MES_ADJ = factor(
        case_when(
          str_detect(`MÊS DO FATO`, "JANEIRO") ~ "Janeiro",
          str_detect(`MÊS DO FATO`, "FEVEREIRO") ~ "Fevereiro",
          str_detect(`MÊS DO FATO`, "MARCO") ~ "Março",
          str_detect(`MÊS DO FATO`, "ABRIL") ~ "Abril",
          str_detect(`MÊS DO FATO`, "MAIO") ~ "Maio",
          str_detect(`MÊS DO FATO`, "JUNHO") ~ "Junho",
          str_detect(`MÊS DO FATO`, "JULHO") ~ "Julho",
          str_detect(`MÊS DO FATO`, "AGOSTO") ~ "Agosto",
          str_detect(`MÊS DO FATO`, "SETEMBRO") ~ "Setembro",
          str_detect(`MÊS DO FATO`, "OUTUBRO") ~ "Outubro",
          str_detect(`MÊS DO FATO`, "NOVEMBRO") ~ "Novembro",
          str_detect(`MÊS DO FATO`, "DEZEMBRO") ~ "Dezembro",
          TRUE ~ `MÊS DO FATO`
        ),
        levels = c(
          "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
          "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
        ),
        ordered = TRUE
      ),
      # Criação da coluna DATA (reutilizada)
      MES_NUM = as.integer(MES_ADJ),
      DIA = days_in_month(make_date(year = `ANO DO FATO`, month = MES_NUM, day = 1)),
      DATA = make_date(year = `ANO DO FATO`, month = MES_NUM, day = DIA)
    ) |>
    # Remove as colunas temporárias/originais de mês/ano
    select(-`MÊS DO FATO`, -MES_ADJ, -MES_NUM, -DIA, -`ANO DO FATO`) |>
    arrange(DATA)
}

# Função para realizar o mapeamento dos dados dos municípios
process.time_series <- function(muni_name) {
  # Ajuste necessário para filtro
  muni_name.adj <- str_to_upper(stringi::stri_trans_general(muni_name, "Latin-ASCII"))
  
  # Nome da coluna quantitativo
  col.name <- paste0("Quantitativo - ", muni_name)
  
  # Processar dados
  data.consolid |>
    filter(`MUNICÍPIO(S)` == muni_name.adj) |>
    group_by(`ANO DO FATO`, `MÊS DO FATO`) |>
    summarise(!!col.name := n(), .groups = "drop") |>
    add_time_cols() # Função auxiliar criada acima
}

# Tratamento para as Visualizações Temporais
quant.ts <- data.consolid |>
  # Série Temporal do Quantitativo de Ocorrências no Estado do Pará
  group_by(`ANO DO FATO`, `MÊS DO FATO`) |>
  summarise(`Quantitativo - Pará` = n(), .groups = "drop") |>
  add_time_cols() |> # Função auxiliar criada acima
  select(DATA, `Quantitativo - Pará` ) |> 
  # Série Temporal do Quantitativo de Ocorrências na Região de Itegração do Guajará
  right_join(
    data.consolid |>
      filter(`REGIÃO DE INTEGRAÇÃO` == "REGIAO GUAJARA") |>
      group_by(`ANO DO FATO`, `MÊS DO FATO`) |>
      summarise(`Quantitativo - RI` = n(), .groups = "drop") |>
      add_time_cols() |> # Função auxiliar criada acima
      select(DATA, `Quantitativo - RI` ), 
    by = "DATA"
  ) |> 
  # Função (mapear) de processamento da Série Temporal do Municípios
  right_join(
    purrr::map(RI, process.time_series) |>
      purrr::reduce(full_join, by = "DATA") |>
      arrange(DATA), 
    by = "DATA"
  )

# -------------------------
# [2.2] Mapa (geo) de Calor
# -------------------------

# ------------------------------------------------
# [2.2.1] Mapa de Calor - Nº de Ocorrências (Pará)
# ------------------------------------------------

# Tratamento dos Dados
df.map_pa <- data.consolid |>
  group_by(`MUNICÍPIO(S)`, geometry) |> 
  summarise(Quantitativo = n(), .groups = "drop") |>
  st_as_sf() |>
  st_transform(4326)

# ----------------------------------------------
# [2.2.2] Mapa de Calor - Nº de Ocorrências (RI)
# ----------------------------------------------

# Tratamento dos Dados
df.map_ri <- data.consolid |> 
  filter(`REGIÃO DE INTEGRAÇÃO` == "REGIAO GUAJARA") |>
  group_by(`MUNICÍPIO(S)`, geometry) |> 
  summarise(Quantitativo = n(), .groups = "drop") |>
  st_as_sf() |>
  st_transform(4326)


# ==========
# [2] Salvar
# ==========
save(
   # Análise Temporal - Nº de Ocorrências
   quant.ts,
   # Mapa de Calor (PA) - Nº de Ocorrências
   df.map_pa,
   # Mapa de Calor (RI) - Nº de Ocorrências
   df.map_ri,
   
   # Local do arquivo
   file = "dataset/security/consoliddd.RData"
 )
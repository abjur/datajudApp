#' dados UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
mod_dados_ui <- function(id){
  ns <- shiny::NS(id)

  con <- bq_connect()
  tribunais <- sort(DBI::dbListTables(con))


  filtro_uf <- shinyWidgets::pickerInput(
    ns("tribunal"), "UF",
    choices = tribunais,
    selected = "tjac",
    multiple = TRUE,
    options = c(abjDash::picker_options(), `live-search` = TRUE)
  )

  # filtros temporais --------------------------------------------------------

  slider_tempo <- shiny::dateRangeInput(
    ns("intervalo_tempo"),
    "Intervalo de tempo",
    start = as.Date("2015-01-01"),
    min = as.Date("2015-01-01"),
    end = as.Date("2022-09-01"),
    max = as.Date("2022-09-01"),
    format = "yyyy-mm",
    startview = "month",
    language = "pt",
    separator = " at\u00E9 "
  )

  shiny::tagList(

    # texto explicativo
    shiny::fluidRow(
      bs4Dash::box(
        title = shiny::tags$h2("Dados"), collapsible = FALSE, width = 12,
        shiny::tags$p(paste0(
          "Para fazer download dos dados utilizados neste painel, aplique os ",
          "filtros desejados e clique no bot\u00E3o 'Download'."
        ))
      )
    ),

    # primeira linha ----

    shiny::fluidRow(
      bs4Dash::box(
        inputId = ns("controles"),
        width = 12,
        title = "Selecione o que deseja visualizar",
        shiny::tags$h2("Filtros regionais"),
        shiny::fluidRow(col_3(filtro_uf)),
        shiny::hr(),
        shiny::tags$h2("Filtros temporais"),
        shiny::fluidRow(col_3("Em constru\u00E7\u00E3o")),
        shiny::hr(),
        shiny::tags$h2("Filtros de escopo"),
        shiny::fluidRow(col_3("Em constru\u00E7\u00E3o")),
        shiny::hr(),
        shiny::fluidRow(shiny::tags$div(shiny::actionButton(
          ns("botao_filtrar"), "EXECUTAR"
        ), align = "center"))
      )
    ),
    # segunda linha ----
    shiny::fluidRow(
      bs4Dash::box(
        width = 12,
        title = "Dados",
        spinner(reactable::reactableOutput(ns("tabela"))),
        footer = shinyWidgets::downloadBttn(
          ns("download"),
          label = "Download",
          style = "fill",
          color = "primary"
        )
      )
    )
  )
}

#' dados Server Functions
#'
#' @noRd
mod_dados_server <- function(id, app_data) {
  moduleServer( id, function(input, output, session) {
    ns <- session$ns

    # reactives ----

    validar <- shiny::reactive({
      shiny::validate(shiny::need(
        nrow(da_reactive()) > 0,
        "N\u00e3o foi poss\u00edvel gerar a visualiza\u00e7\u00e3o com os par\u00e2metros selecionados."
      ))
    })

    # filtros ----

    # TODO

    # reactives ----
    da_reactive <- shiny::eventReactive(input$botao_filtrar, {

      # app_data()$litigiosidade

      shinyjs::runjs(stringr::str_glue(
        'document.querySelector("#{ns("controles")} > div.card-header > div > button").click();'
      ))

      # query inicial ----
      usethis::ui_info("acessando BD...")

      con <- bq_connect()

      tabela <- input$tribunal

      # browser()
      tbl_init <- dplyr::tbl(con, tabela)
      # aplicacao dos filtros na base ----
      da_filtrado_lazy <- tbl_init |>
        utils::head(1000)

      # collect ----
      usethis::ui_info("collect...")

      da_filtrado <- da_filtrado_lazy |>
        dplyr::collect()

      bigrquery::dbDisconnect(con)

      # post process ----

      da_filtrado

    })


    output$tabela <- reactable::renderReactable({
      validar()
      da_reactive() |>
        dplyr::slice_head(n = 1000) |>
        reactable::reactable(
          compact = TRUE,
          striped = TRUE
        )
    })


    output$download <- shiny::downloadHandler(
      filename = function() {
        paste0(Sys.Date(), "-dados-obslitig-", digest::digest(stats::runif(1)), ".csv")
      },
      content = function(file) {
        validar()
        readr::write_excel_csv2(da_reactive(), file)
      }
    )

  })
}


#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {

  shiny::observe({
    shinyalert::shinyalert(
      "Datajud",
      text = shiny::tagList(
        "Boas vindas ao dashboard do Datajud! Aqui voce pode baixar dados da",
        shiny::a(href = "", target = "_blank", "plataforma de estatisticas judiciarias do CNJ,"),
        " mas com a possibilidade de aplicar filtros mais gerais.",
        "\n",
        "Se encontrar algum problema, envie um e-mail para",
        shiny::a(href = "mailto:contato@abj.org.br", "contato@abj.org.br"),
        "."
      ),
      closeOnClickOutside = TRUE,
      closeOnEsc = TRUE,
      showConfirmButton = FALSE,
      imageUrl = "https://abj.org.br/assets/logo-home.png",
      html = TRUE,
      size = "m",
      imageWidth = 400,
      imageHeight = 200
    )
  })

  mod_dados_server("dados_ui_1")

}


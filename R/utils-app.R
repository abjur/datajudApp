mapa <- function(data, label = "casos") {
  v <- names(data)[1]
  da_lab <- data |>
  dplyr::mutate(prop = n / sum(n), lab = stringr::str_glue("<b>{label}</b> {n}"))
  highcharter::hcmap("countries/br/br-all",
    data = da_lab,
    value = "prop", joinBy = c("hc-a2", "uf"), borderColor = "#FAFAFA",
    dataLabels = list(enabled = TRUE, format = "{point.uf}"),
    borderWidth = 0.1, tooltip = list(pointFormat = "{point.name}<br> {point.lab}"),
    download_map_data = TRUE
  ) %>%
    highcharter::hc_colorAxis(type = "logarithmic") %>%
    highcharter::hc_exporting(enabled = TRUE, filename = v)
}

mapa_muni <- function(da_lab) {
  v <- names(da_lab)[1]
  muni <- stringr::str_sub(da_lab$id_municipio[1], 1, 2)
  link <- stringr::str_glue("https://raw.githubusercontent.com/tbrugz/geodata-br/master/geojson/geojs-{muni}-mun.json")

  map_data <- link |>
    httr::GET() |>
    httr::content() |>
    jsonlite::fromJSON() |>
    geojsonio::as.json()

  highcharter::highchart(type = "map") |>
    highcharter::hc_add_series(
      mapData = map_data,
      data = da_lab,
      showInLegend = FALSE,
      joinBy = c("id", "code_muni")
    ) |>
    highcharter::hc_colorAxis(enabled = TRUE) |>
    highcharter::hc_tooltip(
      pointFormat = "{point.name}: {point.lab}"
    ) |>
    highcharter::hc_exporting(enabled = TRUE, filename = v)
}

value_box <- function(val, prop, label, proporcao = TRUE, corr = FALSE) {

  if (proporcao) {
    val <- scales::percent(val, accuracy = .01, big.mark = ".", decimal.mark = ",")
  } else {
    if (corr) {
      val <- scales::number(val, accuracy = 0.001, big.mark = ".", decimal.mark = ",")
    } else {
      val <- scales::number(val, big.mark = ".", decimal.mark = ",")
    }
  }

  if (is.null(prop)) {
    prop_lab <- ""
    status <- "info"
    icon <- "hashtag"
  } else {
    if (is.na(prop)) {
      status <- "info"
      icon <- "arrow-up"
    } else if (prop > 0) {
      status <- "info"
      icon <- "arrow-up"
    } else {
      status <- "info"
      icon <- "arrow-down"
    }
    prop_lab <- scales::percent(
      prop, .01, big.mark = ".", decimal.mark = ","
    )
  }

  if (is.na(val)) {
    val <- "<vazio>"
  }

  if (is.na(prop_lab)) {
    prop_lab <- "<vazio>"
  }

  bs4Dash::valueBox(
    subtitle = label,
    value = tags$p(val, style = "font-size: 2vmax; margin-bottom: 0;"),
    icon = icon,
    status = status,
    footer = prop_lab
  )

}

spinner <- function(el) {
  shinycssloaders::withSpinner(el, type = 6, color = "#003366")
}

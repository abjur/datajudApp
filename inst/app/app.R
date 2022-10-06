readRenviron(".Renviron")
shiny::shinyApp(datajudApp:::app_ui(), datajudApp:::app_server)

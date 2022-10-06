#' The application User-Interface
#'
#' @import shiny
#' @noRd
app_ui <- function() {

  tagList(
    # Leave this function for adding external resources

    golem_add_external_resources(),

    bs4Dash::dashboardPage(

      # ----

      navbar = bs4Dash::dashboardHeader(
        # rightUi = auth0::logoutButton(icon = icon("sign-out-alt", verify_fa = FALSE))
      ),

      # ----
      sidebar = bs4Dash::dashboardSidebar(
        skin = "light",
        title = shiny::div(shiny::img(
          src = "https://abj.org.br/assets/logo-home.png", style = "max-width: 200px"
        ), style = "text-align: center"),
        bs4Dash::bs4SidebarMenu(
          bs4Dash::bs4SidebarMenuItem(
            "Dados",
            tabName = "dados",
            icon = "database"
          )
        )
      ),

      # ----
      body = bs4Dash::dashboardBody(
        fresh::use_theme(create_theme_css()),
        bs4Dash::bs4TabItems(
          bs4Dash::bs4TabItem(
            tabName = "dados",
            mod_dados_ui("dados_ui_1")
          )
        )
      ),

      # ----
      footer = bs4Dash::dashboardFooter(
        copyrights = a(
          href = "https://abj.org.br",
          target = "_blank", paste(
            "Desenvolvido com \u2764\ufe0f pela ABJ",
            "20/07/2022",
            sep = " | \u00daltima Atualiza\u00e7\u00e3o: "
          )
        ),
        right_text = shiny::HTML(
          "Problemas ou feedbacks? ",
          "<a href='mailto:contato@abj.org.br'>contato@abj.org.br</a>"
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(),
    shinyjs::useShinyjs(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'datajudApp'
    ),
    metathis::meta_social(
      metathis::meta(),
      title = "Datajud",
      description = "Versao mais aberta do Datajud",
      url = "https://abjur/shinyapps.io/datajudApp",
      image = "https://lab.abj.org.br/images/abj.png",
      image_alt = "Datajud",
      twitter_creator = "@abjurimetria",
      twitter_card_type = "summary",
      twitter_site = "@abjurimetria",
      og_type = "profile",
      og_locale = "pt_BR"
    )
  )
}


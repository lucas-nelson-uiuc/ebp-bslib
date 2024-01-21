render_analytic_details <- function(id) {
  tableau_workbook_details <- uiOutput(NS(id, 'tableau_workbook'))
  memo_package_details <- uiOutput(NS(id, 'memo_package'))
  bslib::accordion(
    bslib::accordion_panel(title='Tableau Workbook', tableau_workbook_details),
    bslib::accordion_panel(title='Memo Package', memo_package_details),
    open=FALSE
  )
}


module_analytic_details <- function(id, analytic_obj=NULL) {
  moduleServer(id, function(input, output, session) {
    output$tableau_workbook <- renderUI({
      tags$div(
        analytic_obj[['tableau_shell']][['name']],
        analytic_obj[['tableau_shell']][['description']],
      )
    })
    output$memo_package <- renderUI({
      tags$ul(
        purrr::map2(
          names(analytic_obj[['memos']]), analytic_obj[['memos']],
          \(name, content) tags$li(name, content[['name']], content[['description']])
        )
      )
    })
  })
}

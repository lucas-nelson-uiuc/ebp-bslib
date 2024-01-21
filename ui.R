### EBP Shiny app
###
### [INSTRUCTIONS]
### Press 'Run App' in the top right corner of this pane.
### This will open a new screen for you to do the following:
###   1. Select EBP analytic
###   2. Knit markdown file
###       - the app will first warn you of any errors; please
###         address these before proceeding
###   3. (Optional) Generate memos
###       - memos reference 'Memo Package/' directory and
###         output to 'Output/' directory
###
### [NEED HELP?]``
### Please reach out to ...
###
### [HAVE IDEAS TO IMPROVE THIS APP?]
### Please reach out to ...
###
### Author: Lucas Nelson

library(magrittr)
options(shiny.fullstacktrace=TRUE)
source_dir <- 'R'
purrr::walk(
    list.files(source_dir),
    ~ source(file.path(source_dir, .x))
)


library(shiny)
library(bslib)


### Data Validation Step
### --------------------
# numeric, character, date types; check if conversion possible? issues with tie out?
#   > convert to CSV
#   > log changes we make, write to memos
# (ARO DWW) conversions take time; improvement? automation? easier way? reduce manual involvement?
#   > @Olivia "consistent file types"
#   > allow file input, then output file to directory with transformations performed

### Shiny App
### ---------
# analytic selection
# request validation
#   > helps with data/formatting requirements
# self-service tool?

### Generate Memos
### --------------
# minimal Shiny components
# edit existing resources for designing memo templates
# integration with previous steps
#   > writing parts of the memo with other steps...

# GITHUB IS WORKING

ui <- page_navbar(
    title = "EBP Analytics Shell",
    theme = bs_theme(
        version = 5,
        bootswatch = 'pulse',
        # "navbar-bg" = EBP_COLORS[['bg']]
    ),
    nav_panel('Shell', PAGE_HOME()),
    nav_panel('Other', bslib::page_fluid(p('uhhhh khakis'))),
    nav_spacer(),
    nav_menu(
        title='More Info',
        nav_item('PII', p('page on PII')),
        nav_item('FAQ', p('some Qs')),
        nav_item('...')
    )
)
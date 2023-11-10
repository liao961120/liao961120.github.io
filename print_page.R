#' Call as:
#'   Rscript print_page.R {URL}
args = "https://yongfu.name/irt1/"
if (!interactive()) {
    args = commandArgs(TRUE)    
}
URL = args[1]

pagedown::chrome_print(URL, verbose = 1, 
                       options=list(scale=.75,
                                    printBackground=F, 
                                    displayHeaderFooter=F)
                       )

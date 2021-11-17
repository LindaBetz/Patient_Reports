# Dies ist eine Shiny-App. Sie können die App ausführen, indem Sie
# die Schaltfläche 'Run App' oben links klicken.


shinyApp(
    # define user interface object
    ui = fluidPage(
        titlePanel("Arztbriefe-Auswertung im FETZ", windowTitle = "Arztbriefe-Auswertung"),
        mainPanel(
            width = '100%',
            helpText(
                "Diese App erlaubt es, automatisiert Arztbrief-Auswertungen für eine:n Patient:in im FETZ zu erstellen. Man benötigt dafür die REDCap-ID und das entsprechende Auswertungs-Datenfile (heruntergeladen von zks-redcap.uni-koeln.de). Die App funktioniert nur mit .csv-Dateien. ÖFFNEN SIE DIE DATEIEN VORHER NICHT IN EXCEL."
            ),
            textInput(
                "REDCap_ID",
                width = '100%',
                label = "Geben Sie hier unten im Feld die REDCap-ID ein, für die die Auswertung erstellt werden soll. Achten Sie auf Tippfehler.",
                value = ""
            ),
            
            fileInput(
                "data",
                label = "Wählen Sie hier die Datei für die Auswertung aus (der Name der Datei beginnt mit FETZDigital_)",
                multiple = FALSE,
                accept = ".csv",
                width = '100%',
                buttonLabel = "Durchsuchen...",
                placeholder = "Keine Datei ausgewählt"
            ),
            helpText(
                "Klicken Sie auf den Knopf unten, um die .pdf-Auswertungs-Datei zu erstellen und zu speichern. Beachten Sie, dass es einige Minuten dauern kann, bis die Datei fertig verarbeitet ist."
            ),
            downloadButton("report", "Auswertung erstellen")
        )
    ),
    # define server() function
    server = function(input, output) {
        output$report <- downloadHandler(
            filename = function() {
                paste("Auswertung_REDCap_ID_", input$REDCap_ID, ".pdf", sep = "")
            },
            content = function(file) {
                # Copy the report file to a temporary directory before processing it, in
                # case we don't have write permissions to the current working dir (which
                # can happen when deployed).
                tempReport <-
                    file.path(getwd(), "generate_report.Rmd")
                
                # Set up parameters to pass to .Rmd document
                params <- list(
                    REDCap_ID = input$REDCap_ID,
                    data = input$data$datapath
                )
                
                # Knit the document, passing in the `params` list, and eval it in a
                # child of the global environment (this isolates the code in the document
                # from the code in this app).
                rmarkdown::render(
                    tempReport,
                    output_file = file,
                    params = params,
                    envir = new.env(parent = globalenv()) # this is important!!!
                )
            }
        )
    }
)

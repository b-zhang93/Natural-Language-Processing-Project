library(shiny)
library(quanteda)
library(dplyr)
library(curl)

source("modelv2.R")
source("stupidbo.R")


# application ui
ui <- navbarPage("N-grams Text Predictor",
                 tabPanel("Predictor",
                          tags$head(
                              # custom css
                              includeCSS("style.css")),
                          
                          h2("This App will Predict the Next Top 3 Words"),
                          h6("Stupid Backoff Model did better during benchmarking, however for most cases it will work the same"),
                          tags$br(),
                          
                          splitLayout(
                              sidebarPanel( 
                                  width = 12,
                                  position = "left",
                                  selectInput("model", "Choose Model:", c("Ngrams Backoff", "Stupid Backoff")),
                                  textInput("phrase","Input Phrase:", value = ""),
                                  submitButton("Predict")
                              ),
                              mainPanel(
                                  widdth = 12,
                                  position = "right",
                                  h4("Predicted Words (Top 3 Possibilities): "),
                                  textOutput("nextword", inline = TRUE)
                              )
                          ),
                          
                          tags$div(id="cite", 'Github Repo', tags$a(href="https://github.com/b-zhang93/Natural-Language-Processing-Project", "Link Here"))
                 ),
                 
                 tabPanel("Documentation",
                          tags$h3("Functionality"),
                          tags$div(
                              "- Select which model you wish to use. Ngrams Backoff model was the original model", tags$br(),
                              "- Stupid Backoff Model performs better, but in most cases the results are similar", tags$br(),
                              "- Type in an incomplete phrase as the input", tags$br(),
                              "- The output panel should predict the next word",tags$br(),
                              "- Prediction is based on n+1 grams up to fourgrams with back off",tags$br(),
                              "- Blank inputs are automatically matched based on unigram frequency",tags$br(),
                              "- Ngrams are built based on twitter, blogs, news text data gathered from SwiftKey: ", tags$a(href="http://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", "Download")),
                          
                          tags$br(),tags$br(),
                          tags$h3("Possible Future Plans"),
                          tags$div(
                              "- Add more complex and accurate models and allow users to select and compare", tags$br(),
                              "- Add a benchmarking function to test each of the models' accuracy and speed", tags$br()
                          ),
                          tags$div(id="cite", 'Github Repo', tags$a(href="https://github.com/b-zhang93/Natural-Language-Processing-Project", "Link Here"))
                 )
)



# back-end functions
server <- (function(input, output) {
    

    
    output$nextword <- renderText(
        # run our predictor based on the model selected
        if(input$model == "Ngrams Backoff" & input$phrase != "") {
            words = predictbo(input$phrase)
            output <- paste(words[1], words[2], words[3], sep=" | ")
        } else if (input$model == "Stupid Backoff" & input$phrase != "") {
            words = predictSBO(input$phrase)
            output <- paste(words[1], words[2], words[3], sep=" | ")
        }
        
    )
    
    
})

shinyApp(ui,server)
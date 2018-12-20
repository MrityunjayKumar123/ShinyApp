


if (!require(shiny)){install.packages("shiny")}
if (!require(udpipe)){install.packages("udpipe")}
if (!require(stringr)){install.packages("stringr")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(readtext)){install.packages("readtext")}
if (!require(textrank)){install.packages("textrank")}
if (!require(wordcloud)){install.packages("wordcloud")}



library(shiny)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)



shinyUI(
  fluidPage(
    
    titlePanel("Text Analytics, An Overview of UDPipe NLP workflow"),
    
    sidebarLayout(
      sidebarPanel(
        
        fileInput("file1", "Select Text File for Analysis"),
        tags$hr(),
        
        
        
        checkboxGroupInput("myupos",label = h4("Select part-of-speech tags (XPOS) for plotting Co-occurrences/Freq Counts/Annotate:"),
                           c("Adjective" = "ADJ",
                             "Propernoun" = "PROPN",
                             "Adverb" = "ADV",
                             "Noun" = "NOUN",
                             "Verb"= "VERB"),
                           selected = c("ADJ","NOUN","VERB"),
                           width = '100%'
        ),
        
        tags$hr(style="border-color: black;"),
        
        tags$head(
          tags$style(HTML("hr {border-top: 2px solid #000000;}"))
        ),
        
        radioButtons("rb","Choose any Language- English, Spanish, Hindi:",
                     choiceNames = list("English","Hindi","Spanish"),
                     choiceValues = list(
                       "English","Hindi", "Spanish"
                     )),
        textOutput("txt"),
        
        tags$hr(style="border-color: black;"),
        
        
        sliderInput("freq", "Select the Frequency of Co-Occurance Graph:", min = 0,  max = 50, value = 30)
      ),
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Overview",h2(p("App Overview")),
                             p("There are three tabs in this appliction."),
                             
                             h4(p("How to use this App")),
                             
                             p("Upload the text files first and then move on to tabs."),
                             
                             
                             p("This app supports only text file (.txt) file."),
                             
                             p("Please refer to the link below for sample txt file."),
                             
                             p("<English Text.>"),
                             a(href="https://github.com/MrityunjayKumar123/Sample-Data/blob/master/amazon%20nokia%20lumia%20reviews.txt"
                               ,"Download from  here"),
                             
                             
                             p("<Spanish Text.>"),
                             a(href=" https://github.com/MrityunjayKumar123/Sample-Data/blob/master/Spanish.txt"
                               ,"Download from  here"),
                             
                             p("<Hindi Text.>"),
                             a(href="https://github.com/MrityunjayKumar123/Sample-Data/blob/master/Gaban_Hindi.txt"
                               ,"Download from  here"),
                            
                             
                             
                             
                             p("1:- Frequency count:- It will count the frequencies of NOUN,ADJ,VERB,ADVERB and PRONOUN presents in text by graph."),
                             p("2:- Co-Occurance Plot:-  Co-occurrence can mean two words occurring together in the same document."),
                             p("3:- Annotated Document:- Elements of an annotation with names 'description' and 'wording' have a special meaning.")
                             
                             
                             
                             
                             
                             
                             
                    ),
                    
                    tabPanel("Frequencies Counts Plot",
                             h4("Noun/verb"),
                             plotOutput('plot0'),
                             h4("Nouns"),
                             plotOutput('plot1'),
                             h4("Verbs"),
                             plotOutput('plot2'),
                             h4("Adverbs"),
                             plotOutput('plot3'),
                             h4("Adjectives"),
                             plotOutput('plot4')),
                    tabPanel("Co-Occurance Plot", plotOutput("Cooccurance")),
                    tabPanel("Annotate",dataTableOutput('Annotate'))
                    
                    
        )
        
        
      )
      
    )
  ))

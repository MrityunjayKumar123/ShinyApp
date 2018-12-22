
library(shiny)
library(readtext)


shinyServer(function(input, output) {
    Dataset <- reactive({
      
    file1 = input$file1
    if (is.null(file1$datapath)) { return(NULL) } else
    {
      
      require(stringr)
      Data <- readLines(file1$datapath)
      Data  =  str_replace_all(Data, "<.*?>", "")
      return(Data)
      
    }
  })  
  
  an <- reactive({
    
    # For English languge selection
    
    if(input$rb == 'English')
    {
      model <- udpipe_download_model(language = "english")
       udmodel_english <- udpipe_load_model(file = 'english-ud-2.0-170801.udpipe')
       txt <- as.character(Dataset())
       txt <- udpipe_annotate(udmodel_english, x=txt)
       txt <- as.data.frame(txt)
       return(txt)
      
      } else if(input$rb == 'Hindi')
        {
      
           model <- udpipe_download_model(language = "hindi", udpipe_model_repo = "jwijffels/udpipe.models.ud.2.0")
           udmodel_hindi <- udpipe_load_model(file = model$file_model)
           txt <- as.character(Dataset())
           x <- udpipe_annotate(udmodel_hindi, x = txt)
           x <- as.data.frame(x)
           x <- udpipe_annotate(udmodel_hindi, x = txt)
           return(x)
        
           
           
           
           
        } else if (input$rb =='Spanish')
            {
              model <- udpipe_download_model(language = "spanish-ancora",  udpipe_model_repo ="bnosac/udpipe.models.ud")
              spanish_model = udpipe_load_model(file = 'spanish-ud-2.0-170801.udpipe')
              txt <- as.character(Dataset())
              txt <- udpipe_annotate(spanish_model, x=txt)
              txt <- as.data.frame(txt)
              return(txt)
            }
  })
  
  output$Annotate <- renderDataTable(
    {
      out <- an() 
      return(out)
    }
  )
  
  output$txt <- renderText({
  paste("You chose", input$rb)
    out <- an() 
    return(out)
  
  })
  
  output$Cooccurance <- renderPlot(
    {
      
      model <- udpipe_download_model(language = "english")
      udmodel_english <- udpipe_load_model(file = 'english-ud-2.0-170801.udpipe')
      txt <- as.character(Dataset())
      txt <- udpipe_annotate(udmodel_english, x=txt)
      txt <- as.data.frame(txt)
      
      data_cooc <- udpipe::cooccurrence(x = subset(txt, upos %in% input$myupos), term = "lemma", 
                                        group = c("doc_id", "paragraph_id", "sentence_id")
                                        
      )
      
      library(igraph)
      library(ggraph)
      library(ggplot2)
      wordnetwork <- head(data_cooc, input$freq)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork)
      ggraph(wordnetwork, layout = "fr") + geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        theme_graph(base_family = "Arial Narrow") +
        theme(legend.position = "none") +
        labs(title = "Cooccurrences within 3 words distance")
    }
  )
  
  

  
  output$plot1 = renderPlot({
    if('NOUN'  %in% input$myupos)
    {
      
      stats <- an() %>% subset(., upos %in% "NOUN") 
      stats <- txt_freq(stats$token)
      stats$key <- factor(stats$key, levels = rev(stats$key))
      barchart(key ~ freq, data = head(stats, 20), col = "cadetblue", 
               main = "Most occurring nouns", xlab = "Freq")
      
    } 
    else
    {return(NULL)}
  })
  

  output$plot0 = renderPlot({
    if('VERB' %in% input$myupos)
    {
    
      all_verbs = an()%>% subset(., upos %in% "VERB"); all_verbs$token[1:20]
      top_verbs = txt_freq(all_verbs$lemma)
      library(wordcloud)
      wordcloud(words = top_verbs$key, 
                freq = top_verbs$freq, 
                min.freq = 2, 
                max.words = 100,
                random.order = FALSE, 
                scale=c(15, .4),
                colors = brewer.pal(10, "Dark2"))

    } 
    
    if('NOUN' %in% input$myupos  )
    {
      
      all_nouns = an()%>% subset(., upos %in% "NOUN"); all_nouns$token[1:20]
      top_nouns = txt_freq(all_nouns$lemma)
      wordcloud(words = top_nouns$key, 
                freq = top_nouns$freq, 
                min.freq = 2, 
                max.words = 100,
                scale=c(20, .8),
                random.order = FALSE, 
                colors = brewer.pal(10, "Dark2"))
    }
    
    
  })
  
  output$plot2 = renderPlot({
    if('VERB' %in% input$myupos)
    {
      stats <- an() %>% subset(., upos %in% "VERB") 
      stats <- txt_freq(stats$token)
      stats$key <- factor(stats$key, levels = rev(stats$key))
      barchart(key ~ freq, data = head(stats, 20), col = "gold", 
               main = "Most occurring Verbs", xlab = "Freq")
    } 
    else
    {return(NULL)}
    
  })
  
  
  output$plot3 = renderPlot({
    
    if('ADV'  %in% input$myupos)
    {
      ## ADJECTIVES
      stats <- an() %>% subset(., upos %in% "ADV") 
      stats <- txt_freq(stats$token)
      stats$key <- factor(stats$key, levels = rev(stats$key))
      barchart(key ~ freq, data = head(stats, 20), col = "purple", 
               main = "Most occurring adjectives", xlab = "Freq")
    } 
    else
    {return(NULL)}
  })
  
  output$plot4 = renderPlot({
    
    if('ADJ'  %in% input$myupos)
    {
      stats <- an() %>% subset(., upos %in% "ADJ") 
      stats <- txt_freq(stats$token)
      stats$key <- factor(stats$key, levels = rev(stats$key))
      barchart(key ~ freq, data = head(stats, 20), col = "green", 
               main = "Most occurring adjectives", xlab = "Freq")
      
      
    } 
    else
    {return(NULL)}
    
    
  })
  
  
})


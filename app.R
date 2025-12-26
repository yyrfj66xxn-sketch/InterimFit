library(shiny)
library(e1071)

# ======================
# Chargement des objets
# ======================
df_model <- readRDS("df_model.rds")
modele_final <- readRDS("modele_final.rds")

# ======================
# UI
# ======================
ui <- fluidPage(
  
  # 🎨 STYLE GLOBAL
  tags$style(HTML("
    body {
      background-color: #f5f7fa;
      font-family: Arial, sans-serif;
    }

    h2 {
      text-align: center;
      font-weight: 900;
      letter-spacing: 4px;
      margin-bottom: 30px;
    }

    /* SIDEBAR SHINY */
    .well {
      background-color: #0d6efd;
      color: white;
      padding: 20px;
    }

    .well label {
      color: white;
      font-weight: bold;
    }

    .well select, .well input {
      color: black;
    }

    /* ZONE RESULTAT */
    .result-box {
      background-color: #0b5ed7;
      color: white;
      padding: 30px;
      border-radius: 18px;
      margin-top: 30px;
      text-align: center;
    }

    .thermo-container {
      width: 70%;
      margin: 25px auto;
      background-color: rgba(255,255,255,0.25);
      border-radius: 12px;
    }

    .thermo-bar {
      height: 38px;
      background-color: #ffc107;
      border-radius: 12px;
      text-align: center;
      color: black;
      font-weight: bold;
      line-height: 38px;
      font-size: 18px;
    }

    .fun-text {
      font-size: 18px;
      margin-top: 15px;
      font-style: italic;
    }
  ")),
  
  h2("INTERIM FIT"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      numericInput("age", "Âge de l’étudiant 🎂", value = 21, min = 18, max = 30),
      
      selectInput("experience", "Expérience en intérim 💼",
                  choices = levels(df_model$experience)),
      
      selectInput("charge_etudes", "Charge actuelle d’études 📚",
                  choices = levels(df_model$charge_etudes)),
      
      selectInput("sport", "Fréquence d’activité sportive 🏃‍♂️",
                  choices = levels(df_model$sport)),
      
      selectInput("boursier", "Statut de boursier 🎓",
                  choices = levels(df_model$boursier)),
      
      selectInput("charges", "Charges fixes mensuelles 💸",
                  choices = levels(df_model$charges)),
      
      selectInput("aide", "Aide financière familiale 🤝",
                  choices = levels(df_model$aide)),
      
      selectInput("autonomie", "Autonomie financière sans mission ⏳",
                  choices = levels(df_model$autonomie)),
      
      sliderInput(
        "trajet_minutes",
        "Temps de trajet aller simple 🚇 (minutes)",
        min = 0, max = 180, value = 30, step = 5
      ),
      
      selectInput(
        "jours_affiles",
        "Nombre de jours travaillés d’affilée 📆",
        choices = levels(df_model$jours_affiles)
      ),
      
      selectInput("mission", "Type de mission proposée 🧰",
                  choices = levels(df_model$mission)),
      
      br(),
      
      actionButton("predict", "Analyser la compatibilité 🚀", class = "btn-warning"),
      br(), br(),
      actionButton("reset", "Réinitialiser 🔄", class = "btn-light")
    ),
    
    mainPanel(
      uiOutput("result_ui")
    )
  )
)

# ======================
# SERVER
# ======================
server <- function(input, output, session) {
  
  # 🔄 RESET
  observeEvent(input$reset, {
    
    updateNumericInput(session, "age", value = 21)
    updateSliderInput(session, "trajet_minutes", value = 30)
    
    updateSelectInput(session, "experience",
                      selected = levels(df_model$experience)[1])
    updateSelectInput(session, "charge_etudes",
                      selected = levels(df_model$charge_etudes)[1])
    updateSelectInput(session, "sport",
                      selected = levels(df_model$sport)[1])
    updateSelectInput(session, "boursier",
                      selected = levels(df_model$boursier)[1])
    updateSelectInput(session, "charges",
                      selected = levels(df_model$charges)[1])
    updateSelectInput(session, "aide",
                      selected = levels(df_model$aide)[1])
    updateSelectInput(session, "autonomie",
                      selected = levels(df_model$autonomie)[1])
    updateSelectInput(session, "jours_affiles",
                      selected = levels(df_model$jours_affiles)[1])
    updateSelectInput(session, "mission",
                      selected = levels(df_model$mission)[1])
    
    output$result_ui <- renderUI(NULL)
  })
  
  # ▶️ PRÉDICTION
  observeEvent(input$predict, {
    
    nouveau_profil <- data.frame(
      age = input$age,
      experience = factor(input$experience, levels = levels(df_model$experience)),
      charge_etudes = factor(input$charge_etudes, levels = levels(df_model$charge_etudes)),
      sport = factor(input$sport, levels = levels(df_model$sport)),
      boursier = factor(input$boursier, levels = levels(df_model$boursier)),
      charges = factor(input$charges, levels = levels(df_model$charges)),
      aide = factor(input$aide, levels = levels(df_model$aide)),
      autonomie = factor(input$autonomie, levels = levels(df_model$autonomie)),
      trajet_minutes = input$trajet_minutes,
      jours_affiles = factor(input$jours_affiles, levels = levels(df_model$jours_affiles)),
      mission = factor(input$mission, levels = levels(df_model$mission))
    )
    
    proba <- predict(modele_final, nouveau_profil, type = "raw")[, "Oui"]
    
    # Limite UX (éviter 100 % affiché)
    proba_affichee <- min(proba, 0.95)
    pct <- round(proba_affichee * 100)
    
    message_fun <- if (pct >= 85) {
      "🔥 GO FONCE ! Cette mission est faite pour toi 😎"
    } else if (pct >= 70) {
      "👍 Plutôt solide ! Avec une bonne organisation, ça passe 😉"
    } else if (pct >= 55) {
      "🤔 Ça se tente… mais attention à la fatigue 😅"
    } else {
      "🚨 Mission risquée… pense à préserver ton énergie 💤"
    }
    
    output$result_ui <- renderUI({
      div(class = "result-box",
          h3("Résultat de l’analyse 📊"),
          
          div(class = "thermo-container",
              div(class = "thermo-bar",
                  style = paste0("width:", pct, "%;"),
                  paste0(pct, "%")
              )
          ),
          
          div(class = "fun-text", message_fun),
          
          br(),
          p("🔎 Estimation basée sur des profils étudiants similaires.")
      )
    })
  })
}

# ======================
# LANCEMENT
# ======================
shinyApp(ui, server)

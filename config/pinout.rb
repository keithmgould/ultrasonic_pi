# Declare our pinout
PINS = { exit_error:  2,
         entry_error: 3,
         missing_error: 4,
         reset: 14,
         status: 15,
         entry_sensor:  { trigger: 17,  echo: 27 },
         exit_sensor:   { trigger: 18, echo: 22 },
         inside_sensor: { trigger: 23, echo: 24 }
       }

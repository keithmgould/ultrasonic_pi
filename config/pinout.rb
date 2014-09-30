# Declare our pinout
PINS = { exit_error:  2,
         entry_error: 3,
         missing_error: 4,
         reset: 7,
         status: 27,
         entry_sensor:  { trigger: 8,  echo: 9 },
         exit_sensor:   { trigger: 10, echo: 11 },
         inside_sensor: { trigger: 28, echo: 29 },
         beam_sensors: [
            { trigger: 14, echo: 15 },
            { trigger: 17, echo: 18 },
            { trigger: 22, echo: 23 },
            { trigger: 24, echo: 25 },
            { trigger: 30,  echo: 31 }
         ]
       }

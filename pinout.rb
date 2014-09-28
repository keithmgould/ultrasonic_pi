# Declare our pinout
PINS = { buzzer: 2,
         reset:  3,
         status: 4,
         entry_sensor: { trigger: 8,  echo: 9 },
         exit_sensor:  { trigger: 10, echo: 11 },
         beam_sensors: [
            { trigger: 14, echo: 15 },
            { trigger: 17, echo: 18 },
            { trigger: 22, echo: 23 },
            { trigger: 24, echo: 25 },
            { trigger: 7,  echo: 27 }
         ]
       }

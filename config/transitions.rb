  # Bit positions for determining state.  See Valid Transisions below for more details
  #
  # ENTRY_SENSOR  = 3
  # INSIDE_SENSOR = 2
  # EXIT_SENSOR   = 1
  # BEAM          = 0

  # Each state is determined by looking at the integer representation of the 4 bits shown above.
  # So if the entry sensor is on, and the beam has been broken, that would be 1001 or '9'
  VALID_TRANSITIONS = [
    # 0 => entry off, inside off, exit off, beam off
    { valid: [8], invalid_entry: [], invalid_exit: [2,3,6,7], missed_ingredient: [] },

    # 1 => entry off, inside off, exit off, beam on
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 2 => entry off, inside off, exit on, beam off
    { valid: [6,3], invalid_entry: [8,9,12,13], invalid_exit: [], missed_ingredient: [0] },

    # 3 => entry off, inside off, exit on, beam on
    { valid: [7,0], invalid_entry: [8,9,12,13], invalid_exit: [], missed_ingredient: [] },

    # 4 => entry off, inside on, exit off, beam off
    { valid: [12,6,5], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 5 => entry off, inside on, exit off, beam on
    { valid: [13,7], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 6 => entry off, inside on, exit on, beam off
    { valid: [4,2,7], invalid_entry: [8,9,12,13], invalid_exit: [], missed_ingredient: [] },

    # 7 => entry off, inside on, exit on, beam on
    { valid: [5,3], invalid_entry: [8,9,12,13], invalid_exit: [], missed_ingredient: [] },

    # 8 => entry on, inside off, exit off, beam off
    { valid: [0,12,9], invalid_entry: [], invalid_exit: [2,3,6,7], missed_ingredient: [] },

    # 9 => entry on, inside off, exit off, beam on
    { valid: [13], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 10 => entry on, inside off, exit on, beam off
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 11 => entry on, inside off, exit on, beam on
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 12 => entry on, inside on, exit off, beam off
    { valid: [8,4], invalid_entry: [], invalid_exit: [2,3,6,7], missed_ingredient: [] },

    # 13 => entry on, inside on, exit off, beam on
    { valid: [9,5], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 14 => entry on, inside on, exit on, beam off
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 15 => entry on, inside on, exit on, beam on
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] }
  ]

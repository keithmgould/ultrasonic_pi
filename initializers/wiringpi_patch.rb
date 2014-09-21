# Monkey Patch to use GPIO 27.
# Was not included in the WiringPi repo.
# This is in a PR that the maintainer is ignoring.

module WiringPi
  class GPIO
    GPIO_PINS = [2,3,4,7,8,9,10,11,14,15,17,18,22,23,24,25,27]
  end
end

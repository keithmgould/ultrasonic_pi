import time
import RPi.GPIO as GPIO
from ADCpy import readadc

# change these as desired - they're the pins connected from the
# SPI port on the ADC to the Cobbler
SPICLK = 18
SPIMISO = 23
SPIMOSI = 24
SPICS = 25

# set up the SPI interface pins
GPIO.setup(SPIMOSI, GPIO.OUT)
GPIO.setup(SPIMISO, GPIO.IN)
GPIO.setup(SPICLK, GPIO.OUT)
GPIO.setup(SPICS, GPIO.OUT)

while True:
	adcldr = 0
	read_adc1 = readadc(adcldr, SPICLK, SPIMOSI, SPIMISO, SPICS)
	millivolts = read_adc1 * (3300.0 / 1024.0)
	if millivolts < 1200:
		print "TRIPPED! light level = %.2f" % millivolts
		time.sleep(0.25)
	
	

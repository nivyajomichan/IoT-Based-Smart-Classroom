from pyfingerprint.pyfingerprint import PyFingerprint

sensor = PyFingerprint("/dev/ttyUSB0", 57600, 0xFFFFFFFF, 0x00000000)
sensor.verifyPassword()

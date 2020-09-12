#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

Adafruit_BNO055 bno = Adafruit_BNO055(-1, 0x28);

void setup(void) {
  Serial.begin(115200);
  if(!bno.begin()) {
    Serial.print("Error: Couldn't detect the BNO055!");
    while(1);
  }
  delay(1000);
}

void loop(void) {
  /* Get new sensor event */
  sensors_event_t event;
  bno.getEvent(&event);

  /* Get quaternion*/
  imu::Quaternion q = bno.getQuat();
  q.normalize();
  
  /* Provide quaternion data */
  Serial.print(F("Quaternion: "));
  Serial.print(q.w(), 5);
  Serial.print(F(" "));
  Serial.print(q.x(), 5);
  Serial.print(F(" "));
  Serial.print(q.y(), 5);
  Serial.print(F(" "));
  Serial.print(q.z(), 5);
  Serial.println(F(""));
  
  /* Provide calibration data */
  uint8_t sys, gyro, accel, mag = 0;
  bno.getCalibration(&sys, &gyro, &accel, &mag);
  Serial.print(F("Calibration: "));
  Serial.print(sys, DEC);
  Serial.print(F(" "));
  Serial.print(gyro, DEC);
  Serial.print(F(" "));
  Serial.print(accel, DEC);
  Serial.print(F(" "));
  Serial.println(mag, DEC);

  delay(100);
}

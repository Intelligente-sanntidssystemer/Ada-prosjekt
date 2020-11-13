with NRF52_DK.Time;
with HAL; use HAL;
with NRF52_DK.IOs;


package body sensor_behind is
      --Declaration of the PinIDs and type of the variables
      TrigPin : NRF52_DK.IOs.Pin_Id := 12;
      EchoPin : NRF52_DK.IOs.Pin_Id := 11;
      CurrentTime : NRF52_DK.Time.Time_Ms;
      Duration_Result : Duration;
      Pulse : Boolean;
       
   function HCSR04_Behind_Distance return Float is
   begin
      CurrentTime := NRF52_DK.Time.Clock;
      --Making sure the TrigPin is clear so we set it on false for 2 microseconds.
      NRF52_DK.IOs.Set(TrigPin, False);
      NRF52_DK.Time.Delay_Ms(Uint64(CurrentTime / 1000) + UInt64 (2 / 1000));
      
      CurrentTime := NRF52_DK.Time.Clock;
      
      --To generate the ultra sound wave we have to set the TrigPin on high/true state for 10 microseconds.
   
      NRF52_DK.IOs.Set(TrigPin, True);
      NRF52_DK.Time.Delay_Ms (Uint64(CurrentTime / 1000) +UInt64 (10 / 1000));
      NRF52_DK.IOs.Set(TrigPin, False);

      --We need to make sure there isn't any interrupts between these parts

      Pulse := NRF52_DK.IOs.Set(EchoPin);
      
      --Returns duration when EchoPin is HIGH.
      if NRF52_DK.IOs.Set(EchoPin) = True then
         CurrentTime := NRF52_DK.Time.Clock;
         
         --Supposed to return make the result into a duration but due to 
         --NRF52_DK packages not having a function for that and Ada.Real_time not working, we couldn't make the code function properly.
         Duration_Result := Ada.Real_Time.To_Duration(NRF52_DK.Time.Clock - CurrentTime);
         return (Float(Duration_Result) / 58.0) * 1000000.0;
         --In order to get the distance we will divide the Duration_Result with 58 
         --and then multiply it with 1000000 which turns the microseconds into seconds.

      end if;
   
      return -1.0;
      
   end HCSR04_Behind_Distance;
   
   --Source: https://github.com/gamegine/HCSR04-ultrasonic-sensor-lib/blob/master/src/HCSR04.cpp   

end sensor_behind;

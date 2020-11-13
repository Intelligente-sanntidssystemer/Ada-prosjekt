with NRF52_DK.Time;
with HAL; use HAL;
with NRF52_DK.IOs;


package body sensor_behind is
   TrigPin : NRF52_DK.IOs.Pin_Id := 12;
   EchoPin : NRF52_DK.IOs.Pin_Id := 11;
   CurrentTime : NRF52_DK.Time.Time_Ms;
   Duration_Result : NRF52_DK.Time.Time_Ms;
   Pulse : Boolean;
   
   function HCSR04_Behind_Distance return Float is
   begin
      CurrentTime := NRF52_DK.Time.Clock;
      NRF52_DK.IOs.Set(TrigPin, False);
      NRF52_DK.Time.Delay_Ms(Uint64(CurrentTime / 1000) + UInt64 (2 / 1000));
      
      CurrentTime := NRF52_DK.Time.Clock;
      NRF52_DK.IOs.Set(TrigPin, True);
      NRF52_DK.Time.Delay_Ms (Uint64(CurrentTime / 1000) +UInt64 (10 / 1000));
      NRF52_DK.IOs.Set(TrigPin, False);
      
      --There must be no interrupts between these parts.
      
      Pulse := NRF52_DK.IOs.Set(EchoPin);
      
      if NRF52_DK.IOs.Set(EchoPin) = True then
         CurrentTime := NRF52_DK.Time.Clock;
         
         Duration_Result := (NRF52_DK.Time.Clock - CurrentTime);
         return (Float(Duration_Result) / 58.0) * 1000000.0;
      end if;
   
      return -1.0;
      
   end HCSR04_Behind_Distance;
      
end sensor_behind;


with NRF52_DK.Time; use NRF52_DK.Time;
with HAL; use HAL;


package body sensor is


   function Distance(TrigPin, EchoPin : NRF52_DK.IOs.Pin_Id) return Float is
      TimeNow : Time_Ms;
      --Maximum distance of sensor is 400cm = 23200uS. We add a 1ms margin on top of that
      DeadlineMicroseconds : constant Integer := 5800;
      Duration_Result : Time_Ms;
      Pulse : Boolean;
      DistanceLimit : constant Float := 100.0;
   begin

      TimeNow := NRF52_DK.Time.Clock;
      NRF52_DK.IOs.Set(TrigPin, False);
      NRF52_DK.Time.Delay_Ms(UInt64 (2 / 1000));


      NRF52_DK.IOs.Set(TrigPin, True);
      NRF52_DK.Time.Delay_Ms (UInt64 (2 / 1000));
      NRF52_DK.IOs.Set(TrigPin, False);

      --There must be no interrupts between these parts.

      Pulse := NRF52_DK.IOs.Set(EchoPin);

      while Pulse = NRF52_DK.IOs.Set(EchoPin) loop
         --Wait for the analog signal to change from low - high or high - low
         null;
      end loop;


         Duration_Result := (NRF52_DK.Time.Clock - TimeNow);

      return (Float(Duration_Result) / 58.0) * 1000000.0;


         -- https://github.com/gamegine/HCSR04-ultrasonic-sensor-lib/blob/master/src/HCSR04.cpp


      return -1.0;

      --Something went wrong if we end up here!
   end Distance;

end sensor;

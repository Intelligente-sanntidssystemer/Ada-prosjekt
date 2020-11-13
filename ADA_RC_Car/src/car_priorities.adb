with Sensor;
with sensor_behind;
with steeringcontrol;
with NRF52_DK.Time;
with NRF52_DK.IOs;
with NRF52_DK.Buttons; use NRF52_DK.Buttons;
with HAL; use HAL;

package body car_priorities is
   Sensor_Deadline : constant Integer := 6; --Sensor deadline in milliseconds
   Next_Deadline : NRF52_DK.Time.Time_Ms := NRF52_DK.Time.Clock;
   Period_Time : NRF52_DK.Time.Time_Ms := NRF52_DK.Time.Clock;
     
   task body Emergency_Stop is
      Deadline_Distance : Float := 100.0; --Deadline distance which is 100cm.
   begin
      loop
         delay until Next_Deadline;
         Period_Time := NRF52_DK.Time.Clock;
         while Sensor.HCSR04_Distance < Deadline_Distance loop
            SteeringControl.Crash_Stop_Forward;
         end loop;
         
         while sensor_behind.HCSR04_Behind_Distance < Deadline_Distance loop
            SteeringControl.Crash_Stop_Backward;
         end loop;
         Next_Deadline := Next_Deadline + (NRF52_DK.Time.Clock - Period_Time);
         
      end loop;
   end Emergency_Stop;
   
   task body Motor_Steering is
   begin
      loop
         delay until Next_Deadline;
         Period_Time := NRF52_DK.Time.Clock;
         SteeringControl.Motor_Controller;
         Next_Deadline := Next_Deadline + (NRF52_DK.Time.Clock - Period_Time);
      end loop;
      
   end Motor_Steering;
   
   task body Direction_Steering is
   begin
      loop
         delay until Next_Deadline;
         Period_Time := NRF52_DK.Time.Clock;
         SteeringControl.Direction_Controller;
         Next_Deadline := Next_Deadline + (NRF52_DK.Time.Clock - Period_Time);
      end loop;
   end Direction_Steering;
   
begin
   null;
end car_priorities;

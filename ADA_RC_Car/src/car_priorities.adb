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
   Deadline_Distance : Float := 100.0; --Max distance which is 100cm 
   
   begin
      loop
         --This is the highest priority task
         --The idea here is to put a delay until Next_Deadline which is the Clock function
         --In NRF52_DK.Time package and at the end of the function we update the Next_Deadline
         --with the time spent to run this loop
      delay until Next_Deadline; -- SENSOR HAS HARD DEADLINE --
      Period_Time := NRF52_DK.Time.Clock;
      if Sensor.HCSR04_Distance < Deadline_Distance then -- Emergency stop condition activated --
         while Sensor.HCSR04_Distance < Deadline_Distance loop -- if distance front is too close, stop running forward
            SteeringControl.Crash_Stop_Forward; 
         end loop;
         
         while sensor_behind.HCSR04_Behind_Distance < Deadline_Distance loop -- If back distance is too close, stop running backwards
            SteeringControl.Crash_Stop_Backward;
         end loop;
      end if;
      Next_Deadline := Next_Deadline + (NRF52_DK.Time.Clock - Period_Time);
      end loop;
   end Emergency_Stop;
   
   
   task body Motor_Steering is
   begin
      loop
         --This is supposed to be the 2nd highest priority task, ideally this will run
         --after the Emergency_Stop and update the Next_Deadline at the end of the loop which
         --carries over to the next task.
         delay until Next_Deadline;
         Period_Time := NRF52_DK.Time.Clock;
         SteeringControl.Motor_Controller; --This tasks allows motor controls forward/backward --
         Next_Deadline := Next_Deadline + (NRF52_DK.Time.Clock - Period_Time);
      end loop;
      
   end Motor_Steering;
   
   task body Direction_Steering is
   begin
      loop
         --The lowest priority task we have currently and this will run after the other two
         --higher priority tasks with an update to Next_Deadline at the end. 
         delay until Next_Deadline;
         Period_Time := NRF52_DK.Time.Clock;
         SteeringControl.Direction_Controller; --This tasks allows turning of car--
         Next_Deadline := Next_Deadline + (NRF52_DK.Time.Clock - Period_Time);
      end loop;
   end Direction_Steering;
   
begin
   null;
end car_priorities;

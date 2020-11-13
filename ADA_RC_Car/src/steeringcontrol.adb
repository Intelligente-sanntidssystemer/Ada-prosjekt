with NRF52_DK.Time;
with NRF52_DK.IOs;
with NRF52_DK.Buttons; use NRF52_DK.Buttons;

package body SteeringControl is
   
   procedure Servocontrol(ServoPin : NRF52_DK.IOs.Pin_Id; Value : NRF52_DK.IOs.Analog_Value) is    --Servo --
      
   begin
      --Writing values to the servo motor.
      NRF52_DK.IOs.Write(ServoPin,Value);
      NRF52_DK.IOs.Set_Analog_Period_Us(20000);
      NRF52_DK.Time.Delay_Ms (2);

   end Servocontrol;
   
   procedure Direction_Controller is --Turning left/right with buttons by changing servo degrees --
   begin
      Servocontrol(3,300);
      loop
         while NRF52_DK.Buttons.State(Button_1) = Pressed loop
            Servocontrol(3,200); --0value at 0 degrees, 200value medium state, 400value max degrees 180
            if NRF52_DK.Buttons.State(Button_1) = Released then
               Servocontrol(3,300);
            end if;
         end loop;
         while (NRF52_DK.Buttons.State(Button_2) = Pressed) loop
            Servocontrol(3,400); --0value at 0 degrees, 200value medium state, 400value max degrees 180
            if NRF52_DK.Buttons.State(Button_2) = Released then
               Servocontrol(3,300);
            end if;
         end loop;

      end loop;
   end Direction_Controller;
   
   procedure Motor_Controller is  --Forward/Backward using buttons --
   begin
   loop
            --CLOCKWISE
      while (NRF52_DK.Buttons.State(Button_3) = Pressed) loop -- DRIVE FORWARD --
         NRF52_DK.IOs.Set (27, True);
         NRF52_DK.Time.Delay_Ms (5);
         NRF52_DK.IOs.Set (27, false);
         NRF52_DK.Time.Delay_Ms (5);

         NRF52_DK.IOs.Set (21, True);
         NRF52_DK.Time.Delay_Ms (5);
         NRF52_DK.IOs.Set (21, False);
         NRF52_DK.Time.Delay_Ms (5);

         NRF52_DK.IOs.Set (23, True);
         NRF52_DK.Time.Delay_Ms (5);
         NRF52_DK.IOs.Set (23, False);
         NRF52_DK.Time.Delay_Ms (5);
      end loop;
      while (NRF52_DK.Buttons.State(Button_4) = Pressed) loop -- DRIVE Backward --
         --Anti CLOCKWISE
         NRF52_DK.IOs.Set (23, True);
         NRF52_DK.Time.Delay_Ms (5);
         NRF52_DK.IOs.Set (23, False);
         NRF52_DK.Time.Delay_Ms (5);

         NRF52_DK.IOs.Set (21, True);
         NRF52_DK.Time.Delay_Ms (5);
         NRF52_DK.IOs.Set (21, False);
         NRF52_DK.Time.Delay_Ms (5);

         NRF52_DK.IOs.Set (27, True);
         NRF52_DK.Time.Delay_Ms (5);
         NRF52_DK.IOs.Set (27, False);
         NRF52_DK.Time.Delay_Ms (5);
      end loop;
   end loop;
      
   end Motor_Controller;
   
   procedure Crash_Stop_Forward is
   begin
      --This function will run when the sensor in front is triggering an emergency.
      --The idea was so every time we tried to drive forward while the sensor in front
      --is active, then this would run and run a loop of backwards on motor in order
      --to even it out, since we thought it sounded better than stopping the motor completely.
      --BACKWARD LOOP
         NRF52_DK.IOs.Set (23, True);
         NRF52_DK.Time.Delay_Ms (5);
         NRF52_DK.IOs.Set (23, False);
         NRF52_DK.Time.Delay_Ms (5);

         NRF52_DK.IOs.Set (21, True);
         NRF52_DK.Time.Delay_Ms (5);
         NRF52_DK.IOs.Set (21, False);
         NRF52_DK.Time.Delay_Ms (5);

         NRF52_DK.IOs.Set (27, True);
         NRF52_DK.Time.Delay_Ms (5);
         NRF52_DK.IOs.Set (27, False);
         NRF52_DK.Time.Delay_Ms (5);
      
   end Crash_Stop_Forward;  
   
   procedure Crash_Stop_Backward is
   begin
      --Same thing here as with the function above, but here we run a forward loop.
      --FORWARD LOOP
         NRF52_DK.IOs.Set (27, True);
         NRF52_DK.Time.Delay_Ms (5);
         NRF52_DK.IOs.Set (27, false);
         NRF52_DK.Time.Delay_Ms (5);

         NRF52_DK.IOs.Set (21, True);
         NRF52_DK.Time.Delay_Ms (5);
         NRF52_DK.IOs.Set (21, False);
         NRF52_DK.Time.Delay_Ms (5);

         NRF52_DK.IOs.Set (23, True);
         NRF52_DK.Time.Delay_Ms (5);
         NRF52_DK.IOs.Set (23, False);
         NRF52_DK.Time.Delay_Ms (5);
   end Crash_Stop_Backward;
   
        
end SteeringControl;

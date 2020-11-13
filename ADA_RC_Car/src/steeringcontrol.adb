with NRF52_DK.Time;
with NRF52_DK.IOs;
with NRF52_DK.Buttons; use NRF52_DK.Buttons;

package body SteeringControl is
   Direction_Control : NRF52_DK.Buttons.State := Released;
   Motor_Control : NRF52_DK.Buttons.State := Released;
   
   procedure Servocontrol(ServoPin : NRF52_DK.IOs.Pin_Id; Value : NRF52_DK.IOs.Analog_Value) is 
      
   begin
      --Writing values to the servo motor.
      NRF52_DK.IOs.Write(ServoPin,Value);
      NRF52_DK.IOs.Set_Analog_Period_Us(20000);
      NRF52_DK.Time.Delay_Ms (2);

   end Servocontrol;
   
   procedure Direction_Controller is
   begin
      --Direction control using buttons to control the servo.
      --When one button is pressed it goes one way and the other one the another way.
      Case Direction_Control is
         when NRF52_DK.Buttons.State(Button_1) = Pressed =>
            Servocontrol(3,200);
            if NRF52_DK.Buttons.State(Button_1) = Released then
               Servocontrol(3,300);
            end if;
         when NRF52_DK.Buttons.State(Button_2) = Pressed =>
            Servocontrol(3,400);
            if NRF52_DK.Buttons.State(Button_2) = Released then
               Servocontrol(3,300);
            end if;
      end case;
   end Direction_Controller;
   
   procedure Motor_Controller is
   begin
      Case Motor_Control is
         --2 buttons to control the motor in order to get the car to drive forwards/backwards.
         when NRF52_DK.Buttons.State (Button_3) = Pressed =>
            --FORWARD
            NRF52_DK.IOs.Set (13, True);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
            NRF52_DK.IOs.Set (13, false);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
            
            NRF52_DK.IOs.Set (27, True);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
            NRF52_DK.IOs.Set (27, False);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
            
            NRF52_DK.IOs.Set (21, True);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
            NRF52_DK.IOs.Set (21, False);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
            
            NRF52_DK.IOs.Set (23, True);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
            NRF52_DK.IOs.Set (23, False);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
         when NRF52_DK.Buttons.State (Button_4) = Pressed =>
            --BACKWARDS
            NRF52_DK.IOs.Set (23, True);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
            NRF52_DK.IOs.Set (23, False);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
            
            NRF52_DK.IOs.Set (21, True);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
            NRF52_DK.IOs.Set (21, False);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
            
            NRF52_DK.IOs.Set (27, True);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
            NRF52_DK.IOs.Set (27, False);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));

            NRF52_DK.IOs.Set (13, True);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
            NRF52_DK.IOs.Set (13, false);
            NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
      end case; 
      
   end Motor_Controller;
   
   procedure Crash_Stop_Forward is
   begin
      --This function will run when the sensor in front is triggering an emergency.
      --The idea was so every time we tried to drive forward while the sensor in front
      --is active, then this would run and run a loop of backwards on motor in order
      --to even it out, since we thought it sounded better than stopping the motor completely.
      --BACKWARD LOOP
      NRF52_DK.IOs.Set (23, True);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
      NRF52_DK.IOs.Set (23, False);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
         
      NRF52_DK.IOs.Set (21, True);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
      NRF52_DK.IOs.Set (21, False);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));

      NRF52_DK.IOs.Set (27, True);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
      NRF52_DK.IOs.Set (27, False);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));

      NRF52_DK.IOs.Set (13, True);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
      NRF52_DK.IOs.Set (13, false);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
      
   end Crash_Stop_Forward;  
   
   procedure Crash_Stop_Backward is
   begin
      --Same thing here as with the function above, but here we run a forward loop.
      --FORWARD LOOP
      NRF52_DK.IOs.Set (13, True);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
      NRF52_DK.IOs.Set (13, false);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
      
      NRF52_DK.IOs.Set (27, True);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
      NRF52_DK.IOs.Set (27, False);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
      
      NRF52_DK.IOs.Set (21, True);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
      NRF52_DK.IOs.Set (21, False);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));

      NRF52_DK.IOs.Set (23, True);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
      NRF52_DK.IOs.Set (23, False);
      NRF52_DK.Time.Delay_Ms (UInt64 (5 / 1000));
   end Crash_Stop_Backward;
   
        
end SteeringControl;

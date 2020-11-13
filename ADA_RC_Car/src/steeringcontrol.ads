with NRF52_DK.IOs;

package SteeringControl is --Servo and Motor controls --
   
   procedure Servocontrol(ServoPin : NRF52_DK.IOs.Pin_Id; Value : NRF52_DK.IOs.Analog_Value); --- Servo--
   
   procedure Direction_Controller; --Left or right write to servo to turn car --
   
   procedure Motor_Controller; --Motor forward/backward --
   
   procedure Crash_Stop_Forward; --When triggering emergency stop --
   
   procedure Crash_Stop_Backward; --When triggering emergency stop --
   
end SteeringControl;

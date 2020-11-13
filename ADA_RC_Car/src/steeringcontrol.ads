with NRF52_DK.IOs;

package SteeringControl is
   
   procedure Servocontrol(ServoPin : NRF52_DK.IOs.Pin_Id; Value : NRF52_DK.IOs.Analog_Value);
   
   procedure Direction_Controller;
   
   procedure Motor_Controller;
   
   procedure Crash_Stop_Forward;
   
   procedure Crash_Stop_Backward;
   
end SteeringControl;

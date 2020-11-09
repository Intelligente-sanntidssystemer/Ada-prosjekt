with NRF52_DK; use NRF52_DK;
with NRF52_DK.IOs; use NRF52_DK.IOs;
package sensor is

   
   function Distance(TrigPin, EchoPin : NRF52_DK.IOs.Pin_Id) return Float;
   

end sensor;

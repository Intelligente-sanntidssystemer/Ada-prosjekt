package Motor is

   pragma Elaborate_Body;

   subtype Percentage is Integer range 0 .. 100;

   type Travel_Directions is (Forward, Backward, Neither);

   type Travel_Vector is record
      Power             : Percentage;
      Direction         : Travel_Directions;
      Emergency_Braking : Boolean := False;
   end record
   with Size => 32, Atomic;
   --  The size is bigger than absolutely necessary but we fit the components
   --  to bytes for the sake of efficiency. The main concern is that the size
   --  remain such that objects of the record type can be atomically accessed
   --  because we are just using shared variables rather than protecting them
   --  with a protected object.

   for Travel_Vector use record
      Power             at 0 range 0 .. 7;
      Direction         at 0 range 8 .. 15;
      Emergency_Braking at 0 range 16 .. 23;
   end record;

   function Requested_Vector return Travel_Vector with Inline, Volatile_Function;

   function Requested_Steering_Angle return Integer with Inline, Volatile_Function;
   --  The units are angles, positive or negative, relative to the major axis of
   --  the vehicle, which is angle zero.

private

   task Pump with
      Storage_Size => 1 * 1024,
      Priority     => System_Configuration.Remote_Priority;
end Motor;

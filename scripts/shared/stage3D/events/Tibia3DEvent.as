package shared.stage3D.events
{
   import flash.events.Event;
   
   public class Tibia3DEvent extends Event
   {
      
      public static const CONTEXT3D_CREATED:String = "context3DCreated";
       
      
      public var m_OptionalParameters:Object;
      
      public function Tibia3DEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.m_OptionalParameters = param2;
      }
      
      override public function clone() : Event
      {
         return new Tibia3DEvent(type,this.m_OptionalParameters,bubbles,cancelable);
      }
   }
}

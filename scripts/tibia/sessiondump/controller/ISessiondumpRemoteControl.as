package tibia.sessiondump.controller
{
   import tibia.sessiondump.Sessiondump;
   
   public interface ISessiondumpRemoteControl
   {
       
      
      function get yieldMessageProcessingAfterMilliseconds() : uint;
      
      function stop() : void;
      
      function setTargetTimestamp(param1:uint, param2:int = 0) : void;
      
      function get calculatedPlaySpeedFactor() : Number;
      
      function get currentSessiondumpTimestamp() : uint;
      
      function get playSpeedFactor() : Number;
      
      function get sessiondump() : Sessiondump;
      
      function set playSpeedFactor(param1:Number) : void;
      
      function get targetTimestamp() : uint;
      
      function get maxPlayspeedFactor() : uint;
      
      function gotoKeyframe(param1:uint) : void;
      
      function get currentSessiondumpEstimatedTimestamp() : uint;
      
      function play() : void;
      
      function pause() : void;
      
      function clearTargetTimestamp() : void;
      
      function set yieldMessageProcessingAfterMilliseconds(param1:uint) : void;
      
      function get stillLoading() : Boolean;
      
      function set maxPlayspeedFactor(param1:uint) : void;
      
      function get sessiondumpDuration() : uint;
      
      function get isConnected() : Boolean;
   }
}

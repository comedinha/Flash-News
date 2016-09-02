package shared.utility
{
   public interface IPerformanceCounter
   {
       
      
      function get maximum() : Number;
      
      function start() : void;
      
      function get total() : Number;
      
      function pause() : void;
      
      function get length() : uint;
      
      function stop() : void;
      
      function resume() : void;
      
      function get average() : Number;
      
      function get minimum() : Number;
      
      function reset() : void;
   }
}

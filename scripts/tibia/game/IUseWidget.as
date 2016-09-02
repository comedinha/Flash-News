package tibia.game
{
   import flash.geom.Point;
   
   public interface IUseWidget
   {
       
      
      function getUseObjectUnderPoint(param1:Point) : Object;
      
      function getMultiUseObjectUnderPoint(param1:Point) : Object;
   }
}

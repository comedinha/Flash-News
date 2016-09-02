package tibia.game
{
   import flash.geom.Point;
   
   public interface IMoveWidget extends ICoordinateWidget
   {
       
      
      function getMoveObjectUnderPoint(param1:Point) : Object;
   }
}

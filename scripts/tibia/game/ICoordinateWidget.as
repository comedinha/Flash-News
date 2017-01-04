package tibia.game
{
   import flash.geom.Point;
   import shared.utility.Vector3D;
   
   public interface ICoordinateWidget
   {
       
      
      function pointToMap(param1:Point) : Vector3D;
      
      function pointToAbsolute(param1:Point) : Vector3D;
   }
}

package tibia.game
{
   import shared.utility.Vector3D;
   import flash.geom.Point;
   
   public interface ICoordinateWidget
   {
       
      
      function pointToMap(param1:Point) : Vector3D;
      
      function pointToAbsolute(param1:Point) : Vector3D;
   }
}

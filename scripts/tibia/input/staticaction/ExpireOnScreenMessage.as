package tibia.input.staticaction
{
   import tibia.worldmap.WorldMapStorage;
   
   public class ExpireOnScreenMessage extends StaticAction
   {
       
      
      public function ExpireOnScreenMessage(param1:int, param2:String, param3:uint)
      {
         super(param1,param2,param3,false);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:WorldMapStorage = Tibia.s_GetWorldMapStorage();
         if(_loc2_ != null)
         {
            _loc2_.expireOldestMessage();
         }
      }
   }
}

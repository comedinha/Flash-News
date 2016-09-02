package tibia.sessiondump.hints
{
   import tibia.game.Asset;
   
   public class SessiondumpHintsAsset extends Asset
   {
       
      
      private var m_CachedSessiondumpHintsObject:Object = null;
      
      public function SessiondumpHintsAsset(param1:String, param2:int)
      {
         super(param1,param2);
         this.m_NoCacheEnabled = true;
      }
      
      public function get sessiondumpHintsObject() : Object
      {
         var _loc1_:String = null;
         if(this.m_CachedSessiondumpHintsObject == null && this.loaded)
         {
            _loc1_ = rawBytes.readUTFBytes(rawBytes.bytesAvailable);
            this.m_CachedSessiondumpHintsObject = JSON.parse(_loc1_);
         }
         return this.m_CachedSessiondumpHintsObject;
      }
   }
}

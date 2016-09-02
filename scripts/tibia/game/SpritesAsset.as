package tibia.game
{
   public class SpritesAsset extends Asset
   {
       
      
      private var m_LastSpriteID:uint = 0;
      
      private var m_SpriteType:uint = 0;
      
      private var m_Areas:Vector.<int> = null;
      
      private var m_FirstSpriteID:uint = 0;
      
      public function SpritesAsset(param1:String, param2:int, param3:uint, param4:uint, param5:uint, param6:Vector.<int>)
      {
         super(param1,param2);
         this.m_FirstSpriteID = param3;
         this.m_LastSpriteID = param4;
         this.m_SpriteType = param5;
         this.m_Areas = param6;
      }
      
      public function get areas() : Vector.<int>
      {
         return this.m_Areas;
      }
      
      public function get lastSpriteID() : uint
      {
         return this.m_LastSpriteID;
      }
      
      public function get firstSpriteID() : uint
      {
         return this.m_FirstSpriteID;
      }
      
      public function get spriteType() : uint
      {
         return this.m_SpriteType;
      }
   }
}

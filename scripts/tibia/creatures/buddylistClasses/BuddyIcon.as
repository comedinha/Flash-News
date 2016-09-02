package tibia.creatures.buddylistClasses
{
   public class BuddyIcon
   {
      
      public static const DEFAULT_ICON:int = 0;
      
      public static const NUM_ICONS:int = 11;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      protected var m_ID:int = 0;
      
      public function BuddyIcon(param1:int)
      {
         super();
         if(param1 < 0 || param1 >= NUM_ICONS)
         {
            throw new ArgumentError("Icon.Icon: Invalid ID " + param1 + ".");
         }
         this.m_ID = param1;
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : BuddyIcon
      {
         if(param1 == null || param1.localName() != "icon" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("BuddyIcon.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@ID) == null || _loc3_.length() != 1)
         {
            return null;
         }
         var _loc4_:int = parseInt(_loc3_[0].toString());
         if(_loc4_ < 0 || _loc4_ >= NUM_ICONS)
         {
            return null;
         }
         var _loc5_:BuddyIcon = new BuddyIcon(_loc4_);
         return _loc5_;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function marshall() : XML
      {
         return <icon ID="{this.m_ID}"/>;
      }
   }
}

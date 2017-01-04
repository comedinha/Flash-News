package tibia.ingameshop
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.EventDispatcher;
   
   public class DynamicImage extends EventDispatcher
   {
      
      public static const ICON_ERROR:BitmapData = Bitmap(new ICON_ERROR_CLASS()).bitmapData;
      
      public static const STATE_LOADING:int = 0;
      
      private static const ICON_LOADING_CLASS:Class = DynamicImage_ICON_LOADING_CLASS;
      
      public static const STATE_READY:int = 1;
      
      public static const ICON_LOADING:BitmapData = Bitmap(new ICON_LOADING_CLASS()).bitmapData;
      
      private static const ICON_ERROR_CLASS:Class = DynamicImage_ICON_ERROR_CLASS;
       
      
      private var m_BitmapData:BitmapData;
      
      private var m_FetchTime:Number = 0;
      
      private var m_State:int = 1;
      
      public function DynamicImage()
      {
         this.m_BitmapData = ICON_LOADING;
         super();
      }
      
      public function set state(param1:int) : void
      {
         var _loc2_:IngameShopEvent = null;
         if(this.m_State != param1)
         {
            this.m_State = param1;
            _loc2_ = new IngameShopEvent(IngameShopEvent.IMAGE_CHANGED);
            dispatchEvent(_loc2_);
         }
      }
      
      public function get fetchTime() : Number
      {
         return this.m_FetchTime;
      }
      
      public function set fetchTime(param1:Number) : void
      {
         this.m_FetchTime = param1;
      }
      
      public function get state() : int
      {
         return this.m_State;
      }
      
      public function set bitmapData(param1:BitmapData) : void
      {
         var _loc2_:IngameShopEvent = null;
         if(param1 != this.m_BitmapData)
         {
            this.m_BitmapData = param1;
            this.m_State = STATE_READY;
            _loc2_ = new IngameShopEvent(IngameShopEvent.IMAGE_CHANGED);
            dispatchEvent(_loc2_);
         }
      }
      
      public function get bitmapData() : BitmapData
      {
         return this.m_BitmapData;
      }
   }
}

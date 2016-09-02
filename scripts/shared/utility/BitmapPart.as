package shared.utility
{
   import flash.geom.Rectangle;
   import flash.display.BitmapData;
   
   public class BitmapPart
   {
       
      
      protected var m_BitmapData:BitmapData = null;
      
      protected var m_Rectangle:Rectangle;
      
      public function BitmapPart(param1:BitmapData = null, param2:Rectangle = null)
      {
         this.m_Rectangle = new Rectangle();
         super();
         this.setBitmapPartTo(param1,param2);
      }
      
      public function get rectangle() : Rectangle
      {
         return this.m_Rectangle;
      }
      
      public function get bitmapData() : BitmapData
      {
         return this.m_BitmapData;
      }
      
      public function copyFrom(param1:BitmapPart) : void
      {
         if(param1 != null)
         {
            this.m_BitmapData = param1.bitmapData;
            this.m_Rectangle.copyFrom(param1.rectangle);
         }
         else
         {
            this.setBitmapPartTo(null,null);
         }
      }
      
      public function setBitmapPartTo(param1:BitmapData, param2:Rectangle) : void
      {
         if(param2 == null)
         {
            this.m_Rectangle.setTo(0,0,0,0);
         }
         else
         {
            this.m_Rectangle.copyFrom(param2);
         }
         this.m_BitmapData = param1;
      }
   }
}

package shared.utility
{
   import flash.geom.Rectangle;
   
   class BitmapCacheItem extends HeapItem
   {
       
      
      public var slot:int = -1;
      
      public var key;
      
      public var rectangle:Rectangle;
      
      function BitmapCacheItem()
      {
         this.rectangle = new Rectangle(0,0,0,0);
         super();
      }
   }
}

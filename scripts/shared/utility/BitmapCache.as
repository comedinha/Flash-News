package shared.utility
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class BitmapCache extends BitmapData
   {
       
      
      private var m_SlotRows:int = 0;
      
      private var m_SlotColumns:int = 0;
      
      private var m_ItemSequenceNumber:int = -2.147483647E9;
      
      private var m_ItemQueue:Heap = null;
      
      private var m_SlotList:Vector.<int> = null;
      
      private var m_SlotWidth:Number = 0;
      
      private var m_SlotHeight:Number = 0;
      
      private var m_ItemDictionary:Dictionary = null;
      
      public function BitmapCache(param1:Number, param2:Number, param3:uint)
      {
         param3 = Math.max(1,param3);
         this.m_SlotWidth = Math.ceil(param1);
         this.m_SlotHeight = Math.ceil(param2);
         this.m_SlotColumns = Math.ceil(Math.sqrt(param3));
         this.m_SlotRows = Math.ceil(param3 / this.m_SlotColumns);
         super(this.m_SlotColumns * this.m_SlotWidth,this.m_SlotRows * this.m_SlotHeight,true,0);
         this.m_ItemDictionary = new Dictionary(true);
         this.m_ItemQueue = new Heap();
         this.m_SlotList = new Vector.<int>(this.m_SlotColumns * this.m_SlotRows);
         var _loc4_:int = 0;
         var _loc5_:int = this.m_SlotList.length;
         while(_loc4_ < _loc5_)
         {
            this.m_SlotList[_loc4_] = _loc5_ - 1 - _loc4_;
            _loc4_++;
         }
      }
      
      public function get size() : int
      {
         return this.m_SlotColumns * this.m_SlotRows;
      }
      
      public function get slotHeight() : int
      {
         return this.m_SlotHeight;
      }
      
      public function get length() : int
      {
         return this.m_SlotColumns * this.m_SlotRows - this.m_SlotList.length;
      }
      
      public function get slotWidth() : int
      {
         return this.m_SlotWidth;
      }
      
      public function getItem(param1:*, ... rest) : Rectangle
      {
         var _loc3_:BitmapCacheItem = BitmapCacheItem(this.m_ItemDictionary[param1]);
         if(_loc3_ == null)
         {
            if(this.m_SlotList.length < 1)
            {
               _loc3_ = BitmapCacheItem(this.m_ItemQueue.peekMinItem());
               delete this.m_ItemDictionary[_loc3_.key];
               _loc3_.key = param1;
               this.m_ItemDictionary[param1] = _loc3_;
               this.m_ItemQueue.updateKey(_loc3_,this.m_ItemSequenceNumber);
            }
            else
            {
               _loc3_ = new BitmapCacheItem();
               _loc3_.key = param1;
               _loc3_.slot = this.m_SlotList.pop();
               this.m_ItemDictionary[param1] = _loc3_;
               this.m_ItemQueue.addItem(_loc3_,this.m_ItemSequenceNumber);
            }
            this.m_ItemSequenceNumber++;
            _loc3_.rectangle.x = _loc3_.slot % this.m_SlotColumns * this.m_SlotWidth;
            _loc3_.rectangle.y = int(_loc3_.slot / this.m_SlotColumns) * this.m_SlotHeight;
            _loc3_.rectangle.width = this.m_SlotWidth;
            _loc3_.rectangle.height = this.m_SlotHeight;
            fillRect(_loc3_.rectangle,0);
            this.addItem(_loc3_.rectangle,rest);
         }
         return _loc3_.rectangle;
      }
      
      protected function addItem(param1:Rectangle, param2:Array) : void
      {
      }
      
      public function removeItem(param1:*) : void
      {
         var _loc2_:BitmapCacheItem = BitmapCacheItem(this.m_ItemDictionary[param1]);
         if(_loc2_ != null)
         {
            this.m_SlotList.push(_loc2_.slot);
            delete this.m_ItemDictionary[_loc2_.key];
            _loc2_.key = undefined;
            this.m_ItemQueue.updateKey(_loc2_,int.MIN_VALUE);
            this.m_ItemQueue.extractMinItem();
         }
      }
   }
}

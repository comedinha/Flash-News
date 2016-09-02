package tibia.container.containerViewWidgetClasses
{
   import mx.containers.Tile;
   import mx.core.mx_internal;
   import mx.core.EdgeMetrics;
   import mx.containers.TileDirection;
   
   public class ContainerSlotHolder extends Tile
   {
       
      
      private var m_MeasuredMaxHeight:Number = NaN;
      
      public function ContainerSlotHolder()
      {
         super();
         direction = TileDirection.HORIZONTAL;
      }
      
      override protected function measure() : void
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:ContainerSlot = null;
         mx_internal::findCellSize();
         var _loc1_:Number = getStyle("horizontalGap");
         var _loc2_:Number = getStyle("verticalGap");
         var _loc3_:EdgeMetrics = viewMetricsAndPadding;
         var _loc4_:int = numChildren;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc12_ = getChildAt(_loc6_) as ContainerSlot;
            if(_loc12_ != null && _loc12_.appearance != null)
            {
               _loc5_++;
            }
            _loc6_++;
         }
         var _loc7_:int = -1;
         var _loc8_:int = -1;
         var _loc9_:int = -1;
         if(!isNaN(explicitWidth))
         {
            _loc7_ = Math.floor((explicitWidth + _loc1_ - _loc3_.left - _loc3_.right) / (mx_internal::cellWidth + _loc1_));
         }
         if(_loc7_ < 0)
         {
            _loc7_ = Math.floor(Math.sqrt(_loc4_));
         }
         if(_loc7_ < 1)
         {
            _loc7_ = 1;
         }
         _loc8_ = Math.ceil(_loc4_ / _loc7_);
         if(_loc8_ < 1)
         {
            _loc8_ = 1;
         }
         _loc9_ = Math.ceil(_loc5_ / _loc7_);
         if(_loc9_ < 1)
         {
            _loc9_ = 1;
         }
         _loc10_ = _loc3_.left + _loc3_.right;
         _loc11_ = _loc3_.top + _loc3_.bottom;
         measuredMinWidth = _loc10_ + mx_internal::cellWidth;
         measuredWidth = _loc10_ + (_loc7_ - 1) * _loc1_ + _loc7_ * mx_internal::cellWidth;
         measuredMinHeight = _loc11_ + mx_internal::cellHeight;
         measuredHeight = _loc11_ + (_loc9_ - 1) * _loc2_ + _loc9_ * mx_internal::cellHeight;
         this.measuredMaxHeight = _loc11_ + (_loc8_ - 1) * _loc2_ + _loc8_ * mx_internal::cellHeight;
      }
      
      public function set measuredMaxHeight(param1:Number) : void
      {
         this.m_MeasuredMaxHeight = param1;
      }
      
      public function get measuredMaxHeight() : Number
      {
         return this.m_MeasuredMaxHeight;
      }
   }
}

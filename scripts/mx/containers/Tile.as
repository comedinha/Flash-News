package mx.containers
{
   import flash.events.Event;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class Tile extends Container
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _direction:String = "horizontal";
      
      mx_internal var cellWidth:Number;
      
      mx_internal var cellHeight:Number;
      
      private var _tileHeight:Number;
      
      private var _tileWidth:Number;
      
      public function Tile()
      {
         super();
      }
      
      override protected function measure() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         super.measure();
         findCellSize();
         _loc3_ = cellWidth;
         _loc4_ = cellHeight;
         var _loc5_:int = numChildren;
         var _loc6_:int = _loc5_;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            if(!IUIComponent(getChildAt(_loc7_)).includeInLayout)
            {
               _loc6_--;
            }
            _loc7_++;
         }
         _loc5_ = _loc6_;
         if(_loc5_ > 0)
         {
            _loc11_ = getStyle("horizontalGap");
            _loc12_ = getStyle("verticalGap");
            if(direction == TileDirection.HORIZONTAL)
            {
               _loc15_ = explicitWidth / Math.abs(scaleX);
               if(!isNaN(_loc15_))
               {
                  _loc13_ = Math.floor((_loc15_ + _loc11_) / (cellWidth + _loc11_));
               }
            }
            else
            {
               _loc16_ = explicitHeight / Math.abs(scaleY);
               if(!isNaN(_loc16_))
               {
                  _loc13_ = Math.floor((_loc16_ + _loc12_) / (cellHeight + _loc12_));
               }
            }
            if(isNaN(_loc13_))
            {
               _loc13_ = Math.ceil(Math.sqrt(_loc5_));
            }
            if(_loc13_ < 1)
            {
               _loc13_ = 1;
            }
            _loc14_ = Math.ceil(_loc5_ / _loc13_);
            if(direction == TileDirection.HORIZONTAL)
            {
               _loc1_ = _loc13_ * cellWidth + (_loc13_ - 1) * _loc11_;
               _loc2_ = _loc14_ * cellHeight + (_loc14_ - 1) * _loc12_;
            }
            else
            {
               _loc1_ = _loc14_ * cellWidth + (_loc14_ - 1) * _loc11_;
               _loc2_ = _loc13_ * cellHeight + (_loc13_ - 1) * _loc12_;
            }
         }
         else
         {
            _loc1_ = _loc3_;
            _loc2_ = _loc4_;
         }
         var _loc8_:EdgeMetrics = viewMetricsAndPadding;
         var _loc9_:Number = _loc8_.left + _loc8_.right;
         var _loc10_:Number = _loc8_.top + _loc8_.bottom;
         _loc3_ = _loc3_ + _loc9_;
         _loc1_ = _loc1_ + _loc9_;
         _loc4_ = _loc4_ + _loc10_;
         _loc2_ = _loc2_ + _loc10_;
         measuredMinWidth = Math.ceil(_loc3_);
         measuredMinHeight = Math.ceil(_loc4_);
         measuredWidth = Math.ceil(_loc1_);
         measuredHeight = Math.ceil(_loc2_);
      }
      
      public function set tileHeight(param1:Number) : void
      {
         _tileHeight = param1;
         invalidateSize();
      }
      
      mx_internal function calcHorizontalOffset(param1:Number, param2:String) : Number
      {
         var _loc3_:Number = NaN;
         if(param2 == "left")
         {
            _loc3_ = 0;
         }
         else if(param2 == "center")
         {
            _loc3_ = (cellWidth - param1) / 2;
         }
         else if(param2 == "right")
         {
            _loc3_ = cellWidth - param1;
         }
         return _loc3_;
      }
      
      mx_internal function calcVerticalOffset(param1:Number, param2:String) : Number
      {
         var _loc3_:Number = NaN;
         if(param2 == "top")
         {
            _loc3_ = 0;
         }
         else if(param2 == "middle")
         {
            _loc3_ = (cellHeight - param1) / 2;
         }
         else if(param2 == "bottom")
         {
            _loc3_ = cellHeight - param1;
         }
         return _loc3_;
      }
      
      public function set tileWidth(param1:Number) : void
      {
         _tileWidth = param1;
         invalidateSize();
      }
      
      [Bindable("resize")]
      public function get tileHeight() : Number
      {
         return _tileHeight;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc15_:int = 0;
         var _loc16_:IUIComponent = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         super.updateDisplayList(param1,param2);
         if(isNaN(cellWidth) || isNaN(cellHeight))
         {
            findCellSize();
         }
         var _loc3_:EdgeMetrics = viewMetricsAndPadding;
         var _loc4_:Number = getStyle("paddingLeft");
         var _loc5_:Number = getStyle("paddingTop");
         var _loc6_:Number = getStyle("horizontalGap");
         var _loc7_:Number = getStyle("verticalGap");
         var _loc8_:String = getStyle("horizontalAlign");
         var _loc9_:String = getStyle("verticalAlign");
         var _loc10_:Number = _loc4_;
         var _loc11_:Number = _loc5_;
         var _loc14_:int = numChildren;
         if(direction == TileDirection.HORIZONTAL)
         {
            _loc17_ = Math.ceil(param1) - _loc3_.right;
            _loc15_ = 0;
            while(_loc15_ < _loc14_)
            {
               _loc16_ = IUIComponent(getChildAt(_loc15_));
               if(_loc16_.includeInLayout)
               {
                  if(_loc10_ + cellWidth > _loc17_)
                  {
                     if(_loc10_ != _loc4_)
                     {
                        _loc11_ = _loc11_ + (cellHeight + _loc7_);
                        _loc10_ = _loc4_;
                     }
                  }
                  setChildSize(_loc16_);
                  _loc12_ = Math.floor(calcHorizontalOffset(_loc16_.width,_loc8_));
                  _loc13_ = Math.floor(calcVerticalOffset(_loc16_.height,_loc9_));
                  _loc16_.move(_loc10_ + _loc12_,_loc11_ + _loc13_);
                  _loc10_ = _loc10_ + (cellWidth + _loc6_);
               }
               _loc15_++;
            }
         }
         else
         {
            _loc18_ = Math.ceil(param2) - _loc3_.bottom;
            _loc15_ = 0;
            while(_loc15_ < _loc14_)
            {
               _loc16_ = IUIComponent(getChildAt(_loc15_));
               if(_loc16_.includeInLayout)
               {
                  if(_loc11_ + cellHeight > _loc18_)
                  {
                     if(_loc11_ != _loc5_)
                     {
                        _loc10_ = _loc10_ + (cellWidth + _loc6_);
                        _loc11_ = _loc5_;
                     }
                  }
                  setChildSize(_loc16_);
                  _loc12_ = Math.floor(calcHorizontalOffset(_loc16_.width,_loc8_));
                  _loc13_ = Math.floor(calcVerticalOffset(_loc16_.height,_loc9_));
                  _loc16_.move(_loc10_ + _loc12_,_loc11_ + _loc13_);
                  _loc11_ = _loc11_ + (cellHeight + _loc7_);
               }
               _loc15_++;
            }
         }
         cellWidth = NaN;
         cellHeight = NaN;
      }
      
      [Bindable("resize")]
      public function get tileWidth() : Number
      {
         return _tileWidth;
      }
      
      private function setChildSize(param1:IUIComponent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(param1.percentWidth > 0)
         {
            _loc2_ = Math.min(cellWidth,cellWidth * param1.percentWidth / 100);
         }
         else
         {
            _loc2_ = param1.getExplicitOrMeasuredWidth();
            if(_loc2_ > cellWidth)
            {
               _loc4_ = !!isNaN(param1.explicitWidth)?Number(0):Number(param1.explicitWidth);
               _loc5_ = !!isNaN(param1.explicitMinWidth)?Number(0):Number(param1.explicitMinWidth);
               _loc2_ = _loc4_ > cellWidth || _loc5_ > cellWidth?Number(Math.max(_loc5_,_loc4_)):Number(cellWidth);
            }
         }
         if(param1.percentHeight > 0)
         {
            _loc3_ = Math.min(cellHeight,cellHeight * param1.percentHeight / 100);
         }
         else
         {
            _loc3_ = param1.getExplicitOrMeasuredHeight();
            if(_loc3_ > cellHeight)
            {
               _loc4_ = !!isNaN(param1.explicitHeight)?Number(0):Number(param1.explicitHeight);
               _loc5_ = !!isNaN(param1.explicitMinHeight)?Number(0):Number(param1.explicitMinHeight);
               _loc3_ = _loc4_ > cellHeight || _loc5_ > cellHeight?Number(Math.max(_loc5_,_loc4_)):Number(cellHeight);
            }
         }
         param1.setActualSize(_loc2_,_loc3_);
      }
      
      mx_internal function findCellSize() : void
      {
         var _loc7_:IUIComponent = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc1_:* = !isNaN(tileWidth);
         var _loc2_:* = !isNaN(tileHeight);
         if(_loc1_ && _loc2_)
         {
            cellWidth = tileWidth;
            cellHeight = tileHeight;
            return;
         }
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:int = numChildren;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = IUIComponent(getChildAt(_loc6_));
            if(_loc7_.includeInLayout)
            {
               _loc8_ = _loc7_.getExplicitOrMeasuredWidth();
               if(_loc8_ > _loc3_)
               {
                  _loc3_ = _loc8_;
               }
               _loc9_ = _loc7_.getExplicitOrMeasuredHeight();
               if(_loc9_ > _loc4_)
               {
                  _loc4_ = _loc9_;
               }
            }
            _loc6_++;
         }
         cellWidth = !!_loc1_?Number(tileWidth):Number(_loc3_);
         cellHeight = !!_loc2_?Number(tileHeight):Number(_loc4_);
      }
      
      public function set direction(param1:String) : void
      {
         _direction = param1;
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("directionChanged"));
      }
      
      [Bindable("directionChanged")]
      public function get direction() : String
      {
         return _direction;
      }
   }
}

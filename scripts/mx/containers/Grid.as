package mx.containers
{
   import mx.containers.gridClasses.GridColumnInfo;
   import mx.containers.gridClasses.GridRowInfo;
   import mx.core.EdgeMetrics;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class Grid extends Box
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var columnWidths:Array;
      
      private var rowHeights:Array;
      
      private var needToRemeasure:Boolean = true;
      
      public function Grid()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc4_:int = 0;
         var _loc5_:GridRow = null;
         if(needToRemeasure)
         {
            measure();
         }
         super.updateDisplayList(param1,param2);
         var _loc3_:int = 0;
         var _loc6_:Array = [];
         var _loc7_:int = 0;
         while(_loc7_ < numChildren)
         {
            _loc5_ = GridRow(getChildAt(_loc7_));
            if(_loc5_.includeInLayout)
            {
               _loc6_.push(_loc5_);
               _loc3_++;
            }
            _loc7_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc6_[_loc4_];
            rowHeights[_loc4_].y = _loc5_.y;
            rowHeights[_loc4_].height = _loc5_.height;
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc6_[_loc4_];
            _loc5_.doRowLayout(_loc5_.width * _loc5_.scaleX,_loc5_.height * _loc5_.scaleY);
            _loc4_++;
         }
      }
      
      private function distributeItemWidth(param1:GridItem, param2:int, param3:Number, param4:Array) : void
      {
         var _loc12_:int = 0;
         var _loc13_:GridColumnInfo = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc5_:Number = param1.maxWidth;
         var _loc6_:Number = param1.getExplicitOrMeasuredWidth();
         var _loc7_:Number = param1.minWidth;
         var _loc8_:int = param1.colSpan;
         var _loc9_:Number = param1.percentWidth;
         var _loc10_:Number = 0;
         var _loc11_:Boolean = false;
         _loc12_ = param2;
         while(_loc12_ < param2 + _loc8_)
         {
            _loc13_ = param4[_loc12_];
            _loc6_ = _loc6_ - _loc13_.preferred;
            _loc7_ = _loc7_ - _loc13_.min;
            _loc10_ = _loc10_ + _loc13_.flex;
            _loc12_++;
         }
         if(_loc8_ > 1)
         {
            _loc14_ = param3 * (_loc8_ - 1);
            _loc6_ = _loc6_ - _loc14_;
            _loc7_ = _loc7_ - _loc14_;
         }
         if(_loc10_ == 0)
         {
            _loc10_ = _loc8_;
            _loc11_ = true;
         }
         _loc6_ = _loc6_ > 0?Number(Math.ceil(_loc6_ / _loc10_)):Number(0);
         _loc7_ = _loc7_ > 0?Number(Math.ceil(_loc7_ / _loc10_)):Number(0);
         _loc12_ = param2;
         while(_loc12_ < param2 + _loc8_)
         {
            _loc13_ = param4[_loc12_];
            _loc15_ = !!_loc11_?Number(1):Number(_loc13_.flex);
            _loc13_.preferred = _loc13_.preferred + _loc6_ * _loc15_;
            _loc13_.min = _loc13_.min + _loc7_ * _loc15_;
            if(_loc9_)
            {
               _loc13_.percent = Math.max(_loc13_.percent,_loc9_ / _loc8_);
            }
            _loc12_++;
         }
         if(_loc8_ == 1 && _loc5_ < _loc13_.max)
         {
            _loc13_.max = _loc5_;
         }
      }
      
      private function distributeItemHeight(param1:GridItem, param2:Number, param3:Number, param4:Array) : void
      {
         var _loc11_:int = 0;
         var _loc12_:GridRowInfo = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc5_:Number = param1.maxHeight;
         var _loc6_:Number = param1.getExplicitOrMeasuredHeight();
         var _loc7_:Number = param1.minHeight;
         var _loc8_:int = param1.rowSpan;
         var _loc9_:Number = 0;
         var _loc10_:Boolean = false;
         _loc11_ = param2;
         while(_loc11_ < param2 + _loc8_)
         {
            _loc12_ = param4[_loc11_];
            _loc6_ = _loc6_ - _loc12_.preferred;
            _loc7_ = _loc7_ - _loc12_.min;
            _loc9_ = _loc9_ + _loc12_.flex;
            _loc11_++;
         }
         if(_loc8_ > 1)
         {
            _loc13_ = param3 * (_loc8_ - 1);
            _loc6_ = _loc6_ - _loc13_;
            _loc7_ = _loc7_ - _loc13_;
         }
         if(_loc9_ == 0)
         {
            _loc9_ = _loc8_;
            _loc10_ = true;
         }
         _loc6_ = _loc6_ > 0?Number(Math.ceil(_loc6_ / _loc9_)):Number(0);
         _loc7_ = _loc7_ > 0?Number(Math.ceil(_loc7_ / _loc9_)):Number(0);
         _loc11_ = param2;
         while(_loc11_ < param2 + _loc8_)
         {
            _loc12_ = param4[_loc11_];
            _loc14_ = !!_loc10_?Number(1):Number(_loc12_.flex);
            _loc12_.preferred = _loc12_.preferred + _loc6_ * _loc14_;
            _loc12_.min = _loc12_.min + _loc7_ * _loc14_;
            _loc11_++;
         }
         if(_loc8_ == 1 && _loc5_ < _loc12_.max)
         {
            _loc12_.max = _loc5_;
         }
      }
      
      override public function invalidateSize() : void
      {
         if(!isNaN(explicitWidth) && !isNaN(explicitHeight))
         {
            needToRemeasure = true;
         }
         super.invalidateSize();
      }
      
      override protected function measure() : void
      {
         var _loc4_:GridRow = null;
         var _loc5_:GridItem = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc12_:int = 0;
         var _loc19_:Number = NaN;
         var _loc22_:GridRow = null;
         var _loc23_:EdgeMetrics = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:* = undefined;
         var _loc29_:* = undefined;
         var _loc30_:GridRowInfo = null;
         var _loc31_:GridColumnInfo = null;
         var _loc32_:Number = NaN;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         var _loc9_:Array = [];
         var _loc10_:int = 0;
         while(_loc10_ < numChildren)
         {
            _loc4_ = GridRow(getChildAt(_loc10_));
            if(_loc4_.includeInLayout)
            {
               _loc9_.push(_loc4_);
               _loc1_++;
            }
            _loc10_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc1_)
         {
            _loc8_ = 0;
            _loc4_ = _loc9_[_loc6_];
            _loc4_.numGridItems = _loc4_.numChildren;
            _loc4_.rowIndex = _loc6_;
            _loc7_ = 0;
            while(_loc7_ < _loc4_.numGridItems)
            {
               if(_loc6_ > 0)
               {
                  _loc25_ = _loc3_[_loc8_];
                  while(!isNaN(_loc25_) && _loc25_ >= _loc6_)
                  {
                     _loc8_++;
                     _loc25_ = _loc3_[_loc8_];
                  }
               }
               _loc5_ = GridItem(_loc4_.getChildAt(_loc7_));
               _loc5_.colIndex = _loc8_;
               if(_loc5_.rowSpan > 1)
               {
                  _loc26_ = _loc6_ + _loc5_.rowSpan - 1;
                  _loc27_ = 0;
                  while(_loc27_ < _loc5_.colSpan)
                  {
                     _loc3_[_loc8_ + _loc27_] = _loc26_;
                     _loc27_++;
                  }
               }
               _loc8_ = _loc8_ + _loc5_.colSpan;
               _loc7_++;
            }
            if(_loc8_ > _loc2_)
            {
               _loc2_ = _loc8_;
            }
            _loc6_++;
         }
         rowHeights = new Array(_loc1_);
         columnWidths = new Array(_loc2_);
         _loc6_ = 0;
         while(_loc6_ < _loc1_)
         {
            rowHeights[_loc6_] = new GridRowInfo();
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc2_)
         {
            columnWidths[_loc6_] = new GridColumnInfo();
            _loc6_++;
         }
         var _loc11_:int = int.MAX_VALUE;
         var _loc13_:int = 1;
         var _loc14_:Number = getStyle("horizontalGap");
         var _loc15_:Number = getStyle("verticalGap");
         do
         {
            _loc12_ = _loc13_;
            _loc13_ = _loc11_;
            _loc6_ = 0;
            while(_loc6_ < _loc1_)
            {
               _loc4_ = _loc9_[_loc6_];
               _loc4_.columnWidths = columnWidths;
               _loc4_.rowHeights = rowHeights;
               _loc7_ = 0;
               while(_loc7_ < _loc4_.numGridItems)
               {
                  _loc5_ = GridItem(_loc4_.getChildAt(_loc7_));
                  _loc28_ = _loc5_.rowSpan;
                  _loc29_ = _loc5_.colSpan;
                  if(_loc28_ == _loc12_)
                  {
                     distributeItemHeight(_loc5_,_loc6_,_loc15_,rowHeights);
                  }
                  else if(_loc28_ > _loc12_ && _loc28_ < _loc13_)
                  {
                     _loc13_ = _loc28_;
                  }
                  if(_loc29_ == _loc12_)
                  {
                     distributeItemWidth(_loc5_,_loc5_.colIndex,_loc14_,columnWidths);
                  }
                  else if(_loc29_ > _loc12_ && _loc29_ < _loc13_)
                  {
                     _loc13_ = _loc29_;
                  }
                  _loc7_++;
               }
               _loc6_++;
            }
         }
         while(_loc13_ < _loc11_);
         
         var _loc16_:Number = 0;
         var _loc17_:Number = 0;
         var _loc18_:Number = 0;
         _loc19_ = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc1_)
         {
            _loc30_ = rowHeights[_loc6_];
            if(_loc30_.min > _loc30_.preferred)
            {
               _loc30_.min = _loc30_.preferred;
            }
            if(_loc30_.max < _loc30_.preferred)
            {
               _loc30_.max = _loc30_.preferred;
            }
            _loc17_ = _loc17_ + _loc30_.min;
            _loc19_ = _loc19_ + _loc30_.preferred;
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc2_)
         {
            _loc31_ = columnWidths[_loc6_];
            if(_loc31_.min > _loc31_.preferred)
            {
               _loc31_.min = _loc31_.preferred;
            }
            if(_loc31_.max < _loc31_.preferred)
            {
               _loc31_.max = _loc31_.preferred;
            }
            _loc16_ = _loc16_ + _loc31_.min;
            _loc18_ = _loc18_ + _loc31_.preferred;
            _loc6_++;
         }
         var _loc20_:EdgeMetrics = viewMetricsAndPadding;
         var _loc21_:Number = _loc20_.left + _loc20_.right;
         var _loc24_:Number = 0;
         if(_loc2_ > 1)
         {
            _loc21_ = _loc21_ + getStyle("horizontalGap") * (_loc2_ - 1);
         }
         _loc6_ = 0;
         while(_loc6_ < _loc1_)
         {
            _loc22_ = _loc9_[_loc6_];
            _loc23_ = _loc22_.viewMetricsAndPadding;
            _loc32_ = _loc23_.left + _loc23_.right;
            if(_loc32_ > _loc24_)
            {
               _loc24_ = _loc32_;
            }
            _loc6_++;
         }
         _loc21_ = _loc21_ + _loc24_;
         _loc16_ = _loc16_ + _loc21_;
         _loc18_ = _loc18_ + _loc21_;
         _loc21_ = _loc20_.top + _loc20_.bottom;
         if(_loc1_ > 1)
         {
            _loc21_ = _loc21_ + getStyle("verticalGap") * (_loc1_ - 1);
         }
         _loc6_ = 0;
         while(_loc6_ < _loc1_)
         {
            _loc22_ = _loc9_[_loc6_];
            _loc23_ = _loc22_.viewMetricsAndPadding;
            _loc21_ = _loc21_ + (_loc23_.top + _loc23_.bottom);
            _loc6_++;
         }
         _loc17_ = _loc17_ + _loc21_;
         _loc19_ = _loc19_ + _loc21_;
         _loc6_ = 0;
         while(_loc6_ < _loc1_)
         {
            _loc22_ = _loc9_[_loc6_];
            _loc22_.updateRowMeasurements();
            _loc6_++;
         }
         super.measure();
         measuredMinWidth = Math.max(measuredMinWidth,_loc16_);
         measuredMinHeight = Math.max(measuredMinHeight,_loc17_);
         measuredWidth = Math.max(measuredWidth,_loc18_);
         measuredHeight = Math.max(measuredHeight,_loc19_);
         needToRemeasure = false;
      }
   }
}

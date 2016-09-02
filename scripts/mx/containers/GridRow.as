package mx.containers
{
   import mx.core.mx_internal;
   import mx.containers.gridClasses.GridColumnInfo;
   import mx.containers.gridClasses.GridRowInfo;
   import mx.core.EdgeMetrics;
   import mx.containers.utilityClasses.Flex;
   import mx.core.ScrollPolicy;
   import flash.display.DisplayObject;
   
   use namespace mx_internal;
   
   public class GridRow extends HBox
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      var rowIndex:int = 0;
      
      var columnWidths:Array;
      
      var rowHeights:Array;
      
      var numGridItems:int;
      
      public function GridRow()
      {
         super();
         super.clipContent = false;
      }
      
      override public function getStyle(param1:String) : *
      {
         return param1 == "horizontalGap" && parent?Grid(parent).getStyle("horizontalGap"):super.getStyle(param1);
      }
      
      override public function invalidateDisplayList() : void
      {
         super.invalidateDisplayList();
         if(parent)
         {
            Grid(parent).invalidateDisplayList();
         }
      }
      
      override public function get clipContent() : Boolean
      {
         return false;
      }
      
      override public function set horizontalScrollPolicy(param1:String) : void
      {
      }
      
      override public function set clipContent(param1:Boolean) : void
      {
      }
      
      function doRowLayout(param1:Number, param2:Number) : void
      {
         var _loc8_:GridItem = null;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:GridColumnInfo = null;
         var _loc15_:Number = NaN;
         var _loc16_:int = 0;
         var _loc17_:GridRowInfo = null;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         layoutChrome(param1,param2);
         var _loc3_:Number = numChildren;
         if(_loc3_ == 0)
         {
            return;
         }
         var _loc4_:Boolean = invalidateSizeFlag;
         var _loc5_:Boolean = invalidateDisplayListFlag;
         invalidateSizeFlag = true;
         invalidateDisplayListFlag = true;
         if(parent.getChildIndex(this) == 0 || isNaN(columnWidths[0].x) || columnWidths.minWidth != minWidth || columnWidths.maxWidth != maxWidth || columnWidths.preferredWidth != getExplicitOrMeasuredWidth() || columnWidths.percentWidth != percentWidth || columnWidths.width != param1 || columnWidths.paddingLeft != getStyle("paddingLeft") || columnWidths.paddingRight != getStyle("paddingRight") || columnWidths.horizontalAlign != getStyle("horizontalAlign") || columnWidths.borderStyle != getStyle("borderStyle"))
         {
            calculateColumnWidths();
            columnWidths.minWidth = minWidth;
            columnWidths.maxWidth = maxWidth;
            columnWidths.preferredWidth = getExplicitOrMeasuredWidth();
            columnWidths.percentWidth = percentWidth;
            columnWidths.width = param1;
            columnWidths.paddingLeft = getStyle("paddingLeft");
            columnWidths.paddingRight = getStyle("paddingRight");
            columnWidths.horizontalAlign = getStyle("horizontalAlign");
            columnWidths.borderStyle = getStyle("borderStyle");
         }
         var _loc6_:EdgeMetrics = viewMetricsAndPadding;
         var _loc7_:int = 0;
         while(_loc7_ < _loc3_)
         {
            _loc8_ = GridItem(getChildAt(_loc7_));
            _loc9_ = _loc8_.colIndex;
            _loc10_ = columnWidths[_loc9_].x;
            _loc11_ = _loc6_.top;
            _loc12_ = _loc8_.percentHeight;
            _loc13_ = Math.min(_loc9_ + _loc8_.colSpan,columnWidths.length);
            _loc14_ = columnWidths[_loc13_ - 1];
            _loc15_ = _loc14_.x + _loc14_.width - _loc10_;
            _loc16_ = Math.min(rowIndex + _loc8_.rowSpan,rowHeights.length);
            _loc17_ = rowHeights[_loc16_ - 1];
            _loc18_ = _loc17_.y + _loc17_.height - rowHeights[rowIndex].y - _loc6_.top - _loc6_.bottom;
            _loc19_ = _loc15_ - _loc8_.maxWidth;
            if(_loc19_ > 0)
            {
               _loc10_ = _loc10_ + _loc19_ * layoutObject.getHorizontalAlignValue();
               _loc15_ = _loc15_ - _loc19_;
            }
            _loc19_ = _loc18_ - _loc8_.maxHeight;
            if(_loc12_ && _loc12_ < 100)
            {
               _loc19_ = Math.max(_loc19_,_loc18_ * (100 - _loc12_));
            }
            if(_loc19_ > 0)
            {
               _loc11_ = _loc19_ * layoutObject.getVerticalAlignValue();
               _loc18_ = _loc18_ - _loc19_;
            }
            _loc15_ = Math.ceil(_loc15_);
            _loc18_ = Math.ceil(_loc18_);
            _loc8_.move(_loc10_,_loc11_);
            _loc8_.setActualSize(_loc15_,_loc18_);
            _loc7_++;
         }
         invalidateSizeFlag = _loc4_;
         invalidateDisplayListFlag = _loc5_;
      }
      
      private function calculateColumnWidths() : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:GridColumnInfo = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc1_:EdgeMetrics = viewMetricsAndPadding;
         var _loc2_:Number = getStyle("horizontalGap");
         var _loc3_:int = columnWidths.length;
         var _loc4_:Number = unscaledWidth - _loc1_.left - _loc1_.right - (_loc3_ - 1) * _loc2_;
         var _loc9_:Number = 0;
         var _loc10_:Array = [];
         _loc5_ = _loc4_;
         _loc8_ = 0;
         while(_loc8_ < _loc3_)
         {
            _loc6_ = columnWidths[_loc8_];
            _loc11_ = _loc6_.percent;
            if(_loc11_)
            {
               _loc9_ = _loc9_ + _loc11_;
               _loc10_.push(_loc6_);
            }
            else
            {
               _loc12_ = _loc6_.width = _loc6_.preferred;
               _loc5_ = _loc5_ - _loc12_;
            }
            _loc8_++;
         }
         if(_loc9_)
         {
            _loc5_ = Flex.flexChildrenProportionally(_loc4_,_loc5_,_loc9_,_loc10_);
            _loc13_ = _loc10_.length;
            _loc8_ = 0;
            while(_loc8_ < _loc13_)
            {
               _loc6_ = _loc10_[_loc8_];
               _loc6_.width = _loc6_.size;
               _loc8_++;
            }
         }
         _loc7_ = _loc1_.left + _loc5_ * layoutObject.getHorizontalAlignValue();
         _loc8_ = 0;
         while(_loc8_ < _loc3_)
         {
            _loc6_ = columnWidths[_loc8_];
            _loc6_.x = _loc7_;
            _loc7_ = _loc7_ + (_loc6_.width + _loc2_);
            _loc8_++;
         }
      }
      
      override public function get horizontalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      override public function invalidateSize() : void
      {
         super.invalidateSize();
         if(parent)
         {
            Grid(parent).invalidateSize();
         }
      }
      
      function updateRowMeasurements() : void
      {
         var _loc6_:Number = NaN;
         var _loc8_:GridColumnInfo = null;
         var _loc1_:Number = columnWidths.length;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc8_ = columnWidths[_loc4_];
            _loc2_ = _loc2_ + _loc8_.min;
            _loc3_ = _loc3_ + _loc8_.preferred;
            _loc4_++;
         }
         var _loc5_:Number = layoutObject.widthPadding(_loc1_);
         _loc6_ = layoutObject.heightPadding(0);
         var _loc7_:GridRowInfo = rowHeights[rowIndex];
         measuredMinWidth = _loc2_ + _loc5_;
         measuredMinHeight = _loc7_.min + _loc6_;
         measuredWidth = _loc3_ + _loc5_;
         measuredHeight = _loc7_.preferred + _loc6_;
      }
      
      override public function set verticalScrollPolicy(param1:String) : void
      {
      }
      
      override public function get verticalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
      }
      
      override public function setChildIndex(param1:DisplayObject, param2:int) : void
      {
         super.setChildIndex(param1,param2);
         Grid(parent).invalidateSize();
         Grid(parent).invalidateDisplayList();
      }
   }
}

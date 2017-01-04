package shared.controls
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import mx.controls.TileList;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.styles.StyleManager;
   
   public class CustomTileList extends TileList
   {
       
      
      public function CustomTileList()
      {
         super();
      }
      
      override protected function drawCaretIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         this.drawIndicator(param1,param7.x,param7.y,param4,param5,getStyle("backgroundAlpha"),param6,param7,false);
      }
      
      override protected function drawTileBackgrounds() : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Shape = null;
         var _loc11_:uint = 0;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Graphics = null;
         var _loc1_:Sprite = Sprite(listContent.getChildByName("tileBGs"));
         if(_loc1_ == null)
         {
            _loc1_ = new FlexSprite();
            _loc1_.mouseChildren = false;
            _loc1_.mouseEnabled = false;
            _loc1_.name = "tileBGs";
            listContent.addChildAt(_loc1_,0);
         }
         var _loc2_:int = _loc1_.numChildren;
         var _loc3_:int = 0;
         var _loc4_:Array = getStyle("alternatingItemColors");
         var _loc5_:Array = getStyle("alternatingItemAlphas");
         if(_loc4_ == null || _loc4_.length == 0 || _loc5_ == null || _loc5_.length != _loc4_.length)
         {
            while(_loc2_ > 0)
            {
               _loc1_.removeChildAt(--_loc2_);
            }
            return;
         }
         StyleManager.getColorNames(_loc4_);
         var _loc6_:int = 0;
         while(_loc6_ < rowCount)
         {
            _loc7_ = 0;
            while(_loc7_ < columnCount)
            {
               _loc8_ = _loc6_ * columnCount + _loc7_;
               _loc9_ = (verticalScrollPosition + _loc6_) * columnCount + (horizontalScrollPosition + _loc7_);
               _loc10_ = null;
               if(_loc8_ < _loc1_.numChildren)
               {
                  _loc10_ = Shape(_loc1_.getChildAt(_loc8_));
               }
               else
               {
                  _loc10_ = new FlexShape();
                  _loc10_.name = "tileBackground";
                  _loc1_.addChild(_loc10_);
               }
               _loc11_ = _loc4_[_loc9_ % _loc4_.length];
               _loc12_ = _loc5_[_loc9_ % _loc5_.length];
               _loc13_ = Math.min(rowHeight,listContent.height - (rowCount - 1) * rowHeight);
               _loc14_ = Math.min(columnWidth,listContent.width - (columnCount - 1) * columnWidth);
               _loc15_ = _loc10_.graphics;
               _loc15_.clear();
               _loc15_.beginFill(_loc11_,_loc12_);
               _loc15_.drawRect(0,0,_loc14_,_loc13_);
               _loc15_.endFill();
               _loc10_.x = _loc7_ * columnWidth;
               _loc10_.y = _loc6_ * rowHeight;
               _loc7_++;
            }
            _loc6_++;
         }
         _loc2_ = _loc1_.numChildren;
         _loc3_ = rowCount * columnCount;
         while(_loc2_ > _loc3_)
         {
            _loc1_.removeChildAt(--_loc2_);
         }
      }
      
      override protected function drawSelectionIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         this.drawIndicator(param1,param7.x,param7.y,param4,param5,getStyle("backgroundAlpha"),param6,param7,true);
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:IListItemRenderer = null;
         if(param1.keyCode == Keyboard.SPACE)
         {
            _loc2_ = indexToRow(caretIndex);
            _loc3_ = indexToColumn(caretIndex);
            _loc4_ = _loc2_ - verticalScrollPosition >= 0 && _loc2_ - verticalScrollPosition < listItems.length;
            _loc5_ = _loc4_ && _loc3_ - horizontalScrollPosition >= 0 && _loc3_ - horizontalScrollPosition < listItems[_loc2_ - verticalScrollPosition].length;
            if(_loc4_ && _loc5_)
            {
               _loc6_ = listItems[_loc2_ - verticalScrollPosition][_loc3_ - horizontalScrollPosition];
               selectItem(_loc6_,param1.shiftKey,param1.ctrlKey);
            }
         }
         else
         {
            super.keyDownHandler(param1);
         }
      }
      
      private function drawIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:uint, param8:IListItemRenderer, param9:Boolean) : void
      {
         var _loc10_:Graphics = param1.graphics;
         _loc10_.clear();
         if(param9)
         {
            _loc10_.beginFill(param7,param6);
            _loc10_.drawRect(0,0,param4,param5);
            _loc10_.endFill();
         }
         else
         {
            _loc10_.lineStyle(1,param7,param6);
            _loc10_.drawRect(0,0,param4 - 1,param5 - 1);
         }
         param1.x = param2;
         param1.y = param3;
      }
      
      override protected function drawHighlightIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         this.drawIndicator(param1,param7.x,param7.y,param4,param5,getStyle("backgroundAlpha"),param6,param7,true);
      }
   }
}

package shared.controls
{
   import mx.controls.DataGrid;
   import flash.display.Sprite;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBaseContentHolder;
   import flash.display.Shape;
   import flash.display.Graphics;
   import mx.core.FlexSprite;
   import mx.styles.StyleManager;
   import mx.core.FlexShape;
   
   public class CustomDataGrid extends DataGrid
   {
       
      
      public function CustomDataGrid()
      {
         super();
      }
      
      override protected function drawCaretIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         this.drawIndicator(param1,param2,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,getStyle("backgroundAlpha"),param6,param7,false);
      }
      
      override protected function drawRowGraphics(param1:ListBaseContentHolder) : void
      {
         var _loc9_:Shape = null;
         var _loc10_:uint = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Graphics = null;
         var _loc2_:Sprite = Sprite(param1.getChildByName("rowBGs"));
         if(_loc2_ == null)
         {
            _loc2_ = new FlexSprite();
            _loc2_.mouseChildren = false;
            _loc2_.mouseEnabled = false;
            _loc2_.name = "rowBGs";
            param1.addChildAt(_loc2_,0);
         }
         var _loc3_:int = _loc2_.numChildren;
         var _loc4_:Array = getStyle("alternatingItemColors");
         var _loc5_:Array = getStyle("alternatingItemAlphas");
         if(_loc4_ == null || _loc4_.length == 0 || _loc5_ == null || _loc5_.length != _loc4_.length)
         {
            while(_loc3_ > 0)
            {
               _loc2_.removeChildAt(--_loc3_);
            }
            return;
         }
         StyleManager.getColorNames(_loc4_);
         var _loc6_:int = 0;
         var _loc7_:int = verticalScrollPosition;
         var _loc8_:int = param1.listItems.length;
         while(_loc6_ < _loc8_)
         {
            _loc9_ = null;
            if(_loc6_ < _loc2_.numChildren)
            {
               _loc9_ = Shape(_loc2_.getChildAt(_loc6_));
            }
            else
            {
               _loc9_ = new FlexShape();
               _loc9_.name = "rowBackground";
               _loc2_.addChild(_loc9_);
            }
            _loc10_ = _loc4_[_loc7_ % _loc4_.length];
            _loc11_ = _loc5_[_loc7_ % _loc5_.length];
            _loc12_ = 0;
            _loc13_ = param1.rowInfo[_loc6_].y;
            _loc14_ = Math.min(param1.rowInfo[_loc6_].height,param1.height - param1.rowInfo[_loc6_].y);
            _loc15_ = param1.width;
            _loc16_ = _loc9_.graphics;
            _loc16_.clear();
            _loc16_.beginFill(_loc10_,_loc11_);
            _loc16_.drawRect(0,0,_loc15_,_loc14_);
            _loc16_.endFill();
            _loc9_.x = _loc12_;
            _loc9_.y = _loc13_;
            _loc6_++;
            _loc7_++;
         }
         while((_loc3_ = _loc2_.numChildren) > _loc8_)
         {
            _loc2_.removeChildAt(_loc3_ - 1);
         }
      }
      
      override protected function drawSelectionIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         this.drawIndicator(param1,param2,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,getStyle("backgroundAlpha"),param6,param7,true);
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
         this.drawIndicator(param1,param2,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,getStyle("backgroundAlpha"),param6,param7,true);
      }
   }
}

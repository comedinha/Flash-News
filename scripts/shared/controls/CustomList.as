package shared.controls
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import mx.controls.List;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.styles.StyleManager;
   
   public class CustomList extends List
   {
       
      
      public function CustomList()
      {
         super();
      }
      
      override protected function drawCaretIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         this.drawIndicator(param1,viewMetrics.left,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,getStyle("backgroundAlpha"),param6,param7,false);
      }
      
      override protected function drawHighlightIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         this.drawIndicator(param1,viewMetrics.left,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,getStyle("backgroundAlpha"),param6,param7,true);
      }
      
      override protected function drawSelectionIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         this.drawIndicator(param1,viewMetrics.left,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,getStyle("backgroundAlpha"),param6,param7,true);
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
      
      override protected function drawRowBackgrounds() : void
      {
         var _loc8_:Shape = null;
         var _loc9_:uint = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Graphics = null;
         var _loc1_:Sprite = Sprite(listContent.getChildByName("rowBGs"));
         if(_loc1_ == null)
         {
            _loc1_ = new FlexSprite();
            _loc1_.mouseChildren = false;
            _loc1_.mouseEnabled = false;
            _loc1_.name = "rowBGs";
            listContent.addChildAt(_loc1_,0);
         }
         var _loc2_:int = _loc1_.numChildren;
         var _loc3_:Array = getStyle("alternatingItemColors");
         var _loc4_:Array = getStyle("alternatingItemAlphas");
         if(_loc3_ == null || _loc3_.length == 0 || _loc4_ == null || _loc4_.length != _loc3_.length)
         {
            while(_loc2_ > 0)
            {
               _loc1_.removeChildAt(--_loc2_);
            }
            return;
         }
         StyleManager.getColorNames(_loc3_);
         var _loc5_:int = 0;
         var _loc6_:int = verticalScrollPosition;
         var _loc7_:int = listItems.length;
         while(_loc5_ < _loc7_)
         {
            _loc8_ = null;
            if(_loc5_ < _loc1_.numChildren)
            {
               _loc8_ = Shape(_loc1_.getChildAt(_loc5_));
            }
            else
            {
               _loc8_ = new FlexShape();
               _loc8_.name = "rowBackground";
               _loc1_.addChild(_loc8_);
            }
            _loc9_ = _loc3_[_loc6_ % _loc3_.length];
            _loc10_ = _loc4_[_loc6_ % _loc4_.length];
            _loc11_ = 0;
            _loc12_ = rowInfo[_loc5_].y;
            _loc13_ = Math.min(rowInfo[_loc5_].height,listContent.height - rowInfo[_loc5_].y);
            _loc14_ = listContent.width;
            _loc15_ = _loc8_.graphics;
            _loc15_.clear();
            _loc15_.beginFill(_loc9_,_loc10_);
            _loc15_.drawRect(0,0,_loc14_,_loc13_);
            _loc15_.endFill();
            _loc8_.x = _loc11_;
            _loc8_.y = _loc12_;
            _loc5_++;
            _loc6_++;
         }
         while((_loc2_ = _loc1_.numChildren) > _loc7_)
         {
            _loc1_.removeChildAt(_loc2_ - 1);
         }
      }
   }
}

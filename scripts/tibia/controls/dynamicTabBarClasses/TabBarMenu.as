package tibia.controls.dynamicTabBarClasses
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import mx.controls.Menu;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.menuClasses.IMenuItemRenderer;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.Application;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.mx_internal;
   import mx.managers.PopUpManager;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class TabBarMenu extends Menu
   {
       
      
      public function TabBarMenu()
      {
         super();
         setStyle("openDuration",0);
      }
      
      public static function s_CreateMenu(param1:DisplayObjectContainer, param2:Object, param3:Boolean = true) : TabBarMenu
      {
         var _loc4_:TabBarMenu = new TabBarMenu();
         _loc4_.tabEnabled = false;
         _loc4_.owner = DisplayObjectContainer(Application.application);
         _loc4_.showRoot = param3;
         Menu.popUpMenu(_loc4_,param1,param2);
         return _loc4_;
      }
      
      override protected function drawCaretIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         this.drawIndicator(param1,viewMetrics.left,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,getStyle("backgroundAlpha"),param6,param7,false);
      }
      
      override protected function configureScrollBars() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc1_:int = listItems.length;
         if(_loc1_ == 0)
         {
            return;
         }
         var _loc4_:int = listItems.length;
         while(_loc1_ > 1 && rowInfo[_loc4_ - 1].y + rowInfo[_loc4_ - 1].height > listContent.height - listContent.bottomOffset)
         {
            _loc1_--;
            _loc4_--;
         }
         var _loc5_:int = verticalScrollPosition - lockedRowCount - 1;
         var _loc6_:int = 0;
         while(_loc1_ && listItems[_loc1_ - 1].length == 0)
         {
            if(collection && _loc1_ + _loc5_ >= collection.length)
            {
               _loc1_--;
               _loc6_++;
               continue;
            }
            break;
         }
         if(listContent.topOffset)
         {
            _loc2_ = Math.abs(listContent.topOffset);
            _loc3_ = 0;
            while(rowInfo[_loc3_].y + rowInfo[_loc3_].height <= _loc2_)
            {
               _loc1_--;
               _loc3_++;
               if(_loc3_ == _loc1_)
               {
                  break;
               }
            }
         }
         var _loc7_:int = listItems[0].length;
         var _loc8_:Object = horizontalScrollBar;
         var _loc9_:Object = verticalScrollBar;
         var _loc10_:int = Math.round(unscaledWidth);
         var _loc11_:int = !!collection?int(collection.length - lockedRowCount):0;
         var _loc12_:int = _loc1_ - lockedRowCount;
         setScrollBarProperties(!!isNaN(_maxHorizontalScrollPosition)?int(Math.round(listContent.width)):int(Math.round(_maxHorizontalScrollPosition + _loc10_)),_loc10_,_loc11_,_loc12_);
         maxVerticalScrollPosition = Math.max(_loc11_ - _loc12_,0);
      }
      
      override public function get verticalScrollPolicy() : String
      {
         return _verticalScrollPolicy;
      }
      
      override protected function drawRowBackgrounds() : void
      {
         var _loc1_:Sprite = null;
         var _loc8_:Shape = null;
         var _loc9_:uint = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Graphics = null;
         _loc1_ = Sprite(listContent.getChildByName("rowBGs"));
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
      
      override protected function drawSelectionIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         this.drawIndicator(param1,viewMetrics.left,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,getStyle("backgroundAlpha"),param6,param7,true);
      }
      
      override public function set verticalScrollPolicy(param1:String) : void
      {
         var _loc2_:Event = null;
         if(_verticalScrollPolicy != param1)
         {
            _verticalScrollPolicy = param1;
            _loc2_ = new Event("verticalScrollPolicyChanged");
            dispatchEvent(_loc2_);
            invalidateDisplayList();
            invalidateSize();
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
      
      override mx_internal function openSubMenu(param1:IListItemRenderer) : void
      {
         var _loc3_:Menu = null;
         var _loc2_:Menu = getRootMenu();
         if(IMenuItemRenderer(param1).menu == null)
         {
            _loc3_ = new TabBarMenu();
            _loc3_.maxHeight = maxHeight;
            _loc3_.verticalScrollPolicy = this.verticalScrollPolicy;
            _loc3_.parentMenu = this;
            _loc3_.owner = this;
            _loc3_.showRoot = showRoot;
            _loc3_.dataDescriptor = _loc2_.dataDescriptor;
            _loc3_.styleName = _loc2_;
            _loc3_.labelField = _loc2_.labelField;
            _loc3_.labelFunction = _loc2_.labelFunction;
            _loc3_.iconField = _loc2_.iconField;
            _loc3_.iconFunction = _loc2_.iconFunction;
            _loc3_.itemRenderer = _loc2_.itemRenderer;
            _loc3_.rowHeight = _loc2_.rowHeight;
            _loc3_.scaleY = _loc2_.scaleY;
            _loc3_.scaleX = _loc2_.scaleX;
            if(param1.data && _dataDescriptor.isBranch(param1.data) && _dataDescriptor.hasChildren(param1.data))
            {
               _loc3_.dataProvider = _dataDescriptor.getChildren(param1.data);
            }
            _loc3_.sourceMenuBar = sourceMenuBar;
            _loc3_.sourceMenuBarItem = sourceMenuBarItem;
            IMenuItemRenderer(param1).menu = _loc3_;
            PopUpManager.addPopUp(_loc3_,_loc2_,false);
         }
         super.openSubMenu(param1);
      }
      
      override public function show(param1:Object = null, param2:Object = null) : void
      {
         super.show(param1,param2);
         if(stage != null && !isNaN(Number(param2)))
         {
            maxHeight = stage.stageHeight - Number(param2);
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(!isNaN(maxHeight) && measuredHeight > maxHeight)
         {
            measuredHeight = maxHeight;
            measuredMinHeight = Math.min(measuredMinHeight,maxHeight);
            measuredWidth = measuredWidth + ScrollBar.THICKNESS;
            measuredMinWidth = measuredMinWidth + ScrollBar.THICKNESS;
         }
      }
      
      override protected function drawHighlightIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         this.drawIndicator(param1,viewMetrics.left,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,getStyle("backgroundAlpha"),param6,param7,true);
      }
   }
}

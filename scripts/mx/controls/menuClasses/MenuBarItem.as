package mx.controls.menuClasses
{
   import flash.display.DisplayObject;
   import mx.controls.MenuBar;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IProgrammaticSkin;
   import mx.core.IStateClient;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   
   use namespace mx_internal;
   
   public class MenuBarItem extends UIComponent implements IMenuBarItemRenderer, IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _data:Object;
      
      private var _menuBarItemIndex:int = -1;
      
      private var leftMargin:int = 20;
      
      mx_internal var currentSkin:IFlexDisplayObject;
      
      private var _dataProvider:Object;
      
      mx_internal var skinName:String = "itemSkin";
      
      private var checkedDefaultSkin:Boolean = false;
      
      private var enabledChanged:Boolean = false;
      
      private var _menuBarItemState:String;
      
      private var defaultSkinUsesStates:Boolean = false;
      
      protected var label:IUITextField;
      
      private var _menuBar:MenuBar;
      
      protected var icon:IFlexDisplayObject;
      
      public function MenuBarItem()
      {
         super();
         mouseChildren = false;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(super.enabled == param1)
         {
            return;
         }
         super.enabled = param1;
         enabledChanged = true;
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var styleDeclaration:CSSStyleDeclaration = new CSSStyleDeclaration();
         styleDeclaration.factory = function():void
         {
            this.borderStyle = "none";
         };
         createLabel(-1);
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            return super.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return label.y + label.baselinePosition;
      }
      
      public function get menuBarItemIndex() : int
      {
         return _menuBarItemIndex;
      }
      
      public function get menuBar() : MenuBar
      {
         return _menuBar;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      mx_internal function getLabel() : IUITextField
      {
         return label;
      }
      
      public function set fontContext(param1:IFlexModuleFactory) : void
      {
         this.moduleFactory = param1;
      }
      
      public function get dataProvider() : Object
      {
         return _dataProvider;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Class = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         super.commitProperties();
         if(hasFontContextChanged() && label != null)
         {
            _loc2_ = getChildIndex(DisplayObject(label));
            removeLabel();
            createLabel(_loc2_);
         }
         if(enabledChanged)
         {
            enabledChanged = false;
            if(label)
            {
               label.enabled = enabled;
            }
            if(!enabled)
            {
               menuBarItemState = "itemUpSkin";
            }
         }
         if(icon)
         {
            removeChild(DisplayObject(icon));
            icon = null;
         }
         if(_data)
         {
            _loc1_ = menuBar.itemToIcon(data);
            if(_loc1_)
            {
               icon = new _loc1_();
               addChild(DisplayObject(icon));
            }
            label.visible = true;
            if(menuBar.labelFunction != null)
            {
               _loc3_ = menuBar.labelFunction(_data);
            }
            if(_loc3_ == null)
            {
               _loc3_ = menuBar.itemToLabel(_data);
            }
            label.text = _loc3_;
            label.enabled = enabled;
         }
         else
         {
            label.text = " ";
         }
         invalidateDisplayList();
      }
      
      private function viewSkin(param1:String) : void
      {
         var _loc3_:IFlexDisplayObject = null;
         var _loc2_:Class = Class(getStyle(param1));
         var _loc4_:String = "";
         if(!_loc2_)
         {
            _loc2_ = Class(getStyle(skinName));
            if(param1 == "itemDownSkin")
            {
               _loc4_ = "down";
            }
            else if(param1 == "itemOverSkin")
            {
               _loc4_ = "over";
            }
            else if(param1 == "itemUpSkin")
            {
               _loc4_ = "up";
            }
            if(defaultSkinUsesStates)
            {
               param1 = skinName;
            }
            if(!checkedDefaultSkin && _loc2_)
            {
               _loc3_ = IFlexDisplayObject(new _loc2_());
               if(!(_loc3_ is IProgrammaticSkin) && _loc3_ is IStateClient)
               {
                  defaultSkinUsesStates = true;
                  param1 = skinName;
               }
               if(_loc3_)
               {
                  checkedDefaultSkin = true;
               }
            }
         }
         _loc3_ = IFlexDisplayObject(getChildByName(param1));
         if(!_loc3_)
         {
            if(_loc2_)
            {
               _loc3_ = new _loc2_();
               DisplayObject(_loc3_).name = param1;
               if(_loc3_ is ISimpleStyleClient)
               {
                  ISimpleStyleClient(_loc3_).styleName = this;
               }
               addChildAt(DisplayObject(_loc3_),0);
            }
         }
         _loc3_.setActualSize(unscaledWidth,unscaledHeight);
         if(currentSkin)
         {
            currentSkin.visible = false;
         }
         if(_loc3_)
         {
            _loc3_.visible = true;
         }
         currentSkin = _loc3_;
         if(defaultSkinUsesStates && currentSkin is IStateClient)
         {
            IStateClient(currentSkin).currentState = _loc4_;
         }
      }
      
      public function set menuBarItemState(param1:String) : void
      {
         _menuBarItemState = param1;
         viewSkin(_menuBarItemState);
      }
      
      public function set menuBarItemIndex(param1:int) : void
      {
         _menuBarItemIndex = param1;
      }
      
      mx_internal function removeLabel() : void
      {
         if(label)
         {
            removeChild(DisplayObject(label));
            label = null;
         }
      }
      
      public function set data(param1:Object) : void
      {
         _data = param1;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(icon && leftMargin < icon.measuredWidth)
         {
            leftMargin = icon.measuredWidth;
         }
         measuredWidth = label.getExplicitOrMeasuredWidth() + leftMargin;
         measuredHeight = label.getExplicitOrMeasuredHeight();
         if(icon && icon.measuredHeight > measuredHeight)
         {
            measuredHeight = icon.measuredHeight + 2;
         }
      }
      
      mx_internal function createLabel(param1:int) : void
      {
         if(!label)
         {
            label = IUITextField(createInFontContext(UITextField));
            label.styleName = this;
            label.selectable = false;
            if(param1 == -1)
            {
               addChild(DisplayObject(label));
            }
            else
            {
               addChildAt(DisplayObject(label),param1);
            }
         }
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function set menuBar(param1:MenuBar) : void
      {
         _menuBar = param1;
      }
      
      public function get menuBarItemState() : String
      {
         return _menuBarItemState;
      }
      
      public function set dataProvider(param1:Object) : void
      {
         _dataProvider = param1;
         invalidateProperties();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(icon)
         {
            icon.x = (leftMargin - icon.measuredWidth) / 2;
            icon.setActualSize(icon.measuredWidth,icon.measuredHeight);
            label.x = leftMargin;
         }
         else
         {
            label.x = leftMargin / 2;
         }
         label.setActualSize(param1 - leftMargin,label.getExplicitOrMeasuredHeight());
         label.y = (param2 - label.height) / 2;
         if(icon)
         {
            icon.y = (param2 - icon.height) / 2;
         }
         menuBarItemState = "itemUpSkin";
      }
   }
}

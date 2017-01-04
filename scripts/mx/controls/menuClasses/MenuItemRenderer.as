package mx.controls.menuClasses
{
   import flash.display.DisplayObject;
   import flash.utils.getDefinitionByName;
   import mx.controls.Menu;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListData;
   import mx.core.FlexVersion;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   
   use namespace mx_internal;
   
   public class MenuItemRenderer extends UIComponent implements IDataRenderer, IListItemRenderer, IMenuItemRenderer, IDropInListItemRenderer, IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _data:Object;
      
      protected var branchIcon:IFlexDisplayObject;
      
      private var _listData:ListData;
      
      protected var typeIcon:IFlexDisplayObject;
      
      private var _menu:Menu;
      
      private var _icon:IFlexDisplayObject;
      
      protected var label:IUITextField;
      
      protected var separatorIcon:IFlexDisplayObject;
      
      public function MenuItemRenderer()
      {
         super();
      }
      
      public function get measuredTypeIconWidth() : Number
      {
         var _loc2_:Class = null;
         var _loc3_:IMenuDataDescriptor = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc1_:Number = getStyle("horizontalGap");
         if(typeIcon)
         {
            return typeIcon.measuredWidth + _loc1_;
         }
         if(_data)
         {
            _loc3_ = Menu(_listData.owner).dataDescriptor;
            _loc4_ = _loc3_.isEnabled(_data);
            _loc5_ = _loc3_.getType(_data);
            if(_loc5_)
            {
               _loc5_ = _loc5_.toLowerCase();
               if(_loc5_ == "radio")
               {
                  _loc2_ = getStyle(!!_loc4_?"radioIcon":"radioDisabledIcon");
               }
               else if(_loc5_ == "check")
               {
                  _loc2_ = getStyle(!!_loc4_?"checkIcon":"checkDisabledIcon");
               }
               if(_loc2_)
               {
                  typeIcon = new _loc2_();
                  _loc6_ = typeIcon.measuredWidth;
                  typeIcon = null;
                  return _loc6_ + _loc1_;
               }
            }
         }
         return 0;
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            super.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return label.y + label.baselinePosition;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         createLabel(-1);
      }
      
      public function get measuredBranchIconWidth() : Number
      {
         var _loc1_:Number = getStyle("horizontalGap");
         return !!branchIcon?Number(branchIcon.measuredWidth + _loc1_):Number(0);
      }
      
      public function get measuredIconWidth() : Number
      {
         var _loc1_:Number = getStyle("horizontalGap");
         return !!_icon?Number(_icon.measuredWidth + _loc1_):Number(0);
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      public function set menu(param1:Menu) : void
      {
         _menu = param1;
      }
      
      public function set fontContext(param1:IFlexModuleFactory) : void
      {
         this.moduleFactory = param1;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Class = null;
         var _loc2_:Class = null;
         var _loc3_:Class = null;
         var _loc4_:Class = null;
         var _loc5_:int = 0;
         var _loc6_:IMenuDataDescriptor = null;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         super.commitProperties();
         if(hasFontContextChanged() && label != null)
         {
            _loc5_ = getChildIndex(DisplayObject(label));
            removeLabel();
            createLabel(_loc5_);
         }
         if(_icon)
         {
            removeChild(DisplayObject(_icon));
            _icon = null;
         }
         if(typeIcon)
         {
            removeChild(DisplayObject(typeIcon));
            typeIcon = null;
         }
         if(separatorIcon)
         {
            removeChild(DisplayObject(separatorIcon));
            separatorIcon = null;
         }
         if(branchIcon)
         {
            removeChild(DisplayObject(branchIcon));
            branchIcon = null;
         }
         if(_data)
         {
            _loc6_ = Menu(_listData.owner).dataDescriptor;
            _loc7_ = _loc6_.isEnabled(_data);
            _loc8_ = _loc6_.getType(_data);
            if(_loc8_.toLowerCase() == "separator")
            {
               label.text = "";
               label.visible = false;
               _loc3_ = getStyle("separatorSkin");
               separatorIcon = new _loc3_();
               addChild(DisplayObject(separatorIcon));
               return;
            }
            label.visible = true;
            if(_listData.icon)
            {
               _loc9_ = _listData.icon;
               if(_loc9_ is Class)
               {
                  _loc1_ = Class(_loc9_);
               }
               else if(_loc9_ is String)
               {
                  _loc1_ = Class(getDefinitionByName(String(_loc9_)));
               }
               _icon = new _loc1_();
               addChild(DisplayObject(_icon));
            }
            label.text = _listData.label;
            label.enabled = _loc7_;
            if(_loc6_.isToggled(_data))
            {
               _loc10_ = _loc6_.getType(_data);
               if(_loc10_)
               {
                  _loc10_ = _loc10_.toLowerCase();
                  if(_loc10_ == "radio")
                  {
                     _loc2_ = getStyle(!!_loc7_?"radioIcon":"radioDisabledIcon");
                  }
                  else if(_loc10_ == "check")
                  {
                     _loc2_ = getStyle(!!_loc7_?"checkIcon":"checkDisabledIcon");
                  }
                  if(_loc2_)
                  {
                     typeIcon = new _loc2_();
                     addChild(DisplayObject(typeIcon));
                  }
               }
            }
            if(_loc6_.isBranch(_data))
            {
               _loc4_ = getStyle(!!_loc7_?"branchIcon":"branchDisabledIcon");
               if(_loc4_)
               {
                  branchIcon = new _loc4_();
                  addChild(DisplayObject(branchIcon));
               }
            }
         }
         else
         {
            label.text = " ";
         }
         invalidateDisplayList();
      }
      
      mx_internal function getLabel() : IUITextField
      {
         return label;
      }
      
      public function set listData(param1:BaseListData) : void
      {
         _listData = ListData(param1);
         invalidateProperties();
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         if(!param1 || param1 == "styleName" || param1.toLowerCase().indexOf("icon") != -1)
         {
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function set data(param1:Object) : void
      {
         _data = param1;
         invalidateProperties();
         invalidateSize();
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      override protected function measure() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         super.measure();
         if(separatorIcon)
         {
            measuredWidth = separatorIcon.measuredWidth;
            measuredHeight = separatorIcon.measuredHeight;
            return;
         }
         if(_listData)
         {
            _loc1_ = MenuListData(_listData).maxMeasuredIconWidth;
            _loc2_ = MenuListData(_listData).maxMeasuredTypeIconWidth;
            _loc3_ = MenuListData(_listData).maxMeasuredBranchIconWidth;
            _loc4_ = MenuListData(_listData).useTwoColumns;
            _loc5_ = Math.max(getStyle("leftIconGap"),!!_loc4_?Number(_loc1_ + _loc2_):Number(Math.max(_loc1_,_loc2_)));
            _loc6_ = Math.max(getStyle("rightIconGap"),_loc3_);
            if(isNaN(explicitWidth))
            {
               measuredWidth = label.measuredWidth + _loc5_ + _loc6_ + 7;
            }
            else
            {
               label.width = explicitWidth - _loc5_ - _loc6_;
            }
            measuredHeight = label.measuredHeight;
            if(_icon && _icon.measuredHeight > measuredHeight)
            {
               measuredHeight = _icon.measuredHeight;
            }
            if(typeIcon && typeIcon.measuredHeight > measuredHeight)
            {
               measuredHeight = typeIcon.measuredHeight;
            }
            if(branchIcon && branchIcon.measuredHeight > measuredHeight)
            {
               measuredHeight = branchIcon.measuredHeight;
            }
         }
      }
      
      public function get menu() : Menu
      {
         return _menu;
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      mx_internal function createLabel(param1:int) : void
      {
         if(!label)
         {
            label = IUITextField(createInFontContext(UITextField));
            label.styleName = this;
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
      
      protected function set icon(param1:IFlexDisplayObject) : void
      {
         _icon = param1;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         super.updateDisplayList(param1,param2);
         if(_listData)
         {
            if(Menu(_listData.owner).dataDescriptor.getType(_data).toLowerCase() == "separator")
            {
               if(separatorIcon)
               {
                  separatorIcon.x = 2;
                  separatorIcon.y = (param2 - separatorIcon.measuredHeight) / 2;
                  separatorIcon.setActualSize(param1 - 4,separatorIcon.measuredHeight);
               }
               return;
            }
            _loc3_ = MenuListData(_listData).maxMeasuredIconWidth;
            _loc4_ = MenuListData(_listData).maxMeasuredTypeIconWidth;
            _loc5_ = MenuListData(_listData).maxMeasuredBranchIconWidth;
            _loc6_ = MenuListData(_listData).useTwoColumns;
            _loc7_ = Math.max(getStyle("leftIconGap"),!!_loc6_?Number(_loc3_ + _loc4_):Number(Math.max(_loc3_,_loc4_)));
            _loc8_ = Math.max(getStyle("rightIconGap"),_loc5_);
            if(_loc6_)
            {
               _loc11_ = (_loc7_ - (_loc3_ + _loc4_)) / 2;
               if(_icon)
               {
                  _icon.x = _loc11_ + (_loc3_ - _icon.measuredWidth) / 2;
                  _icon.setActualSize(_icon.measuredWidth,_icon.measuredHeight);
               }
               if(typeIcon)
               {
                  typeIcon.x = _loc11_ + _loc3_ + (_loc4_ - typeIcon.measuredWidth) / 2;
                  typeIcon.setActualSize(typeIcon.measuredWidth,typeIcon.measuredHeight);
               }
            }
            else
            {
               if(_icon)
               {
                  _icon.x = (_loc7_ - _icon.measuredWidth) / 2;
                  _icon.setActualSize(_icon.measuredWidth,_icon.measuredHeight);
               }
               if(typeIcon)
               {
                  typeIcon.x = (_loc7_ - typeIcon.measuredWidth) / 2;
                  typeIcon.setActualSize(typeIcon.measuredWidth,typeIcon.measuredHeight);
               }
            }
            if(branchIcon)
            {
               branchIcon.x = param1 - _loc8_ + (_loc8_ - branchIcon.measuredWidth) / 2;
               branchIcon.setActualSize(branchIcon.measuredWidth,branchIcon.measuredHeight);
            }
            label.x = _loc7_;
            label.setActualSize(param1 - _loc7_ - _loc8_,label.getExplicitOrMeasuredHeight());
            if(_listData && !Menu(_listData.owner).showDataTips)
            {
               label.text = _listData.label;
               if(label.truncateToFit())
               {
                  toolTip = _listData.label;
               }
               else
               {
                  toolTip = null;
               }
            }
            _loc9_ = getStyle("verticalAlign");
            if(_loc9_ == "top")
            {
               label.y = 0;
               if(_icon)
               {
                  _icon.y = 0;
               }
               if(typeIcon)
               {
                  typeIcon.y = 0;
               }
               if(branchIcon)
               {
                  branchIcon.y = 0;
               }
            }
            else if(_loc9_ == "bottom")
            {
               label.y = param2 - label.height + 2;
               if(_icon)
               {
                  _icon.y = param2 - _icon.height;
               }
               if(typeIcon)
               {
                  typeIcon.y = param2 - typeIcon.height;
               }
               if(branchIcon)
               {
                  branchIcon.y = param2 - branchIcon.height;
               }
            }
            else
            {
               label.y = (param2 - label.height) / 2;
               if(_icon)
               {
                  _icon.y = (param2 - _icon.height) / 2;
               }
               if(typeIcon)
               {
                  typeIcon.y = (param2 - typeIcon.height) / 2;
               }
               if(branchIcon)
               {
                  branchIcon.y = (param2 - branchIcon.height) / 2;
               }
            }
            if(data && parent)
            {
               if(!enabled)
               {
                  _loc10_ = getStyle("disabledColor");
               }
               else if(Menu(listData.owner).isItemHighlighted(listData.uid))
               {
                  _loc10_ = getStyle("textRollOverColor");
               }
               else if(Menu(listData.owner).isItemSelected(listData.uid))
               {
                  _loc10_ = getStyle("textSelectedColor");
               }
               else
               {
                  _loc10_ = getStyle("color");
               }
               label.setColor(_loc10_);
            }
         }
      }
      
      protected function get icon() : IFlexDisplayObject
      {
         var _loc1_:IMenuDataDescriptor = null;
         var _loc2_:String = null;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            if(_data)
            {
               _loc1_ = Menu(_listData.owner).dataDescriptor;
               _loc2_ = _loc1_.getType(_data);
               if(_loc2_.toLowerCase() == "separator")
               {
                  return separatorIcon;
               }
            }
            if(typeIcon)
            {
               return typeIcon;
            }
            return _icon;
         }
         return _icon;
      }
      
      mx_internal function removeLabel() : void
      {
         if(label)
         {
            removeChild(DisplayObject(label));
            label = null;
         }
      }
   }
}

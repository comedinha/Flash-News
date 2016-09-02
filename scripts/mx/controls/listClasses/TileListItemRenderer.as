package mx.controls.listClasses
{
   import mx.core.UIComponent;
   import mx.core.IDataRenderer;
   import mx.core.IFontContextComponent;
   import mx.core.mx_internal;
   import mx.core.IFlexModuleFactory;
   import mx.events.ToolTipEvent;
   import flash.geom.Rectangle;
   import mx.events.InterManagerRequest;
   import mx.core.IToolTip;
   import mx.managers.ISystemManager;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import mx.core.IUITextField;
   import mx.events.FlexEvent;
   import mx.core.UITextField;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   
   use namespace mx_internal;
   
   public class TileListItemRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var iconOnly:Boolean = false;
      
      private var _listData:mx.controls.listClasses.ListData;
      
      private var _data:Object;
      
      protected var label:IUITextField;
      
      private var listOwner:mx.controls.listClasses.TileBase;
      
      protected var icon:IFlexDisplayObject;
      
      private var iconClass:Class;
      
      public function TileListItemRenderer()
      {
         super();
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,toolTipShowHandler);
      }
      
      public function set fontContext(param1:IFlexModuleFactory) : void
      {
         this.moduleFactory = param1;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc9_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = !!iconOnly?Number(0):Number(getStyle("verticalGap"));
         var _loc4_:Number = getStyle("paddingLeft");
         var _loc5_:Number = getStyle("paddingRight");
         if(icon)
         {
            icon.width = Math.min(param1 - (_loc4_ + _loc5_),icon.measuredWidth);
            icon.height = Math.min(Math.max(param2 - _loc3_ - label.getExplicitOrMeasuredHeight(),0),icon.measuredHeight);
            icon.x = _loc4_ + (param1 - _loc4_ - _loc5_ - icon.width) / 2;
         }
         label.width = param1 - (_loc4_ + _loc5_);
         label.height = Math.min(label.getExplicitOrMeasuredHeight(),!!icon?Number(Math.max(param2 - _loc3_ - icon.height,0)):Number(param2));
         label.x = _loc4_;
         if(listOwner && listOwner.showDataTips)
         {
            if(label.textWidth > label.width || listOwner.dataTipField && listOwner.dataTipField != "label" || listOwner.dataTipFunction != null)
            {
               toolTip = listOwner.itemToDataTip(_data);
            }
            else
            {
               toolTip = null;
            }
         }
         else
         {
            toolTip = null;
         }
         var _loc7_:Number = label.height;
         if(icon)
         {
            _loc7_ = _loc7_ + (icon.height + _loc3_);
         }
         var _loc8_:String = getStyle("verticalAlign");
         if(_loc8_ == "top")
         {
            _loc6_ = 0;
            if(icon)
            {
               icon.y = _loc6_;
               _loc6_ = _loc6_ + (_loc3_ + icon.height);
            }
            label.y = _loc6_;
         }
         else if(_loc8_ == "bottom")
         {
            _loc6_ = param2 - label.height;
            label.y = _loc6_;
            if(icon)
            {
               _loc6_ = _loc6_ - (_loc3_ + icon.height);
               icon.y = _loc6_;
            }
         }
         else
         {
            _loc6_ = (param2 - _loc7_) / 2;
            if(icon)
            {
               icon.y = _loc6_;
               _loc6_ = _loc6_ + (_loc3_ + icon.height);
            }
            label.y = _loc6_;
         }
         if(data && parent)
         {
            if(!enabled)
            {
               _loc9_ = getStyle("disabledColor");
            }
            else if(listOwner.isItemSelected(listData.uid))
            {
               _loc9_ = getStyle("textSelectedColor");
            }
            else if(listOwner.isItemHighlighted(listData.uid))
            {
               _loc9_ = getStyle("textRollOverColor");
            }
            else
            {
               _loc9_ = getStyle("color");
            }
            label.setColor(_loc9_);
         }
      }
      
      protected function toolTipShowHandler(param1:ToolTipEvent) : void
      {
         var _loc5_:Rectangle = null;
         var _loc8_:InterManagerRequest = null;
         var _loc2_:IToolTip = param1.toolTip;
         var _loc3_:ISystemManager = systemManager.topLevelSystemManager;
         var _loc4_:DisplayObject = _loc3_.getSandboxRoot();
         var _loc6_:Point = new Point(0,0);
         _loc6_ = label.localToGlobal(_loc6_);
         _loc6_ = _loc4_.globalToLocal(_loc6_);
         _loc2_.move(_loc6_.x,_loc6_.y + (height - _loc2_.height) / 2);
         if(_loc3_ != _loc4_)
         {
            _loc8_ = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"getVisibleApplicationRect");
            _loc4_.dispatchEvent(_loc8_);
            _loc5_ = Rectangle(_loc8_.value);
         }
         else
         {
            _loc5_ = _loc3_.getVisibleApplicationRect();
         }
         var _loc7_:Number = _loc5_.x + _loc5_.width;
         _loc6_.x = _loc2_.x;
         _loc6_.y = _loc2_.y;
         _loc6_ = _loc4_.localToGlobal(_loc6_);
         if(_loc6_.x + _loc2_.width > _loc7_)
         {
            _loc2_.move(_loc2_.x - (_loc6_.x + _loc2_.width - _loc7_),_loc2_.y);
         }
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
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Class = null;
         super.commitProperties();
         if(hasFontContextChanged() && label != null)
         {
            _loc1_ = getChildIndex(DisplayObject(label));
            removeLabel();
            createLabel(_loc1_);
         }
         if(icon && !_data)
         {
            removeChild(DisplayObject(icon));
            icon = null;
            iconClass = null;
         }
         if(_data)
         {
            listOwner = TileBase(_listData.owner);
            if(_listData.icon)
            {
               _loc2_ = _listData.icon;
               if(iconClass != _loc2_)
               {
                  iconClass = _loc2_;
                  if(icon)
                  {
                     removeChild(DisplayObject(icon));
                  }
                  icon = new iconClass();
                  addChild(DisplayObject(icon));
               }
            }
            label.text = _listData.label;
            label.multiline = listOwner.variableRowHeight;
            label.wordWrap = listOwner.wordWrap;
         }
         else
         {
            label.text = " ";
            toolTip = null;
         }
      }
      
      public function set data(param1:Object) : void
      {
         _data = param1;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
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
      
      override protected function measure() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         super.measure();
         var _loc1_:Number = 0;
         if(icon)
         {
            _loc1_ = _loc1_ + icon.measuredHeight;
         }
         if(label.text == "" || label.text == " " || label.text == null)
         {
            label.explicitHeight = 0;
            iconOnly = true;
         }
         else
         {
            label.explicitHeight = NaN;
            _loc1_ = _loc1_ + getStyle("verticalGap");
            iconOnly = false;
         }
         measuredHeight = label.getExplicitOrMeasuredHeight() + _loc1_;
         _loc2_ = getStyle("paddingLeft");
         _loc3_ = getStyle("paddingRight");
         measuredWidth = label.getExplicitOrMeasuredWidth() + _loc2_ + _loc3_;
         if(icon && icon.measuredWidth + _loc2_ + _loc3_ > measuredWidth)
         {
            measuredWidth = icon.measuredWidth + _loc2_ + _loc3_;
         }
      }
      
      mx_internal function removeLabel() : void
      {
         if(label)
         {
            removeChild(DisplayObject(label));
            label = null;
         }
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         createLabel(-1);
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
   }
}

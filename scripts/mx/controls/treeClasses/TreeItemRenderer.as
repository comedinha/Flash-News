package mx.controls.treeClasses
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.controls.Tree;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.FlexVersion;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IToolTip;
   import mx.core.IUITextField;
   import mx.core.SpriteAsset;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.InterManagerRequest;
   import mx.events.ToolTipEvent;
   import mx.events.TreeEvent;
   import mx.managers.ISystemManager;
   
   use namespace mx_internal;
   
   public class TreeItemRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      protected var disclosureIcon:IFlexDisplayObject;
      
      private var _listData:TreeListData;
      
      private var _data:Object;
      
      protected var label:IUITextField;
      
      private var listOwner:Tree;
      
      protected var icon:IFlexDisplayObject;
      
      public function TreeItemRenderer()
      {
         super();
      }
      
      public function set fontContext(param1:IFlexModuleFactory) : void
      {
         this.moduleFactory = param1;
      }
      
      mx_internal function getLabel() : IUITextField
      {
         return label;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Class = null;
         var _loc3_:* = undefined;
         var _loc4_:SpriteAsset = null;
         var _loc5_:Class = null;
         super.commitProperties();
         if(hasFontContextChanged() && label != null)
         {
            _loc1_ = getChildIndex(DisplayObject(label));
            removeLabel();
            createLabel(_loc1_);
         }
         if(icon)
         {
            removeChild(DisplayObject(icon));
            icon = null;
         }
         if(disclosureIcon)
         {
            disclosureIcon.removeEventListener(MouseEvent.MOUSE_DOWN,disclosureMouseDownHandler);
            removeChild(DisplayObject(disclosureIcon));
            disclosureIcon = null;
         }
         if(_data != null)
         {
            listOwner = Tree(_listData.owner);
            if(_listData.disclosureIcon)
            {
               _loc2_ = _listData.disclosureIcon;
               _loc3_ = new _loc2_();
               if(!(_loc3_ is InteractiveObject))
               {
                  _loc4_ = new SpriteAsset();
                  _loc4_.addChild(_loc3_ as DisplayObject);
                  disclosureIcon = _loc4_ as IFlexDisplayObject;
               }
               else
               {
                  disclosureIcon = _loc3_;
               }
               addChild(disclosureIcon as DisplayObject);
               disclosureIcon.addEventListener(MouseEvent.MOUSE_DOWN,disclosureMouseDownHandler);
            }
            if(_listData.icon)
            {
               _loc5_ = _listData.icon;
               icon = new _loc5_();
               addChild(DisplayObject(icon));
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
         invalidateDisplayList();
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
      
      public function set listData(param1:BaseListData) : void
      {
         _listData = TreeListData(param1);
         invalidateProperties();
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
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:Number = !!_data?Number(_listData.indent):Number(0);
         if(disclosureIcon)
         {
            _loc1_ = _loc1_ + disclosureIcon.width;
         }
         if(icon)
         {
            _loc1_ = _loc1_ + icon.measuredWidth;
         }
         if(label.width < 4 || label.height < 4)
         {
            label.width = 4;
            label.height = 16;
         }
         if(isNaN(explicitWidth))
         {
            _loc1_ = _loc1_ + label.getExplicitOrMeasuredWidth();
            measuredWidth = _loc1_;
            measuredHeight = label.getExplicitOrMeasuredHeight();
         }
         else
         {
            label.width = Math.max(explicitWidth - _loc1_,4);
            measuredHeight = label.getExplicitOrMeasuredHeight();
            if(icon && icon.measuredHeight > measuredHeight)
            {
               measuredHeight = icon.measuredHeight;
            }
         }
      }
      
      mx_internal function removeLabel() : void
      {
         if(label != null)
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
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,toolTipShowHandler);
      }
      
      private function toolTipShowHandler(param1:ToolTipEvent) : void
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
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      private function disclosureMouseDownHandler(param1:Event) : void
      {
         param1.stopPropagation();
         if(listOwner.isOpening || !listOwner.enabled)
         {
            return;
         }
         var _loc2_:Boolean = _listData.open;
         _listData.open = !_loc2_;
         listOwner.dispatchTreeEvent(TreeEvent.ITEM_OPENING,_listData.item,this,param1,!_loc2_,true,true);
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      mx_internal function getDisclosureIcon() : IFlexDisplayObject
      {
         return disclosureIcon;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc5_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = !!_data?Number(_listData.indent):Number(0);
         if(disclosureIcon)
         {
            disclosureIcon.x = _loc3_;
            _loc3_ = disclosureIcon.x + disclosureIcon.width;
            disclosureIcon.setActualSize(disclosureIcon.width,disclosureIcon.height);
            disclosureIcon.visible = !!_data?Boolean(_listData.hasChildren):false;
         }
         if(icon)
         {
            icon.x = _loc3_;
            _loc3_ = icon.x + icon.measuredWidth;
            icon.setActualSize(icon.measuredWidth,icon.measuredHeight);
         }
         label.x = _loc3_;
         label.setActualSize(param1 - _loc3_,measuredHeight);
         var _loc4_:String = getStyle("verticalAlign");
         if(_loc4_ == "top")
         {
            label.y = 0;
            if(icon)
            {
               icon.y = 0;
            }
            if(disclosureIcon)
            {
               disclosureIcon.y = 0;
            }
         }
         else if(_loc4_ == "bottom")
         {
            label.y = param2 - label.height + 2;
            if(icon)
            {
               icon.y = param2 - icon.height;
            }
            if(disclosureIcon)
            {
               disclosureIcon.y = param2 - disclosureIcon.height;
            }
         }
         else
         {
            label.y = (param2 - label.height) / 2;
            if(icon)
            {
               icon.y = (param2 - icon.height) / 2;
            }
            if(disclosureIcon)
            {
               disclosureIcon.y = (param2 - disclosureIcon.height) / 2;
            }
         }
         if(data && parent)
         {
            if(!enabled)
            {
               _loc5_ = getStyle("disabledColor");
            }
            else if(listOwner.isItemHighlighted(listData.uid))
            {
               _loc5_ = getStyle("textRollOverColor");
            }
            else if(listOwner.isItemSelected(listData.uid))
            {
               _loc5_ = getStyle("textSelectedColor");
            }
            else
            {
               _loc5_ = getStyle("color");
            }
            label.setColor(_loc5_);
         }
         if(_data != null)
         {
            if(listOwner.showDataTips)
            {
               if(label.textWidth > label.width || listOwner.dataTipFunction != null)
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
         }
      }
   }
}

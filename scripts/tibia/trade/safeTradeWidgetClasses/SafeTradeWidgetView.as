package tibia.trade.safeTradeWidgetClasses
{
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   import mx.controls.Button;
   import mx.collections.IList;
   import mx.core.Container;
   import tibia.container.containerViewWidgetClasses.ContainerSlot;
   import flash.events.MouseEvent;
   import tibia.appearances.AppearanceInstance;
   import mx.containers.HBox;
   import mx.controls.Text;
   import shared.controls.CustomLabel;
   import mx.core.ScrollPolicy;
   import shared.controls.CustomButton;
   import mx.containers.ViewStack;
   import tibia.network.Communication;
   import mx.controls.Label;
   import tibia.§sidebar:ns_sidebar_internal§.widgetInstance;
   
   public class SafeTradeWidgetView extends WidgetView
   {
      
      private static const BUNDLE:String = "SafeTradeWidget";
      
      private static const STATE_WAIT:int = 0;
      
      private static const STATE_ACCEPT:int = 2;
      
      private static const STATE_TRADE:int = 1;
       
      
      private var m_UncommittedOtherItems:Boolean = false;
      
      private var m_UIStateTradeAccept:Button = null;
      
      private var m_UncommittedOwnItems:Boolean = false;
      
      protected var m_OwnItems:IList = null;
      
      protected var m_State:int = 0;
      
      private var m_UIOwnItems:Container = null;
      
      private var m_UncommittedOtherName:Boolean = false;
      
      private var m_UIOwnName:Label = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIOtherName:Label = null;
      
      private var m_UIStateTradeReject:Button = null;
      
      protected var m_OwnName:String = null;
      
      protected var m_OtherItems:IList = null;
      
      protected var m_OtherName:String = null;
      
      private var m_UIOtherItems:Container = null;
      
      private var m_UIStateWaitReject:Button = null;
      
      private var m_UncommittedOwnName:Boolean = false;
      
      private var m_UIFooter:ViewStack = null;
      
      private var m_UIStateAcceptReject:Button = null;
      
      public function SafeTradeWidgetView()
      {
         super();
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         titleText = resourceManager.getString(BUNDLE,"TITLE");
      }
      
      function get otherItems() : IList
      {
         return this.m_OtherItems;
      }
      
      private function buildItemSlots(param1:IList, param2:Container) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ContainerSlot = null;
         _loc3_ = param2.numChildren - 1;
         while(_loc3_ >= 0)
         {
            _loc5_ = param2.removeChildAt(_loc3_) as ContainerSlot;
            if(_loc5_ != null)
            {
               _loc5_.removeEventListener(MouseEvent.CLICK,this.onItemClick);
               _loc5_.removeEventListener(MouseEvent.RIGHT_CLICK,this.onItemClick);
            }
            _loc3_--;
         }
         if(param1 != null)
         {
            _loc3_ = 0;
            _loc4_ = param1.length;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = new ContainerSlot();
               _loc5_.appearance = param1.getItemAt(_loc3_) as AppearanceInstance;
               _loc5_.styleName = getStyle("tradeItemSlotStyle");
               _loc5_.addEventListener(MouseEvent.CLICK,this.onItemClick);
               _loc5_.addEventListener(MouseEvent.RIGHT_CLICK,this.onItemClick);
               param2.addChild(_loc5_);
               _loc3_++;
            }
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:HBox = null;
         var _loc2_:HBox = null;
         var _loc3_:HBox = null;
         var _loc4_:Text = null;
         var _loc5_:HBox = null;
         var _loc6_:HBox = null;
         var _loc7_:Text = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new HBox();
            _loc1_.percentHeight = NaN;
            _loc1_.percentWidth = 100;
            _loc1_.setStyle("horizontalAlign","left");
            _loc1_.setStyle("horizontalGap",1);
            this.m_UIOwnName = new CustomLabel();
            this.m_UIOwnName.height = NaN;
            this.m_UIOwnName.text = this.m_OwnName;
            this.m_UIOwnName.width = 76;
            this.m_UIOwnName.setStyle("fontSize",9);
            this.m_UIOwnName.setStyle("paddingTop",-2);
            this.m_UIOwnName.setStyle("paddingBottom",-2);
            _loc1_.addChild(this.m_UIOwnName);
            this.m_UIOtherName = new CustomLabel();
            this.m_UIOtherName.height = NaN;
            this.m_UIOtherName.text = this.m_OtherName;
            this.m_UIOtherName.width = 76;
            this.m_UIOtherName.setStyle("fontSize",9);
            this.m_UIOtherName.setStyle("paddingTop",-2);
            this.m_UIOtherName.setStyle("paddingBottom",-2);
            _loc1_.addChild(this.m_UIOtherName);
            addChild(_loc1_);
            this.m_UIOwnItems = new CustomTile();
            CustomTile(this.m_UIOwnItems).columns = 2;
            this.m_UIOwnItems.percentHeight = 100;
            this.m_UIOwnItems.percentWidth = 50;
            this.m_UIOwnItems.styleName = getStyle("tradeItemListStyle");
            this.m_UIOwnItems.verticalScrollPolicy = ScrollPolicy.OFF;
            this.m_UIOwnItems.setStyle("borderColor",getStyle("separatorColor"));
            this.m_UIOwnItems.setStyle("borderSides","right");
            this.m_UIOwnItems.setStyle("borderStyle","solid");
            this.m_UIOtherItems = new CustomTile();
            CustomTile(this.m_UIOtherItems).columns = 2;
            this.m_UIOtherItems.percentHeight = 100;
            this.m_UIOtherItems.percentWidth = 50;
            this.m_UIOtherItems.styleName = getStyle("tradeItemListStyle");
            this.m_UIOtherItems.verticalScrollPolicy = ScrollPolicy.OFF;
            this.m_UIOtherItems.setStyle("borderColor",getStyle("separatorColor"));
            this.m_UIOtherItems.setStyle("borderSides","left");
            this.m_UIOtherItems.setStyle("borderStyle","solid");
            _loc2_ = new HBox();
            _loc2_.percentHeight = 100;
            _loc2_.percentWidth = 100;
            _loc2_.verticalScrollPolicy = ScrollPolicy.ON;
            _loc2_.addChild(this.m_UIOwnItems);
            _loc2_.addChild(this.m_UIOtherItems);
            _loc2_.setStyle("horizontalGap",-1);
            _loc2_.setStyle("borderColor",getStyle("separatorColor"));
            _loc2_.setStyle("borderSides","top bottom");
            _loc2_.setStyle("borderStyle","solid");
            addChild(_loc2_);
            _loc3_ = new HBox();
            _loc3_.percentHeight = 100;
            _loc3_.percentWidth = 100;
            _loc3_.setStyle("horizontalAlign","right");
            _loc3_.setStyle("verticalAlign","middle");
            _loc4_ = new Text();
            _loc4_.percentHeight = 100;
            _loc4_.percentWidth = 100;
            _loc4_.text = resourceManager.getString(BUNDLE,"FOOTER_WAIT_FOR_OFFER_TEXT");
            _loc4_.setStyle("fontSize",9);
            _loc4_.setStyle("textAlign","center");
            _loc4_.setStyle("paddingTop",-3);
            _loc4_.setStyle("paddingBottom",-3);
            _loc3_.addChild(_loc4_);
            this.m_UIStateWaitReject = new CustomButton();
            this.m_UIStateWaitReject.label = resourceManager.getString(BUNDLE,"FOOTER_CANCEL_LABEL");
            this.m_UIStateWaitReject.toolTip = resourceManager.getString(BUNDLE,"FOOTER_CANCEL_TOOLTIP");
            this.m_UIStateWaitReject.addEventListener(MouseEvent.CLICK,this.onReject);
            _loc3_.addChild(this.m_UIStateWaitReject);
            _loc5_ = new HBox();
            _loc5_.percentHeight = 100;
            _loc5_.percentWidth = 100;
            _loc5_.setStyle("horizontalAlign","right");
            _loc5_.setStyle("verticalAlign","middle");
            this.m_UIStateTradeAccept = new CustomButton();
            this.m_UIStateTradeAccept.label = resourceManager.getString(BUNDLE,"FOOTER_ACCEPT_LABEL");
            this.m_UIStateTradeAccept.toolTip = resourceManager.getString(BUNDLE,"FOOTER_ACCEPT_TOOLTIP");
            this.m_UIStateTradeAccept.addEventListener(MouseEvent.CLICK,this.onAccept);
            _loc5_.addChild(this.m_UIStateTradeAccept);
            this.m_UIStateTradeReject = new CustomButton();
            this.m_UIStateTradeReject.label = resourceManager.getString(BUNDLE,"FOOTER_REJECT_LABEL");
            this.m_UIStateTradeReject.toolTip = resourceManager.getString(BUNDLE,"FOOTER_REJECT_TOOLTIP");
            this.m_UIStateTradeReject.addEventListener(MouseEvent.CLICK,this.onReject);
            _loc5_.addChild(this.m_UIStateTradeReject);
            _loc6_ = new HBox();
            _loc6_.percentHeight = 100;
            _loc6_.percentWidth = 100;
            _loc6_.setStyle("horizontalAlign","right");
            _loc6_.setStyle("verticalAlign","middle");
            _loc7_ = new Text();
            _loc7_.percentHeight = 100;
            _loc7_.percentWidth = 100;
            _loc7_.text = resourceManager.getString(BUNDLE,"FOOTER_WAIT_FOR_ACCEPT_TEXT");
            _loc7_.setStyle("fontSize",9);
            _loc7_.setStyle("textAlign","center");
            _loc7_.setStyle("paddingTop",-3);
            _loc7_.setStyle("paddingBottom",-3);
            _loc6_.addChild(_loc7_);
            this.m_UIStateAcceptReject = new CustomButton();
            this.m_UIStateAcceptReject.label = resourceManager.getString(BUNDLE,"FOOTER_REJECT_LABEL");
            this.m_UIStateAcceptReject.toolTip = resourceManager.getString(BUNDLE,"FOOTER_REJECT_TOOLTIP");
            this.m_UIStateAcceptReject.addEventListener(MouseEvent.CLICK,this.onReject);
            _loc6_.addChild(this.m_UIStateAcceptReject);
            this.m_UIFooter = new ViewStack();
            this.m_UIFooter.minHeight = 24;
            this.m_UIFooter.minWidth = NaN;
            this.m_UIFooter.percentHeight = NaN;
            this.m_UIFooter.percentWidth = 100;
            this.m_UIFooter.selectedIndex = this.m_State;
            this.m_UIFooter.addChild(_loc3_);
            this.m_UIFooter.addChild(_loc5_);
            this.m_UIFooter.addChild(_loc6_);
            addChild(this.m_UIFooter);
            this.m_UIConstructed = true;
         }
      }
      
      protected function onItemClick(param1:MouseEvent) : void
      {
         var _loc2_:ContainerSlot = param1.currentTarget as ContainerSlot;
         if(_loc2_ == null || _loc2_.parent == null)
         {
            return;
         }
         var _loc3_:int = -1;
         var _loc4_:int = _loc2_.parent.getChildIndex(_loc2_);
         if(_loc2_.parent == this.m_UIOwnItems)
         {
            _loc3_ = 0;
         }
         else if(_loc2_.parent == this.m_UIOtherItems)
         {
            _loc3_ = 1;
         }
         var _loc5_:Communication = Tibia.s_GetCommunication();
         if(_loc5_ != null && _loc5_.isGameRunning)
         {
            _loc5_.sendCINSPECTTRADE(_loc3_,_loc4_);
         }
      }
      
      function set otherItems(param1:IList) : void
      {
         if(this.m_OtherItems != param1)
         {
            this.m_OtherItems = param1;
            this.m_UncommittedOtherItems = true;
            invalidateProperties();
         }
      }
      
      function get ownName() : String
      {
         return this.m_OwnName;
      }
      
      function set ownItems(param1:IList) : void
      {
         if(this.m_OwnItems != param1)
         {
            this.m_OwnItems = param1;
            this.m_UncommittedOwnItems = true;
            invalidateProperties();
         }
      }
      
      function get otherName() : String
      {
         return this.m_OtherName;
      }
      
      override function releaseInstance() : void
      {
         super.releaseInstance();
         this.buildItemSlots(null,this.m_UIOtherItems);
         this.buildItemSlots(null,this.m_UIOwnItems);
         this.m_UIStateAcceptReject.removeEventListener(MouseEvent.CLICK,this.onReject);
         this.m_UIStateTradeAccept.removeEventListener(MouseEvent.CLICK,this.onAccept);
         this.m_UIStateTradeReject.removeEventListener(MouseEvent.CLICK,this.onReject);
         this.m_UIStateWaitReject.removeEventListener(MouseEvent.CLICK,this.onReject);
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         var _loc1_:Boolean = false;
         if(this.m_UncommittedOwnName)
         {
            _loc1_ = true;
            this.m_UIOwnName.text = this.m_OwnName;
            this.m_UncommittedOwnName = false;
         }
         if(this.m_UncommittedOwnItems)
         {
            _loc1_ = true;
            this.buildItemSlots(this.m_OwnItems,this.m_UIOwnItems);
            this.m_UncommittedOwnItems = false;
         }
         if(this.m_UncommittedOtherName)
         {
            _loc1_ = true;
            this.m_UIOtherName.text = this.m_OtherName;
            this.m_UncommittedOtherName = false;
         }
         if(this.m_UncommittedOtherItems)
         {
            _loc1_ = true;
            this.buildItemSlots(this.m_OtherItems,this.m_UIOtherItems);
            this.m_UncommittedOtherItems = false;
         }
         if(_loc1_)
         {
            if(this.m_OwnName != null && this.m_OwnName.length > 0 && (this.m_OwnItems != null && this.m_OwnItems.length > 0) && (this.m_OtherName != null && this.m_OtherName.length > 0) && (this.m_OtherItems != null && this.m_OtherItems.length > 0))
            {
               this.m_State = STATE_TRADE;
            }
            else
            {
               this.m_State = STATE_WAIT;
            }
            this.m_UIFooter.selectedIndex = this.m_State;
         }
      }
      
      protected function onAccept(param1:MouseEvent) : void
      {
         var _loc2_:Communication = null;
         if(this.m_State == STATE_TRADE)
         {
            _loc2_ = Tibia.s_GetCommunication();
            if(_loc2_ != null && _loc2_.isGameRunning)
            {
               _loc2_.sendCACCEPTTRADE();
            }
            this.m_State = STATE_ACCEPT;
            this.m_UIFooter.selectedIndex = this.m_State;
         }
      }
      
      function get ownItems() : IList
      {
         return this.m_OwnItems;
      }
      
      protected function onReject(param1:MouseEvent) : void
      {
         if(widgetInstance != null)
         {
            widgetInstance.close();
         }
      }
      
      function set ownName(param1:String) : void
      {
         if(this.m_OwnName != param1)
         {
            this.m_OwnName = param1;
            this.m_UncommittedOwnName = true;
            invalidateProperties();
         }
      }
      
      function set otherName(param1:String) : void
      {
         if(this.m_OtherName != param1)
         {
            this.m_OtherName = param1;
            this.m_UncommittedOtherName = true;
            invalidateProperties();
         }
      }
   }
}

import mx.containers.Tile;
import mx.core.EdgeMetrics;
import mx.core.mx_internal;

class CustomTile extends Tile
{
    
   
   protected var m_Columns:int = 1;
   
   function CustomTile()
   {
      super();
   }
   
   override protected function measure() : void
   {
      var _loc1_:EdgeMetrics = null;
      var _loc2_:int = 0;
      if(numChildren < 1)
      {
         measuredMinHeight = measuredHeight = 0;
         measuredMinWidth = measuredWidth = 0;
      }
      else
      {
         _loc1_ = viewMetricsAndPadding;
         _loc2_ = Math.ceil(numChildren / this.m_Columns);
         mx_internal::findCellSize();
         measuredMinHeight = mx_internal::cellHeight;
         measuredHeight = _loc1_.top + _loc2_ * mx_internal::cellHeight + (_loc2_ - 1) * getStyle("verticalGap") + _loc1_.bottom;
         measuredMinWidth = mx_internal::cellWidth;
         measuredWidth = _loc1_.left + this.m_Columns * mx_internal::cellWidth + (this.m_Columns - 1) * getStyle("horizontalGap") + _loc1_.right;
      }
   }
   
   override public function get width() : Number
   {
      return measuredWidth;
   }
   
   public function set columns(param1:int) : void
   {
      if(param1 < 1)
      {
         param1 = 1;
      }
      if(this.m_Columns != param1)
      {
         this.m_Columns = param1;
         invalidateDisplayList();
         invalidateSize();
      }
   }
   
   public function get columns() : int
   {
      return this.m_Columns;
   }
   
   override public function get height() : Number
   {
      return measuredHeight;
   }
}

package tibia.chat
{
   import tibia.game.PopUpBase;
   import mx.collections.IList;
   import mx.controls.TextInput;
   import mx.controls.List;
   import mx.events.FlexEvent;
   import mx.events.CloseEvent;
   import flash.events.MouseEvent;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.mx_internal;
   import mx.controls.Label;
   import shared.controls.CustomList;
   import flash.events.KeyboardEvent;
   import tibia.input.PreventWhitespaceInput;
   import flash.events.TextEvent;
   
   public class ChannelSelectionWidget extends PopUpBase
   {
      
      private static const BUNDLE:String = "ChannelSelectionWidget";
       
      
      protected var m_UncommittedChannels:Boolean = false;
      
      protected var m_Channels:IList = null;
      
      protected var m_UIInput:TextInput = null;
      
      protected var m_UIList:List = null;
      
      private var m_UIConstructed:Boolean = false;
      
      public function ChannelSelectionWidget()
      {
         super();
         title = resourceManager.getString(BUNDLE,"TITLE");
      }
      
      public function set channels(param1:IList) : void
      {
         if(this.m_Channels != param1)
         {
            this.m_Channels = param1;
            this.m_UncommittedChannels = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedChannels)
         {
            this.m_UIList.dataProvider = this.m_Channels;
            this.m_UncommittedChannels = false;
         }
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         var _loc2_:ChatStorage = Tibia.s_GetChatStorage();
         if(param1 && _loc2_ != null)
         {
            if(this.m_UIInput.text.length > 0)
            {
               _loc2_.joinChannel(this.m_UIInput.text);
            }
            else if(this.m_UIList.selectedItem != null)
            {
               _loc2_.joinChannel(this.m_UIList.selectedItem.ID);
            }
         }
         super.hide(param1);
      }
      
      protected function onChannelEnter(param1:FlexEvent) : void
      {
         var _loc2_:* = false;
         var _loc3_:CloseEvent = null;
         if(param1 != null)
         {
            _loc2_ = this.m_UIInput.text.length > 0;
            _loc3_ = new CloseEvent(CloseEvent.CLOSE,false,true);
            _loc3_.detail = !!_loc2_?int(PopUpBase.BUTTON_OKAY):int(PopUpBase.BUTTON_CANCEL);
            dispatchEvent(_loc3_);
            if(!_loc3_.cancelable || !_loc3_.isDefaultPrevented())
            {
               this.m_UIInput.removeEventListener(FlexEvent.ENTER,this.onChannelEnter);
               this.hide(_loc2_);
            }
         }
      }
      
      public function get channels() : IList
      {
         return this.m_Channels;
      }
      
      protected function onChannelDoubleClick(param1:MouseEvent) : void
      {
         var _loc2_:IListItemRenderer = null;
         var _loc3_:CloseEvent = null;
         if(param1 != null)
         {
            _loc2_ = this.m_UIList.mx_internal::mouseEventToItemRendererOrEditor(param1);
            if(_loc2_ != null)
            {
               _loc3_ = new CloseEvent(CloseEvent.CLOSE,false,true);
               _loc3_.detail = PopUpBase.BUTTON_OKAY;
               dispatchEvent(_loc3_);
               if(!_loc3_.cancelable || !_loc3_.isDefaultPrevented())
               {
                  this.m_UIList.removeEventListener(MouseEvent.DOUBLE_CLICK,this.onChannelDoubleClick);
                  this.hide(true);
               }
            }
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Label = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new Label();
            _loc1_.text = resourceManager.getString(BUNDLE,"LBL_SELECT_CHANNEL");
            addChild(_loc1_);
            this.m_UIList = new CustomList();
            this.m_UIList.dataProvider = this.m_Channels;
            this.m_UIList.doubleClickEnabled = true;
            this.m_UIList.labelField = "name";
            this.m_UIList.percentWidth = 100;
            this.m_UIList.percentHeight = 100;
            this.m_UIList.addEventListener(MouseEvent.DOUBLE_CLICK,this.onChannelDoubleClick);
            addChild(this.m_UIList);
            _loc1_ = new Label();
            _loc1_.text = resourceManager.getString(BUNDLE,"LBL_ENTER_NAME");
            addChild(_loc1_);
            this.m_UIInput = new TextInput();
            this.m_UIInput.percentHeight = NaN;
            this.m_UIInput.percentWidth = 100;
            this.m_UIInput.addEventListener(FlexEvent.ENTER,this.onChannelEnter);
            this.m_UIInput.addEventListener(KeyboardEvent.KEY_DOWN,PreventWhitespaceInput);
            this.m_UIInput.addEventListener(TextEvent.TEXT_INPUT,PreventWhitespaceInput);
            addChild(this.m_UIInput);
            this.m_UIConstructed = true;
         }
      }
   }
}

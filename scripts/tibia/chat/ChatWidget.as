package tibia.chat
{
   import mx.containers.VBox;
   import mx.events.PropertyChangeEvent;
   import mx.events.CollectionEvent;
   import flash.system.System;
   import flash.ui.Keyboard;
   import tibia.chat.chatWidgetClasses.ChannelView;
   import tibia.input.MappingSet;
   import mx.events.DividerEvent;
   import mx.containers.HBox;
   import tibia.chat.chatWidgetClasses.ChannelTabBar;
   import tibia.controls.DynamicTabBar;
   import mx.core.ScrollPolicy;
   import tibia.controls.dynamicTabBarClasses.TabBarEvent;
   import tibia.chat.chatWidgetClasses.ChannelEvent;
   import shared.controls.CustomButton;
   import flash.events.MouseEvent;
   import tibia.input.staticaction.StaticActionList;
   import mx.events.DragEvent;
   import tibia.chat.chatWidgetClasses.ChannelTab;
   import flash.events.Event;
   import shared.controls.CustomDividedBox;
   import mx.containers.BoxDirection;
   import tibia.chat.chatWidgetClasses.PassiveTextField;
   import flash.display.DisplayObject;
   import tibia.chat.chatWidgetClasses.CycleButtonSkin;
   import mx.containers.Box;
   import mx.controls.Button;
   import tibia.options.OptionsStorage;
   import mx.core.DragSource;
   import mx.managers.DragManager;
   import mx.containers.DividedBox;
   import mx.core.UIComponent;
   import mx.core.EdgeMetrics;
   import mx.core.Container;
   import mx.collections.IList;
   import tibia.network.Communication;
   import flash.utils.getTimer;
   import mx.events.CollectionEventKind;
   import flash.display.InteractiveObject;
   import tibia.chat.chatWidgetClasses.ChannelContextMenu;
   import tibia.chat.chatWidgetClasses.ChannelTabContextMenu;
   import mx.core.mx_internal;
   import mx.core.IBorder;
   import shared.utility.StringHelper;
   import shared.utility.RingBuffer;
   
   public class ChatWidget extends VBox
   {
      
      public static const BUNDLE:String = "ChatWidget";
      
      protected static const HISTORY_SIZE:int = 1000;
      
      protected static const VOLUME_DATA:Array = [{
         "mode":MessageMode.MESSAGE_SAY,
         "label":"BTN_CHANNEL_VOLUME_SAY_LABEL"
      },{
         "mode":MessageMode.MESSAGE_YELL,
         "label":"BTN_CHANNEL_VOLUME_YELL_LABEL"
      },{
         "mode":MessageMode.MESSAGE_WHISPER,
         "label":"BTN_CHANNEL_VOLUME_WHISPER_LABEL"
      }];
       
      
      private var m_UncommittedRightChannel:Boolean = false;
      
      protected var m_LeftChannel:tibia.chat.Channel = null;
      
      protected var m_ChatStorage:tibia.chat.ChatStorage = null;
      
      protected var m_UILeftView:ChannelView = null;
      
      protected var m_RightChannel:tibia.chat.Channel = null;
      
      protected var m_UITitleRow:Box = null;
      
      private var m_UncommittedLeftChannel:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncommittedChatStorage:Boolean = false;
      
      protected var m_UIButtonSetCycle:Button = null;
      
      protected var m_Volume:int = 1;
      
      private var m_UncommittedOptions:Boolean = false;
      
      protected var m_HistoryIndex:int = -1;
      
      protected var m_UIViewContainer:DividedBox = null;
      
      protected var m_UIRightHolder:Container = null;
      
      protected var m_UIButtonIgnore:Button = null;
      
      protected var m_UIInputRow:Box = null;
      
      private var m_UncommittedMappingSetID:Boolean = true;
      
      protected var m_MappingSetID:int = 0;
      
      protected var m_UITabBar:ChannelTabBar = null;
      
      private var m_UncommittedVolume:Boolean = false;
      
      protected var m_MappingMode:int = 1;
      
      protected var m_History:IList = null;
      
      protected var m_UIRightTab:ChannelTab = null;
      
      protected var m_Options:OptionsStorage = null;
      
      protected var m_UIButtonVolume:Button = null;
      
      private var m_UncommittedMappingMode:Boolean = true;
      
      protected var m_UIInput:PassiveTextField = null;
      
      protected var m_UIRightView:ChannelView = null;
      
      protected var m_UIButtonOpen:Button = null;
      
      protected var m_UIButtonMappingMode:Button = null;
      
      public function ChatWidget()
      {
         super();
         focusEnabled = false;
         tabEnabled = false;
         tabChildren = false;
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         this.m_History = new RingBuffer(HISTORY_SIZE);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onMouseDown);
      }
      
      public function get chatStorage() : tibia.chat.ChatStorage
      {
         return this.m_ChatStorage;
      }
      
      public function set chatStorage(param1:tibia.chat.ChatStorage) : void
      {
         var _loc2_:int = 0;
         var _loc3_:tibia.chat.Channel = null;
         if(this.m_ChatStorage != param1)
         {
            _loc2_ = 0;
            _loc3_ = null;
            if(this.m_ChatStorage != null)
            {
               _loc2_ = this.m_ChatStorage.channels.length - 1;
               while(_loc2_ >= 0)
               {
                  _loc3_ = this.m_ChatStorage.getChannelAt(_loc2_);
                  _loc3_.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onChannelPropertyChange);
                  _loc2_--;
               }
               this.m_ChatStorage.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onChannelAddRemove);
            }
            this.m_ChatStorage = param1;
            if(this.m_ChatStorage != null)
            {
               _loc2_ = this.m_ChatStorage.channels.length - 1;
               while(_loc2_ >= 0)
               {
                  _loc3_ = this.m_ChatStorage.getChannelAt(_loc2_);
                  _loc3_.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onChannelPropertyChange);
                  _loc2_--;
               }
               this.m_ChatStorage.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onChannelAddRemove);
            }
            this.m_UncommittedChatStorage = true;
            this.m_UncommittedMappingMode = true;
            invalidateProperties();
         }
      }
      
      public function get leftChannel() : tibia.chat.Channel
      {
         return this.m_LeftChannel;
      }
      
      function onChatCopyPaste(param1:uint, param2:uint, param3:uint, param4:Boolean, param5:Boolean, param6:Boolean) : Boolean
      {
         var _loc7_:String = null;
         if(param4 || !param5 || param6)
         {
            throw new ArgumentError("ChatWidget.onChatSelection: Invalid modifier state: " + param4 + "/" + param5 + "/" + param6);
         }
         switch(param3)
         {
            case Keyboard.A:
               if(this.m_UIInput.length > 0)
               {
                  this.m_UIInput.setSelection(0,this.m_UIInput.length);
               }
               else
               {
                  this.m_UILeftView.selectAll();
                  this.m_UIRightView.clearSelection();
               }
               break;
            case Keyboard.C:
            case Keyboard.X:
               _loc7_ = null;
               if((_loc7_ = this.m_UIInput.getSelectedText()) != null && _loc7_.length > 0)
               {
                  System.setClipboard(_loc7_);
                  if(param3 == Keyboard.X)
                  {
                     this.m_UIInput.replaceSelectedText("");
                  }
               }
               else if((_loc7_ = this.m_UILeftView.getSelectedText()) != null && _loc7_.length > 0)
               {
                  System.setClipboard(_loc7_);
               }
               else if((_loc7_ = this.m_UIRightView.getSelectedText()) != null && _loc7_.length > 0)
               {
                  System.setClipboard(_loc7_);
               }
               break;
            case Keyboard.V:
               break;
            default:
               throw new ArgumentError("ChatWidget.onChatSelection: Invalid key code.");
         }
         return true;
      }
      
      private function getVolumeEnabled() : Boolean
      {
         return this.m_MappingMode != MappingSet.CHAT_MODE_OFF && this.m_LeftChannel != null && (this.m_LeftChannel.ID === tibia.chat.ChatStorage.LOCAL_CHANNEL_ID || this.m_LeftChannel.ID == tibia.chat.ChatStorage.SERVER_CHANNEL_ID || !this.m_LeftChannel.sendAllowed);
      }
      
      protected function onRightChannelResize(param1:DividerEvent) : void
      {
         var a_Event:DividerEvent = param1;
         if(a_Event != null)
         {
            callLater(function():void
            {
               if(m_Options != null)
               {
                  m_Options.generalUIChatLeftViewWidth = getViewWidth();
               }
            });
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UITitleRow = new HBox();
            this.m_UITitleRow.height = 27;
            this.m_UITitleRow.percentHeight = NaN;
            this.m_UITitleRow.percentWidth = 100;
            this.m_UITitleRow.width = NaN;
            this.m_UITitleRow.styleName = getStyle("titleBarStyle");
            this.m_UITabBar = new ChannelTabBar();
            this.m_UITabBar.closePolicy = DynamicTabBar.CLOSE_SELECTED;
            this.m_UITabBar.dragEnabled = true;
            this.m_UITabBar.dropDownPolicy = DynamicTabBar.DROP_DOWN_ON;
            this.m_UITabBar.height = 27;
            this.m_UITabBar.labelField = "name";
            this.m_UITabBar.percentHeight = NaN;
            this.m_UITabBar.percentWidth = 100;
            this.m_UITabBar.scrollPolicy = ScrollPolicy.ON;
            this.m_UITabBar.styleName = getStyle("titleTabBarStyle");
            this.m_UITabBar.tabResize = true;
            this.m_UITabBar.tabMinWidth = 100;
            this.m_UITabBar.toolTipField = "name";
            this.m_UITabBar.width = NaN;
            this.m_UITabBar.addEventListener(TabBarEvent.CLOSE,this.onChannelClose);
            this.m_UITabBar.addEventListener(TabBarEvent.SELECT,this.onChannelSelect);
            this.m_UITabBar.addEventListener(ChannelEvent.HIGHLIGHT,this.onChannelHighlight);
            this.m_UITabBar.addEventListener(ChannelEvent.TAB_CONTEXT_MENU,this.onChannelContextMenu);
            this.m_UITitleRow.addChild(this.m_UITabBar);
            this.m_UIButtonOpen = new CustomButton();
            this.m_UIButtonOpen.styleName = getStyle("titleOpenButtonStyle");
            this.m_UIButtonOpen.toolTip = resourceManager.getString(BUNDLE,"TIP_CHANNEL_OPEN");
            this.m_UIButtonOpen.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               StaticActionList.CHAT_CHANNEL_OPEN.perform();
            });
            this.m_UITitleRow.addChild(this.m_UIButtonOpen);
            this.m_UIButtonIgnore = new CustomButton();
            this.m_UIButtonIgnore.styleName = getStyle("titleIgnoreButtonStyle");
            this.m_UIButtonIgnore.toolTip = resourceManager.getString(BUNDLE,"TIP_CHANNEL_IGNORE");
            this.m_UIButtonIgnore.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               StaticActionList.MISC_SHOW_EDIT_IGNORELIST.perform();
            });
            this.m_UITitleRow.addChild(this.m_UIButtonIgnore);
            this.m_UIRightHolder = new HBox();
            this.m_UIRightHolder.height = 27;
            this.m_UIRightHolder.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.m_UIRightHolder.styleName = getStyle("titleRightHolderStyle");
            this.m_UIRightHolder.toolTip = resourceManager.getString(BUNDLE,"TIP_RIGHT_TAB_EMPTY");
            this.m_UIRightHolder.verticalScrollPolicy = ScrollPolicy.OFF;
            this.m_UIRightHolder.width = 100;
            this.m_UIRightHolder.addEventListener(DragEvent.DRAG_DROP,this.onRightChannelDrag);
            this.m_UIRightHolder.addEventListener(DragEvent.DRAG_ENTER,this.onRightChannelDrag);
            this.m_UITitleRow.addChild(this.m_UIRightHolder);
            this.m_UIRightTab = new ChannelTab();
            this.m_UIRightTab.closePolicy = DynamicTabBar.CLOSE_SELECTED;
            this.m_UIRightTab.height = NaN;
            this.m_UIRightTab.label = this.m_RightChannel != null?this.m_RightChannel.name:null;
            this.m_UIRightTab.selected = this.m_RightChannel != null;
            this.m_UIRightTab.styleName = getStyle("titleRightTabStyle");
            this.m_UIRightTab.visible = this.m_RightChannel != null;
            this.m_UIRightTab.width = this.m_UIRightHolder.width * 0.9;
            this.m_UIRightTab.addEventListener(Event.CLOSE,this.onRightChannelClose);
            this.m_UIRightHolder.addChild(this.m_UIRightTab);
            addChild(this.m_UITitleRow);
            this.m_UIViewContainer = new CustomDividedBox();
            this.m_UIViewContainer.direction = BoxDirection.HORIZONTAL;
            this.m_UIViewContainer.minHeight = 48;
            this.m_UIViewContainer.percentHeight = 100;
            this.m_UIViewContainer.percentWidth = 100;
            this.m_UIViewContainer.resizeToContent = true;
            this.m_UIViewContainer.styleName = getStyle("viewBarStyle");
            this.m_UIViewContainer.addEventListener(DividerEvent.DIVIDER_RELEASE,this.onRightChannelResize);
            this.m_UILeftView = new ChannelView();
            this.m_UILeftView.channel = this.m_LeftChannel;
            this.m_UILeftView.minWidth = 200;
            this.m_UILeftView.percentHeight = 100;
            this.m_UILeftView.percentWidth = 100;
            this.m_UILeftView.styleName = this.m_RightChannel == null?getStyle("viewBarSingleViewStyle"):getStyle("viewBarLeftViewStyle");
            this.m_UILeftView.addEventListener(ChannelEvent.NICKLIST_CONTEXT_MENU,this.onChannelContextMenu);
            this.m_UILeftView.addEventListener(ChannelEvent.VIEW_CONTEXT_MENU,this.onChannelContextMenu);
            this.m_UIViewContainer.addChild(this.m_UILeftView);
            this.m_UIRightView = new ChannelView();
            this.m_UIRightView.channel = this.m_RightChannel;
            this.m_UIRightView.minWidth = 200;
            this.m_UIRightView.percentHeight = 100;
            this.m_UIRightView.percentWidth = 0;
            this.m_UIRightView.styleName = getStyle("viewBarRightViewStyle");
            this.m_UIRightView.addEventListener(ChannelEvent.NICKLIST_CONTEXT_MENU,this.onChannelContextMenu);
            this.m_UIRightView.addEventListener(ChannelEvent.VIEW_CONTEXT_MENU,this.onChannelContextMenu);
            if(this.m_RightChannel != null)
            {
               this.m_UIViewContainer.addChild(this.m_UIRightView);
            }
            addChild(this.m_UIViewContainer);
            this.m_UIInputRow = new HBox();
            this.m_UIInputRow.height = 27;
            this.m_UIInputRow.percentHeight = NaN;
            this.m_UIInputRow.percentWidth = 100;
            this.m_UIInputRow.width = NaN;
            this.m_UIInputRow.styleName = getStyle("inputBarStyle");
            this.m_UIButtonVolume = new CustomButton();
            this.m_UIButtonVolume.enabled = this.getVolumeEnabled();
            this.m_UIButtonVolume.label = resourceManager.getString(BUNDLE,this.getVolumeLabelResource());
            this.m_UIButtonVolume.width = 74;
            this.m_UIButtonVolume.addEventListener(MouseEvent.CLICK,this.onVolumeClick);
            this.m_UIInputRow.addChild(this.m_UIButtonVolume);
            this.m_UIInput = new PassiveTextField();
            this.m_UIInput.percentHeight = NaN;
            this.m_UIInput.percentWidth = 100;
            this.m_UIInput.styleName = getStyle("inputBarTextFieldStyle");
            this.m_UIInput.maxLength = tibia.chat.ChatStorage.MAX_TALK_LENGTH;
            this.m_UIInput.addEventListener(MouseEvent.MOUSE_DOWN,this.onInputMouseDown);
            this.m_UIInput.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onInputMouseDown);
            this.m_UIInputRow.addChild(this.m_UIInput);
            this.m_UIButtonMappingMode = new CustomButton();
            this.m_UIButtonMappingMode.width = 74;
            this.m_UIButtonMappingMode.addEventListener(MouseEvent.CLICK,this.onMappingModeClick);
            this.m_UIInputRow.addChild(this.m_UIButtonMappingMode);
            this.m_UIButtonSetCycle = new CustomButton();
            this.m_UIButtonSetCycle.width = 120 + 2 * (6 + 9 * 0.66 + 2);
            this.m_UIButtonSetCycle.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               if(param1.localX < DisplayObject(param1.currentTarget).width / 2)
               {
                  StaticActionList.MISC_MAPPING_PREV.perform();
               }
               else
               {
                  StaticActionList.MISC_MAPPING_NEXT.perform();
               }
            });
            this.m_UIButtonSetCycle.setStyle("skin",CycleButtonSkin);
            this.m_UIButtonSetCycle.setStyle("arrowPadding",6);
            this.m_UIButtonSetCycle.setStyle("arrowHeight",15 * 0.66);
            this.m_UIButtonSetCycle.setStyle("arrowWidth",9 * 0.66);
            this.m_UIButtonSetCycle.setStyle("paddingLeft",6 + 9 * 0.66 + 2);
            this.m_UIButtonSetCycle.setStyle("paddingRight",6 + 9 * 0.66 + 2);
            this.m_UIInputRow.addChild(this.m_UIButtonSetCycle);
            addChild(this.m_UIInputRow);
            this.m_UIConstructed = true;
         }
      }
      
      private function getVolumeLabelResource() : String
      {
         var _loc1_:int = 0;
         while(_loc1_ < VOLUME_DATA.length)
         {
            if(VOLUME_DATA[_loc1_].mode == this.m_Volume)
            {
               return VOLUME_DATA[_loc1_].label;
            }
            _loc1_++;
         }
         return null;
      }
      
      public function get volume() : int
      {
         return this.m_Volume;
      }
      
      public function set mappingMode(param1:int) : void
      {
         if(param1 != MappingSet.CHAT_MODE_OFF && param1 != MappingSet.CHAT_MODE_ON && param1 != MappingSet.CHAT_MODE_TEMPORARY)
         {
            throw new ArgumentError("ChatWidget.set mappingMode: Invalid mode: " + param1);
         }
         this.m_MappingMode = param1;
         this.m_UncommittedMappingMode = true;
         invalidateProperties();
      }
      
      private function updateViewWidths(param1:Number = NaN) : void
      {
         if(isNaN(param1) && this.m_Options != null)
         {
            param1 = this.m_Options.generalUIChatLeftViewWidth;
         }
         if(!isNaN(param1) && this.m_UILeftView.channel != null && this.m_UIRightView.channel != null)
         {
            this.m_UILeftView.percentWidth = Math.round(param1);
            this.m_UIRightView.percentWidth = 100 - this.m_UILeftView.percentWidth;
         }
         else
         {
            this.m_UILeftView.percentWidth = 100;
            this.m_UIRightView.percentWidth = 0;
         }
      }
      
      public function get text() : String
      {
         return this.m_UIInput.text;
      }
      
      protected function onVolumeClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(param1 != null)
         {
            _loc2_ = 0;
            _loc2_ = 0;
            while(_loc2_ < VOLUME_DATA.length)
            {
               if(VOLUME_DATA[_loc2_].mode == this.m_Volume)
               {
                  _loc2_++;
                  break;
               }
               _loc2_++;
            }
            this.volume = VOLUME_DATA[_loc2_ % VOLUME_DATA.length].mode;
         }
      }
      
      public function set volume(param1:int) : void
      {
         if(param1 != MessageMode.MESSAGE_SAY && param1 != MessageMode.MESSAGE_WHISPER && param1 != MessageMode.MESSAGE_YELL)
         {
            param1 = MessageMode.MESSAGE_SAY;
         }
         if(this.m_LeftChannel == null || this.m_LeftChannel.ID !== tibia.chat.ChatStorage.LOCAL_CHANNEL_ID && this.m_LeftChannel.ID !== tibia.chat.ChatStorage.SERVER_CHANNEL_ID && this.m_LeftChannel.sendAllowed)
         {
            param1 = MessageMode.MESSAGE_SAY;
         }
         if(this.m_Volume != param1)
         {
            this.m_Volume = param1;
            this.m_UncommittedVolume = true;
            invalidateProperties();
         }
      }
      
      protected function onChannelPropertyChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:uint = 0;
         if(param1 != null)
         {
            switch(param1.property)
            {
               case "sendAllowed":
                  _loc2_ = this.getChannelTextColor(this.m_LeftChannel);
                  this.m_UIInput.setStyle("color",_loc2_);
                  this.m_UIButtonVolume.enabled = this.getVolumeEnabled();
            }
         }
      }
      
      protected function onChannelClose(param1:TabBarEvent) : void
      {
         var _loc2_:tibia.chat.Channel = null;
         if(param1 != null)
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            _loc2_ = Channel(this.m_ChatStorage.getChannelAt(param1.index));
            if(_loc2_.closable)
            {
               this.m_ChatStorage.leaveChannel(_loc2_);
            }
         }
      }
      
      protected function onChannelSelect(param1:TabBarEvent) : void
      {
         if(param1 != null && this.m_ChatStorage != null)
         {
            this.leftChannel = Channel(this.m_ChatStorage.getChannelAt(param1.index));
         }
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         if(this.m_Options != param1)
         {
            if(this.m_Options != null)
            {
               this.m_Options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_Options = param1;
            if(this.m_Options != null)
            {
               this.m_Options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_UncommittedOptions = true;
            invalidateProperties();
         }
      }
      
      public function get rightChannel() : tibia.chat.Channel
      {
         return this.m_RightChannel;
      }
      
      protected function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:uint = 0;
         if(param1 != null)
         {
            _loc2_ = 0;
            switch(param1.property)
            {
               case "generalUILeftViewWidth":
                  this.updateViewWidths();
                  break;
               case "generalInputSetID":
               case "generalInputSetMode":
               case "mappingSet":
                  this.mappingMode = this.m_Options.generalInputSetMode;
                  this.mappingSetID = this.m_Options.generalInputSetID;
                  break;
               case "messageFilterSet":
               case "textColour":
               case "highlightColour":
                  _loc2_ = this.getChannelTextColor(this.m_LeftChannel);
                  this.m_UIInput.setStyle("color",_loc2_);
                  break;
               case "*":
                  this.updateViewWidths();
                  this.mappingSetID = this.m_Options.generalInputSetID;
                  this.mappingMode = this.m_Options.generalInputSetMode;
                  _loc2_ = this.getChannelTextColor(this.m_LeftChannel);
                  this.m_UIInput.setStyle("color",_loc2_);
            }
         }
      }
      
      protected function onRightChannelDrag(param1:DragEvent) : void
      {
         var _loc2_:DragSource = null;
         var _loc3_:int = 0;
         var _loc4_:tibia.chat.Channel = null;
         if(param1 != null)
         {
            _loc2_ = param1.dragSource;
            if(!_loc2_.hasFormat("dragType") || _loc2_.dataForFormat("dragType") != "dynamicTab")
            {
               return;
            }
            if(!_loc2_.hasFormat("dragTabBar") || _loc2_.dataForFormat("dragTabBar") != this.m_UITabBar)
            {
               return;
            }
            if(!_loc2_.hasFormat("dragTabIndex"))
            {
               return;
            }
            _loc3_ = int(_loc2_.dataForFormat("dragTabIndex"));
            _loc4_ = this.m_ChatStorage != null?this.m_ChatStorage.getChannelAt(_loc3_):null;
            switch(param1.type)
            {
               case DragEvent.DRAG_DROP:
                  this.rightChannel = _loc4_;
                  break;
               case DragEvent.DRAG_ENTER:
                  DragManager.acceptDragDrop(this.m_UIRightHolder);
            }
         }
      }
      
      public function set text(param1:String) : void
      {
         this.m_UIInput.text = param1;
      }
      
      override protected function measure() : void
      {
         var _loc5_:UIComponent = null;
         super.measure();
         var _loc1_:int = 0;
         var _loc2_:int = numChildren;
         var _loc3_:Number = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = UIComponent(getChildAt(_loc1_));
            if(!isNaN(_loc5_.explicitHeight))
            {
               _loc3_ = _loc3_ + _loc5_.explicitHeight;
            }
            else if(!isNaN(_loc5_.explicitMinHeight))
            {
               _loc3_ = _loc3_ + _loc5_.explicitMinHeight;
            }
            else if(!isNaN(_loc5_.measuredMinHeight))
            {
               _loc3_ = _loc3_ + _loc5_.measuredMinHeight;
            }
            _loc1_++;
         }
         if(_loc2_ > 1)
         {
            _loc3_ = _loc3_ + (_loc2_ - 1) * getStyle("verticalGap");
         }
         var _loc4_:EdgeMetrics = viewMetricsAndPadding;
         explicitMinHeight = _loc3_ + _loc4_.top + _loc4_.bottom;
      }
      
      private function getViewWidth() : Number
      {
         if(this.m_UILeftView == null || this.m_UIRightView == null || !isNaN(this.m_UILeftView.minWidth) && this.m_UILeftView.width == this.m_UILeftView.minWidth)
         {
            return 0;
         }
         if(this.m_UIRightView.channel == null || !isNaN(this.m_UIRightView.minWidth) && this.m_UIRightView.width == this.m_UIRightView.minWidth)
         {
            return 100;
         }
         return Math.round(100 * this.m_UILeftView.width / (this.m_UILeftView.width + this.m_UIRightView.width));
      }
      
      public function get tabBar() : ChannelTabBar
      {
         return this.m_UITabBar;
      }
      
      protected function onMappingModeClick(param1:MouseEvent) : void
      {
         if(param1 != null)
         {
            this.mappingMode = this.mappingMode == MappingSet.CHAT_MODE_OFF?int(MappingSet.CHAT_MODE_ON):int(MappingSet.CHAT_MODE_OFF);
         }
      }
      
      public function set rightChannel(param1:tibia.chat.Channel) : void
      {
         if(this.m_RightChannel != param1)
         {
            this.m_RightChannel = param1;
            this.m_UncommittedRightChannel = true;
            invalidateProperties();
         }
      }
      
      function onChatEdit(param1:uint, param2:uint, param3:uint, param4:Boolean, param5:Boolean, param6:Boolean) : Boolean
      {
         if(param4 || param5 || param6)
         {
            throw new ArgumentError("ChatWidget.onChatEdit: Invalid modifier state: " + param4 + "/" + param5 + "/" + param6);
         }
         this.m_UIInput.onKeyboardInput(param1,param2,param3,param4,param5,param6);
         if(this.m_UILeftView != null)
         {
            this.m_UILeftView.clearSelection();
         }
         if(this.m_UIRightView != null)
         {
            this.m_UIRightView.clearSelection();
         }
         return true;
      }
      
      public function get mappingMode() : int
      {
         return this.m_MappingMode;
      }
      
      public function set mappingSetID(param1:int) : void
      {
         this.m_MappingSetID = param1;
         this.m_UncommittedMappingSetID = true;
         invalidateProperties();
      }
      
      function onChatText(param1:uint, param2:String) : Boolean
      {
         this.m_UIInput.onTextInput(param1,param2);
         if(this.m_UILeftView != null)
         {
            this.m_UILeftView.clearSelection();
         }
         if(this.m_UIRightView != null)
         {
            this.m_UIRightView.clearSelection();
         }
         return true;
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      function onChatHistory(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         if(this.m_LeftChannel != null && this.m_LeftChannel.sendAllowed)
         {
            _loc2_ = this.m_History.length;
            if(_loc2_ < 1)
            {
               this.m_HistoryIndex = -1;
            }
            else
            {
               this.m_HistoryIndex = Math.min(Math.max(0,this.m_HistoryIndex + param1),_loc2_);
            }
            if(0 <= this.m_HistoryIndex && this.m_HistoryIndex < _loc2_)
            {
               this.m_UIInput.text = this.m_History.getItemAt(this.m_HistoryIndex) as String;
            }
            else
            {
               this.m_UIInput.text = "";
            }
         }
         return true;
      }
      
      protected function onChannelAddRemove(param1:CollectionEvent) : void
      {
         var i:int = 0;
         var n:int = 0;
         var c:tibia.chat.Channel = null;
         var _Communication:Communication = null;
         var AutoSwitch:Boolean = false;
         var a_Event:CollectionEvent = param1;
         if(a_Event != null)
         {
            i = 0;
            n = 0;
            c = null;
            _Communication = Tibia.s_GetCommunication();
            AutoSwitch = _Communication != null && _Communication.isGameRunning && this.m_ChatStorage != null && this.m_ChatStorage.channelActivationTimeout < getTimer();
            switch(a_Event.kind)
            {
               case CollectionEventKind.ADD:
                  i = 0;
                  n = a_Event.items.length;
                  while(i < n)
                  {
                     c = Channel(a_Event.items[i]);
                     c.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onChannelPropertyChange);
                     if(AutoSwitch)
                     {
                        this.leftChannel = c;
                     }
                     i++;
                  }
                  break;
               case CollectionEventKind.REMOVE:
                  i = 0;
                  n = a_Event.items.length;
                  while(i < n)
                  {
                     c = Channel(a_Event.items[i]);
                     c.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onChannelPropertyChange);
                     if(c == this.m_LeftChannel)
                     {
                        this.leftChannel = this.m_ChatStorage.getChannelAt(Math.min(a_Event.location + i,this.m_ChatStorage.channels.length - 1));
                     }
                     if(c == this.m_RightChannel)
                     {
                        callLater(function():void
                        {
                           if(m_ChatStorage == null || m_ChatStorage.getChannelIndex(m_RightChannel) < 0)
                           {
                              rightChannel = null;
                           }
                        });
                     }
                     i++;
                  }
                  break;
               case CollectionEventKind.RESET:
                  this.leftChannel = null;
                  this.rightChannel = null;
                  break;
               case CollectionEventKind.UPDATE:
                  i = 0;
                  n = a_Event.items.length;
                  while(i < n)
                  {
                     if(AutoSwitch && (c = a_Event.items[i] as tibia.chat.Channel) != null)
                     {
                        this.leftChannel = c;
                     }
                     i++;
                  }
            }
         }
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:InteractiveObject = param1.target as InteractiveObject;
         while(_loc2_ != null)
         {
            if(_loc2_ == this.m_UIInput)
            {
               this.m_UILeftView.clearSelection();
               this.m_UIRightView.clearSelection();
               break;
            }
            if(_loc2_ == this.m_UILeftView)
            {
               this.m_UIInput.clearSelection();
               this.m_UIRightView.clearSelection();
               break;
            }
            if(_loc2_ == this.m_UIRightView)
            {
               this.m_UIInput.clearSelection();
               this.m_UILeftView.clearSelection();
               break;
            }
            if(_loc2_ == stage)
            {
               break;
            }
            _loc2_ = _loc2_.parent as InteractiveObject;
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MappingSet = null;
         super.commitProperties();
         if(this.m_UncommittedChatStorage)
         {
            this.volume = MessageMode.MESSAGE_SAY;
            if(this.m_ChatStorage != null)
            {
               this.leftChannel = this.m_ChatStorage.getChannel(tibia.chat.ChatStorage.LOCAL_CHANNEL_ID);
               this.rightChannel = null;
               this.m_UITabBar.dataProvider = this.m_ChatStorage.channels;
            }
            else
            {
               this.leftChannel = null;
               this.rightChannel = null;
               this.m_UITabBar.dataProvider = null;
            }
            this.m_History.removeAll();
            this.m_HistoryIndex = -1;
            this.m_UncommittedChatStorage = false;
         }
         if(this.m_UncommittedOptions)
         {
            if(this.m_Options != null)
            {
               this.mappingSetID = this.m_Options.generalInputSetID;
               this.mappingMode = this.m_Options.generalInputSetMode;
            }
            else
            {
               this.mappingSetID = -1;
               this.mappingMode = MappingSet.CHAT_MODE_OFF;
            }
            this.updateViewWidths();
            this.m_UncommittedOptions = false;
         }
         if(this.m_UncommittedLeftChannel)
         {
            this.volume = MessageMode.MESSAGE_SAY;
            this.m_UIButtonVolume.enabled = this.getVolumeEnabled();
            this.m_UIButtonVolume.label = resourceManager.getString(BUNDLE,this.getVolumeLabelResource());
            _loc2_ = this.getChannelTextColor(this.m_LeftChannel);
            this.m_UIInput.setStyle("color",_loc2_ & 16777215);
            this.m_UILeftView.channel = this.m_LeftChannel;
            this.m_UITabBar.selectedIndex = this.m_ChatStorage != null?int(this.m_ChatStorage.getChannelIndex(this.m_LeftChannel)):-1;
            this.m_UncommittedLeftChannel = false;
         }
         if(this.m_UncommittedRightChannel)
         {
            if(this.m_RightChannel != null)
            {
               this.m_UILeftView.styleName = getStyle("viewBarLeftViewStyle");
               this.m_UIRightTab.label = this.m_RightChannel.name;
               this.m_UIRightTab.highlight = false;
               this.m_UIRightTab.selected = true;
               this.m_UIRightTab.visible = true;
               this.m_UIRightView.channel = this.m_RightChannel;
               if(!this.m_UIViewContainer.contains(this.m_UIRightView))
               {
                  this.m_UIViewContainer.addChild(this.m_UIRightView);
               }
            }
            else
            {
               this.m_UILeftView.styleName = getStyle("viewBarSingleViewStyle");
               this.m_UIRightTab.label = resourceManager.getString(BUNDLE,"BTN_RIGHT_TAB_EMPTY");
               this.m_UIRightTab.highlight = false;
               this.m_UIRightTab.selected = false;
               this.m_UIRightTab.visible = false;
               this.m_UIRightView.channel = null;
               if(this.m_UIViewContainer.contains(this.m_UIRightView))
               {
                  this.m_UIViewContainer.removeChild(this.m_UIRightView);
               }
            }
            this.updateViewWidths();
            this.m_UncommittedRightChannel = false;
         }
         if(this.m_UncommittedVolume)
         {
            this.m_UIButtonVolume.enabled = this.getVolumeEnabled();
            this.m_UIButtonVolume.label = resourceManager.getString(BUNDLE,this.getVolumeLabelResource());
            this.m_UncommittedVolume = false;
         }
         var _loc1_:String = null;
         if(this.m_UncommittedMappingSetID)
         {
            _loc1_ = null;
            if(this.m_Options != null)
            {
               _loc3_ = this.m_Options.getMappingSet(this.m_MappingSetID);
               if(_loc3_ != null)
               {
                  this.m_Options.generalInputSetID = this.m_MappingSetID;
                  _loc1_ = _loc3_.name;
               }
            }
            this.m_UIButtonSetCycle.label = _loc1_;
            this.m_UncommittedMappingSetID = false;
         }
         if(this.m_UncommittedMappingMode)
         {
            if(this.m_Options != null)
            {
               this.m_Options.generalInputSetMode = this.m_MappingMode;
            }
            _loc1_ = null;
            switch(this.m_MappingMode)
            {
               case MappingSet.CHAT_MODE_OFF:
                  _loc1_ = "BTN_CHAT_MODE_OFF";
                  break;
               case MappingSet.CHAT_MODE_ON:
                  _loc1_ = "BTN_CHAT_MODE_ON";
                  break;
               case MappingSet.CHAT_MODE_TEMPORARY:
                  _loc1_ = "BTN_CHAT_MODE_TEMPORARY";
            }
            this.m_UIButtonMappingMode.label = resourceManager.getString(BUNDLE,_loc1_);
            this.m_UIButtonVolume.enabled = this.getVolumeEnabled();
            this.m_UIButtonVolume.label = resourceManager.getString(BUNDLE,this.getVolumeLabelResource());
            this.m_UIInput.enabled = this.m_MappingMode != MappingSet.CHAT_MODE_OFF;
            this.m_UncommittedMappingMode = false;
         }
      }
      
      public function get mappingSetID() : int
      {
         return this.m_MappingSetID;
      }
      
      protected function onRightChannelClose(param1:Event) : void
      {
         if(param1 != null)
         {
            param1.preventDefault();
            this.rightChannel = null;
         }
      }
      
      private function getChannelTextColor(param1:tibia.chat.Channel) : uint
      {
         if(this.m_Options != null && this.m_Options.getMessageFilterSet(MessageFilterSet.DEFAULT_SET) != null)
         {
            if(param1 == null || !param1.sendAllowed)
            {
               if(this.m_ChatStorage != null)
               {
                  param1 = this.m_ChatStorage.getChannel(tibia.chat.ChatStorage.LOCAL_CHANNEL_ID);
               }
               else
               {
                  param1 = null;
               }
            }
            if(param1 != null)
            {
               return this.m_Options.getMessageFilterSet(MessageFilterSet.DEFAULT_SET).getMessageMode(param1.sendMode).textARGB;
            }
         }
         return 16777215;
      }
      
      protected function onChannelContextMenu(param1:ChannelEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.type)
            {
               case ChannelEvent.NICKLIST_CONTEXT_MENU:
               case ChannelEvent.VIEW_CONTEXT_MENU:
                  new ChannelContextMenu(this.m_ChatStorage,param1.channel,param1.message,param1.name,ChannelView(param1.currentTarget)).display(this,stage.mouseX,stage.mouseY);
                  break;
               case ChannelEvent.TAB_CONTEXT_MENU:
                  new ChannelTabContextMenu(this.m_ChatStorage,param1.channel).display(this,stage.mouseX,stage.mouseY);
            }
         }
      }
      
      protected function onChannelHighlight(param1:ChannelEvent) : void
      {
         var _loc2_:tibia.chat.Channel = null;
         if(param1 != null)
         {
            _loc2_ = param1.channel;
            if(_loc2_.ID == tibia.chat.ChatStorage.NPC_CHANNEL_ID)
            {
               this.leftChannel = _loc2_;
            }
            if(_loc2_ == this.m_LeftChannel || _loc2_ == this.m_RightChannel)
            {
               param1.preventDefault();
            }
         }
      }
      
      public function set leftChannel(param1:tibia.chat.Channel) : void
      {
         if(this.m_LeftChannel != param1)
         {
            this.m_LeftChannel = param1;
            this.m_UncommittedLeftChannel = true;
            invalidateProperties();
         }
      }
      
      protected function onInputMouseDown(param1:MouseEvent) : void
      {
         if(this.mappingMode == MappingSet.CHAT_MODE_OFF)
         {
            this.mappingMode = MappingSet.CHAT_MODE_ON;
         }
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         if(mx_internal::border is IBorder)
         {
            return IBorder(mx_internal::border).borderMetrics;
         }
         return EdgeMetrics.EMPTY;
      }
      
      function onChatSend() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.m_ChatStorage != null && this.m_LeftChannel != null)
         {
            _loc1_ = MessageMode.MESSAGE_NONE;
            if(this.m_LeftChannel.ID === tibia.chat.ChatStorage.LOCAL_CHANNEL_ID || this.m_LeftChannel.ID === tibia.chat.ChatStorage.SERVER_CHANNEL_ID || !this.m_LeftChannel.sendAllowed)
            {
               _loc1_ = this.volume;
               this.volume = MessageMode.MESSAGE_SAY;
            }
            _loc2_ = StringHelper.s_Trim(this.m_UIInput.text);
            if(_loc2_ == null || _loc2_.length < 1)
            {
               this.m_UIInput.text = "";
               return;
            }
            if(this.m_History.length == 0 || String(this.m_History.getItemAt(this.m_History.length - 1)) != _loc2_)
            {
               this.m_History.addItem(_loc2_);
            }
            this.m_HistoryIndex = this.m_History.length;
            this.m_UIInput.text = this.m_ChatStorage.sendChannelMessage(_loc2_,this.m_LeftChannel,_loc1_);
         }
         if(this.m_UILeftView != null)
         {
            this.m_UILeftView.clearSelection();
         }
         if(this.m_UIRightView != null)
         {
            this.m_UIRightView.clearSelection();
         }
      }
   }
}

package tibia.game
{
   import mx.collections.Sort;
   import mx.collections.ListCollectionView;
   import mx.collections.ICollectionView;
   import flash.events.TimerEvent;
   import mx.events.CloseEvent;
   import mx.collections.IList;
   import flash.events.MouseEvent;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.mx_internal;
   import shared.controls.CustomList;
   import mx.events.ListEvent;
   import mx.controls.List;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   
   public class CharacterSelectionWidget extends PopUpBase
   {
      
      public static const CLIENT_VERSION:uint = 2357;
      
      public static const CLIENT_PREVIEW_STATE:uint = 0;
      
      public static const PREVIEW_STATE_PREVIEW_NO_ACTIVE_CHANGE:uint = 1;
      
      private static const BUNDLE:String = "CharacterSelectionWidget";
      
      public static const PREVIEW_STATE_PREVIEW_WITH_ACTIVE_CHANGE:uint = 2;
      
      public static const CLIENT_TYPE:uint = 3;
      
      public static const TIMEOUT_EXPIRED:int = 2147483647;
      
      public static const PREVIEW_STATE_REGULAR:uint = 0;
      
      private static const CLOSE_TIMEOUT:Number = 60 * 1000;
       
      
      private var m_SelectedCharacterIndex:int = -1;
      
      private var m_CharactersView:ListCollectionView = null;
      
      private var m_UncommittedCharacters:Boolean = false;
      
      private var m_Characters:IList = null;
      
      private var m_UIList:List = null;
      
      private var m_Timeout:Timer = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncommittedSelectedCharacter:Boolean = false;
      
      public function CharacterSelectionWidget()
      {
         super();
         height = 310;
         width = 350;
         buttonFlags = PopUpBase.BUTTON_CANCEL | PopUpBase.BUTTON_OKAY;
         title = resourceManager.getString(BUNDLE,"TITLE");
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyboardDown);
         if(!Tibia.s_GetInstance().isRunning)
         {
            this.m_Timeout = new Timer(CLOSE_TIMEOUT,1);
            this.m_Timeout.addEventListener(TimerEvent.TIMER,this.onTimeout);
            this.m_Timeout.start();
         }
      }
      
      private function scrollToSelectedCharacter() : void
      {
         if(this.m_UIList != null && this.selectedCharacterIndex != -1)
         {
            this.m_UIList.validateNow();
            this.m_UIList.scrollToIndex(this.selectedCharacterIndex);
         }
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         if(this.m_Timeout != null)
         {
            this.m_Timeout.stop();
         }
         super.hide(param1);
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Sort = null;
         super.commitProperties();
         if(this.m_UncommittedCharacters)
         {
            if(this.m_Characters != null)
            {
               this.m_CharactersView = new ListCollectionView(this.m_Characters);
            }
            _loc1_ = new Sort();
            _loc1_.compareFunction = this.sortAccountCharacterByName;
            ICollectionView(this.m_CharactersView).sort = _loc1_;
            this.m_UIList.dataProvider = this.m_CharactersView;
            this.m_UncommittedCharacters = false;
         }
         if(this.m_UncommittedSelectedCharacter)
         {
            this.m_UIList.selectedIndex = this.m_SelectedCharacterIndex;
            if(this.m_Timeout != null)
            {
               this.m_Timeout.stop();
               this.m_Timeout.reset();
               this.m_Timeout.start();
            }
            callLater(this.scrollToSelectedCharacter,null);
            this.m_UncommittedSelectedCharacter = false;
         }
      }
      
      public function set selectedCharacterIndex(param1:int) : void
      {
         if(this.m_Characters != null)
         {
            param1 = Math.max(-1,Math.min(param1,this.m_Characters.length - 1));
         }
         else
         {
            param1 = -1;
         }
         if(this.m_SelectedCharacterIndex != param1)
         {
            this.m_SelectedCharacterIndex = param1;
            this.m_UncommittedSelectedCharacter = true;
            invalidateProperties();
         }
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         var _loc2_:CloseEvent = null;
         if(param1 != null)
         {
            _loc2_ = new CloseEvent(CloseEvent.CLOSE,true,false);
            _loc2_.detail = TIMEOUT_EXPIRED;
            dispatchEvent(_loc2_);
            if(!_loc2_.cancelable || !_loc2_.isDefaultPrevented())
            {
               this.hide(false);
            }
         }
      }
      
      public function set characters(param1:IList) : void
      {
         if(this.m_Characters != param1)
         {
            this.m_Characters = param1;
            this.m_UncommittedCharacters = true;
            invalidateProperties();
            this.m_SelectedCharacterIndex = -1;
         }
      }
      
      private function buildCharacterLabel(param1:Object) : String
      {
         var _loc2_:* = AccountCharacter(param1).name + " (" + AccountCharacter(param1).world;
         if(AccountCharacter(param1).worldPreviewState != PREVIEW_STATE_REGULAR)
         {
            _loc2_ = _loc2_ + ", Preview";
         }
         _loc2_ = _loc2_ + ")";
         return _loc2_;
      }
      
      private function onListDoubleClick(param1:MouseEvent) : void
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
                  this.m_UIList.removeEventListener(MouseEvent.DOUBLE_CLICK,this.onListDoubleClick);
                  this.hide(true);
               }
            }
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIList = new CustomList();
            this.m_UIList.doubleClickEnabled = true;
            this.m_UIList.labelFunction = this.buildCharacterLabel;
            this.m_UIList.percentWidth = 100;
            this.m_UIList.percentHeight = 100;
            this.m_UIList.addEventListener(ListEvent.CHANGE,this.onListChange);
            this.m_UIList.addEventListener(MouseEvent.DOUBLE_CLICK,this.onListDoubleClick);
            this.m_UIList.allowMultipleSelection = false;
            this.m_UIList.allowDragSelection = false;
            addChild(this.m_UIList);
            this.m_UIConstructed = true;
         }
      }
      
      private function sortAccountCharacterByName(param1:AccountCharacter, param2:AccountCharacter, param3:Array = null) : int
      {
         if(param1.name == param2.name)
         {
            return 0;
         }
         if(param1.name < param2.name)
         {
            return 1;
         }
         return -1;
      }
      
      private function onKeyboardDown(param1:KeyboardEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.keyCode)
            {
               case Keyboard.DOWN:
                  this.selectedCharacterIndex = this.selectedCharacterIndex + 1;
                  break;
               case Keyboard.UP:
                  this.selectedCharacterIndex = Math.max(0,this.selectedCharacterIndex - 1);
            }
         }
      }
      
      public function get characters() : IList
      {
         return this.m_Characters;
      }
      
      public function get selectedCharacterIndex() : int
      {
         return this.m_SelectedCharacterIndex;
      }
      
      private function onListChange(param1:ListEvent) : void
      {
         if(param1 != null)
         {
            this.selectedCharacterIndex = this.m_UIList.selectedIndex;
            this.m_UncommittedSelectedCharacter = true;
         }
      }
   }
}

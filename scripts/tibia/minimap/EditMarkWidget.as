package tibia.minimap
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import mx.containers.Form;
   import mx.containers.FormItem;
   import mx.controls.TextInput;
   import mx.events.PropertyChangeEvent;
   import tibia.game.PopUpBase;
   import tibia.input.PreventWhitespaceInput;
   import tibia.minimap.editMarkWidgetClasses.MarkIconChooser;
   
   public class EditMarkWidget extends PopUpBase
   {
      
      protected static const MM_SIDEBAR_ZOOM_MAX:int = 2;
      
      protected static const MM_SIDEBAR_HIGHLIGHT_DURATION:Number = 10000;
      
      protected static const MM_STORAGE_MAX_VERSION:int = 1;
      
      public static const BUNDLE:String = "EditMarkWidget";
      
      protected static const MM_SECTOR_SIZE:int = 256;
      
      protected static const MM_IE_TIMEOUT:Number = 50;
      
      protected static const MM_SIDEBAR_VIEW_HEIGHT:int = 106;
      
      protected static const MM_IO_TIMEOUT:Number = 500;
      
      protected static const MM_SIDEBAR_ZOOM_MIN:int = -1;
      
      protected static const MM_COLOUR_DEFAULT:uint = 0;
      
      protected static const MM_SIDEBAR_VIEW_WIDTH:int = 106;
      
      protected static const MM_STORAGE_MIN_VERSION:int = 1;
      
      protected static const MM_CACHE_SIZE:int = 48;
       
      
      protected var m_Description:String = null;
      
      protected var m_UIMark:MarkIconChooser = null;
      
      private var m_UncommittedPosition:Boolean = false;
      
      protected var m_PositionX:int = 0;
      
      protected var m_PositionY:int = 0;
      
      protected var m_PositionZ:int = 0;
      
      private var m_UncommittedMiniMapStorage:Boolean = false;
      
      protected var m_MiniMapStorage:MiniMapStorage;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIDescription:TextInput = null;
      
      protected var m_Mark:int = 0;
      
      public function EditMarkWidget()
      {
         super();
         title = resourceManager.getString(BUNDLE,"TITLE");
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         if(param1)
         {
            if(this.m_MiniMapStorage != null)
            {
               this.m_MiniMapStorage.setMark(this.m_PositionX,this.m_PositionY,this.m_PositionZ,this.m_Mark,this.m_Description);
            }
         }
         super.hide(param1);
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Object = null;
         super.commitProperties();
         if(this.m_UncommittedMiniMapStorage)
         {
            this.m_UncommittedPosition = true;
            this.m_UncommittedMiniMapStorage = false;
         }
         if(this.m_UncommittedPosition)
         {
            _loc1_ = null;
            if(this.m_MiniMapStorage != null)
            {
               _loc1_ = this.m_MiniMapStorage.getMark(this.m_PositionX,this.m_PositionY,this.m_PositionZ);
            }
            if(_loc1_ != null)
            {
               this.m_Mark = _loc1_.icon;
               this.m_Description = _loc1_.text;
            }
            else
            {
               this.m_Mark = 0;
               this.m_Description = "";
            }
            this.m_UIMark.selectedIcon = this.m_Mark;
            this.m_UIDescription.text = this.m_Description;
            this.m_UncommittedPosition = false;
         }
      }
      
      public function getPositionX() : int
      {
         return this.m_PositionX;
      }
      
      public function getPositionZ() : int
      {
         return this.m_PositionZ;
      }
      
      protected function onMarkChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null)
         {
            this.m_Mark = this.m_UIMark.selectedIcon;
         }
      }
      
      public function getPositionY() : int
      {
         return this.m_PositionY;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Form = null;
         var _loc2_:FormItem = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new Form();
            _loc1_.percentWidth = 100;
            _loc1_.percentHeight = 100;
            _loc1_.styleName = "editMarkWidgetRootContainer";
            _loc2_ = new FormItem();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.label = resourceManager.getString(BUNDLE,"LABEL_ICON");
            this.m_UIMark = new MarkIconChooser();
            this.m_UIMark.percentHeight = NaN;
            this.m_UIMark.percentWidth = 100;
            this.m_UIMark.selectedIcon = this.m_Mark;
            this.m_UIMark.styleName = getStyle("markSelectorStyle");
            this.m_UIMark.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onMarkChange);
            _loc2_.addChild(this.m_UIMark);
            _loc1_.addChild(_loc2_);
            _loc2_ = new FormItem();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.label = resourceManager.getString(BUNDLE,"LABEL_TEXT");
            this.m_UIDescription = new TextInput();
            this.m_UIDescription.maxChars = 100;
            this.m_UIDescription.percentHeight = NaN;
            this.m_UIDescription.percentWidth = 100;
            this.m_UIDescription.styleName = getStyle("descriptionStyle");
            this.m_UIDescription.text = this.m_Description;
            this.m_UIDescription.addEventListener(Event.CHANGE,this.onDescriptionChange);
            this.m_UIDescription.addEventListener(KeyboardEvent.KEY_DOWN,PreventWhitespaceInput);
            this.m_UIDescription.addEventListener(TextEvent.TEXT_INPUT,PreventWhitespaceInput);
            _loc2_.addChild(this.m_UIDescription);
            _loc1_.addChild(_loc2_);
            addChild(_loc1_);
            this.m_UIConstructed = true;
         }
      }
      
      public function setPosition(param1:int, param2:int, param3:int) : void
      {
         if(this.m_PositionX != param1 || this.m_PositionY != param2 || this.m_PositionZ != param3)
         {
            this.m_PositionX = param1;
            this.m_PositionY = param2;
            this.m_PositionZ = param3;
            this.m_UncommittedPosition = true;
            invalidateProperties();
         }
      }
      
      public function getMiniMapStorage() : MiniMapStorage
      {
         return this.m_MiniMapStorage;
      }
      
      protected function onDescriptionChange(param1:Event) : void
      {
         if(param1 != null)
         {
            this.m_Description = this.m_UIDescription.text;
         }
      }
      
      public function setMiniMapStorage(param1:MiniMapStorage) : void
      {
         if(this.m_MiniMapStorage != param1)
         {
            this.m_MiniMapStorage = param1;
            this.m_UncommittedMiniMapStorage = true;
            invalidateProperties();
         }
      }
   }
}

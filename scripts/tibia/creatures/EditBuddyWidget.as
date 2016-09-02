package tibia.creatures
{
   import tibia.game.PopUpBase;
   import tibia.network.Communication;
   import shared.utility.StringHelper;
   import tibia.creatures.buddylistClasses.Buddy;
   import mx.controls.CheckBox;
   import mx.collections.IList;
   import mx.controls.TextArea;
   import mx.containers.Form;
   import mx.containers.FormItem;
   import tibia.creatures.editBuddyWidgetClasses.BuddyIconChooser;
   import flash.events.KeyboardEvent;
   import tibia.input.PreventWhitespaceInput;
   import flash.events.TextEvent;
   
   public class EditBuddyWidget extends PopUpBase
   {
      
      public static const BUNDLE:String = "EditBuddyWidget";
       
      
      private var m_UncommittedBuddySet:Boolean = false;
      
      protected var m_BuddySet:tibia.creatures.BuddySet = null;
      
      protected var m_UINotify:CheckBox = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_Buddy:Buddy = null;
      
      private var m_UncommittedBuddy:Boolean = false;
      
      protected var m_UIDescription:TextArea = null;
      
      protected var m_UIIcon:BuddyIconChooser = null;
      
      public function EditBuddyWidget()
      {
         super();
         title = resourceManager.getString(BUNDLE,"TITLE");
         keyboardFlags = PopUpBase.KEY_ESCAPE;
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         var _loc2_:Communication = null;
         if(param1 && this.m_Buddy != null)
         {
            this.m_Buddy.description = StringHelper.s_Trim(this.m_UIDescription.text);
            this.m_Buddy.icon = this.m_UIIcon.selectedID;
            this.m_Buddy.notify = this.m_UINotify.selected;
            _loc2_ = Tibia.s_GetCommunication();
            if(_loc2_ != null && _loc2_.isGameRunning)
            {
               _loc2_.sendCEDITBUDDY(this.m_Buddy.ID,this.m_Buddy.description,this.m_Buddy.icon,this.m_Buddy.notify);
            }
         }
         super.hide(param1);
      }
      
      public function get buddySet() : tibia.creatures.BuddySet
      {
         return this.m_BuddySet;
      }
      
      public function get buddy() : Buddy
      {
         return this.m_Buddy;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         var _loc1_:int = 0;
         var _loc2_:int = -1;
         var _loc3_:int = -1;
         var _loc4_:IList = null;
         var _loc5_:Boolean = false;
         if(this.m_UncommittedBuddySet)
         {
            if(this.m_BuddySet != null)
            {
               this.m_UIIcon.dataProvider = this.m_BuddySet.icons;
            }
            else
            {
               this.m_UIIcon.dataProvider = null;
            }
            this.m_UncommittedBuddySet = false;
         }
         if(this.m_UncommittedBuddy)
         {
            if(this.m_Buddy != null)
            {
               this.m_UIDescription.text = this.m_Buddy.description;
               this.m_UIIcon.selectedID = this.m_Buddy.icon;
               this.m_UINotify.selected = this.m_Buddy.notify;
            }
            else
            {
               this.m_UIDescription.text = null;
               this.m_UIIcon.selectedID = -1;
               this.m_UINotify.selected = false;
            }
            this.m_UncommittedBuddy = false;
         }
      }
      
      public function set buddySet(param1:tibia.creatures.BuddySet) : void
      {
         if(this.m_BuddySet != param1)
         {
            this.m_BuddySet = param1;
            this.m_UncommittedBuddySet = true;
            invalidateProperties();
         }
      }
      
      public function set buddy(param1:Buddy) : void
      {
         if(this.m_Buddy != param1)
         {
            this.m_Buddy = param1;
            this.m_UncommittedBuddy = true;
            invalidateProperties();
         }
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
            _loc1_.styleName = "editBuddyRootContainer";
            _loc2_ = new FormItem();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.label = resourceManager.getString(BUNDLE,"LABEL_ICON");
            this.m_UIIcon = new BuddyIconChooser();
            this.m_UIIcon.percentHeight = NaN;
            this.m_UIIcon.percentWidth = 100;
            _loc2_.addChild(this.m_UIIcon);
            _loc1_.addChild(_loc2_);
            _loc2_ = new FormItem();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.label = resourceManager.getString(BUNDLE,"LABEL_DESCRIPTION");
            this.m_UIDescription = new TextArea();
            this.m_UIDescription.maxChars = 128;
            this.m_UIDescription.percentHeight = NaN;
            this.m_UIDescription.percentWidth = 100;
            this.m_UIDescription.addEventListener(KeyboardEvent.KEY_DOWN,PreventWhitespaceInput);
            this.m_UIDescription.addEventListener(TextEvent.TEXT_INPUT,PreventWhitespaceInput);
            _loc2_.addChild(this.m_UIDescription);
            _loc1_.addChild(_loc2_);
            _loc2_ = new FormItem();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.label = resourceManager.getString(BUNDLE,"LABEL_NOTIFY");
            this.m_UINotify = new CheckBox();
            this.m_UINotify.percentHeight = NaN;
            this.m_UINotify.percentWidth = 100;
            _loc2_.addChild(this.m_UINotify);
            _loc1_.addChild(_loc2_);
            addChild(_loc1_);
            this.m_UIConstructed = true;
         }
      }
   }
}

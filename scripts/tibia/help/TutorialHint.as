package tibia.help
{
   import mx.events.CloseEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import shared.utility.StringHelper;
   import tibia.chat.MessageMode;
   import tibia.input.IActionImpl;
   
   public class TutorialHint implements IActionImpl
   {
      
      private static const BUNDLE:String = "TutorialHintWidget";
      
      private static const TUTORIAL_HINTS:Array = [null,{
         "ID":1,
         "title":"HINT_01_TITLE",
         "text":"HINT_01_TEXT",
         "images":"HINT_01_IMAGES",
         "showDialog":true,
         "preDisplay":null,
         "postDisplay":null
      },{
         "ID":2,
         "title":"HINT_02_TITLE",
         "text":"HINT_02_TEXT",
         "images":"HINT_02_IMAGES",
         "showDialog":true,
         "preDisplay":null,
         "postDisplay":null
      },{
         "ID":3,
         "title":"HINT_03_TITLE",
         "text":"HINT_03_TEXT",
         "images":"HINT_03_IMAGES",
         "showDialog":true,
         "preDisplay":null,
         "postDisplay":null
      },{
         "ID":4,
         "title":"HINT_04_TITLE",
         "text":"HINT_04_TEXT",
         "images":"HINT_04_IMAGES",
         "showDialog":true,
         "preDisplay":null,
         "postDisplay":null
      },{
         "ID":5,
         "title":"HINT_05_TITLE",
         "text":"HINT_05_TEXT",
         "images":"HINT_05_IMAGES",
         "showDialog":true,
         "preDisplay":null,
         "postDisplay":null
      },{
         "ID":6,
         "title":"HINT_06_TITLE",
         "text":"HINT_06_TEXT",
         "images":"HINT_06_IMAGES",
         "showDialog":true,
         "preDisplay":null,
         "postDisplay":null
      }];
       
      
      private var m_Title:String = null;
      
      private var m_Images:Array = null;
      
      private var m_ID:int = 0;
      
      private var m_PostDisplayHook:Function = null;
      
      private var m_ShowDialog:Boolean = false;
      
      private var m_PreDisplayHook:Function = null;
      
      private var m_Text:String = null;
      
      public function TutorialHint(param1:int)
      {
         super();
         if(!TutorialHint.checkHint(param1))
         {
            this.m_ShowDialog = false;
            return;
         }
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         this.m_ID = param1;
         this.m_Title = _loc2_.getString(BUNDLE,TUTORIAL_HINTS[param1].title);
         this.m_Text = _loc2_.getString(BUNDLE,TUTORIAL_HINTS[param1].text);
         this.m_Images = _loc2_.getStringArray(BUNDLE,TUTORIAL_HINTS[param1].images);
         this.m_ShowDialog = TUTORIAL_HINTS[param1].showDialog;
         this.m_PreDisplayHook = TUTORIAL_HINTS[param1].preDisplay;
         this.m_PostDisplayHook = TUTORIAL_HINTS[param1].postDisplay;
         var _loc3_:int = 0;
         var _loc4_:int = this.m_Images != null?int(this.m_Images.length):0;
         while(_loc3_ < _loc4_)
         {
            this.m_Images[_loc3_] = _loc2_.getClass(BUNDLE,this.m_Images[_loc3_]);
            _loc3_++;
         }
      }
      
      public static function checkHint(param1:int) : Boolean
      {
         return param1 > 0 && param1 < TUTORIAL_HINTS.length && TUTORIAL_HINTS[param1] != null;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var _Widget:TutorialHintWidget = null;
         var a_Repeat:Boolean = param1;
         try
         {
            if(this.m_PreDisplayHook != null)
            {
               this.m_PreDisplayHook();
            }
         }
         catch(e:Error)
         {
         }
         if(this.m_ShowDialog)
         {
            _Widget = new TutorialHintWidget();
            _Widget.title = this.m_Title;
            _Widget.images = this.m_Images;
            _Widget.addEventListener(CloseEvent.CLOSE,this.onDialogClose);
            _Widget.show();
         }
         else
         {
            this.showMessage();
         }
      }
      
      protected function showMessage() : void
      {
         var _loc1_:String = null;
         if(this.m_Text != null)
         {
            _loc1_ = StringHelper.s_StripTags(this.m_Text);
            Tibia.s_GetWorldMapStorage().addOnscreenMessage(null,-1,null,0,MessageMode.MESSAGE_TUTORIAL_HINT,_loc1_);
            Tibia.s_GetChatStorage().addChannelMessage(-1,-1,null,0,MessageMode.MESSAGE_TUTORIAL_HINT,_loc1_);
         }
      }
      
      protected function onDialogClose(param1:CloseEvent) : void
      {
         var a_Event:CloseEvent = param1;
         var _Widget:TutorialHintWidget = null;
         if(a_Event != null && (_Widget = a_Event.currentTarget as TutorialHintWidget) != null)
         {
            _Widget.removeEventListener(CloseEvent.CLOSE,this.onDialogClose);
            this.showMessage();
            try
            {
               if(this.m_PostDisplayHook != null)
               {
                  this.m_PostDisplayHook();
               }
               return;
            }
            catch(e:Error)
            {
               return;
            }
         }
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
   }
}

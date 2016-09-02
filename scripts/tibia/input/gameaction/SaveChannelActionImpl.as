package tibia.input.gameaction
{
   import tibia.input.IActionImpl;
   import mx.formatters.DateFormatter;
   import mx.resources.IResourceManager;
   import mx.collections.IList;
   import flash.errors.IllegalOperationError;
   import flash.system.Capabilities;
   import tibia.chat.ChannelMessage;
   import mx.resources.ResourceManager;
   import shared.utility.FileReferenceWrapper;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import tibia.chat.Channel;
   import tibia.chat.MessageMode;
   import tibia.chat.ChatStorage;
   import flash.net.FileReference;
   
   public class SaveChannelActionImpl implements IActionImpl
   {
      
      private static const CHAT_BUNDLE:String = "ChatWidget";
      
      private static const GLOBAL_BUNDLE:String = "Global";
       
      
      protected var m_Channel:Channel = null;
      
      protected var m_ChatStorage:ChatStorage = null;
      
      protected var m_File:FileReference = null;
      
      public function SaveChannelActionImpl(param1:ChatStorage, param2:Channel)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("SaveChannelActionImpl.SaveChannelActionImpl: Invalid chat storage.");
         }
         if(param1 == null)
         {
            throw new ArgumentError("SaveChannelActionImpl.SaveChannelActionImpl: Invalid channel.");
         }
         this.m_ChatStorage = param1;
         this.m_Channel = param2;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var EOL:String = null;
         var Data:String = null;
         var _List:IList = null;
         var i:int = 0;
         var n:int = 0;
         var Manager:IResourceManager = null;
         var _Formatter:DateFormatter = null;
         var Name:String = null;
         var a_Repeat:Boolean = param1;
         if(this.m_File == null)
         {
            EOL = null;
            if(Capabilities.os.match(/^Mac OS/) || Capabilities.os.match(/^iPhone/))
            {
               EOL = "\r";
            }
            else if(Capabilities.os.match(/^Linux/))
            {
               EOL = "\n";
            }
            else
            {
               EOL = "\r\n";
            }
            Data = "";
            _List = this.m_Channel.messages;
            i = 0;
            n = _List.length;
            while(i < n)
            {
               Data = Data + (ChannelMessage(_List.getItemAt(i)).plainText + EOL);
               i++;
            }
            Manager = ResourceManager.getInstance();
            _Formatter = new DateFormatter();
            _Formatter.formatString = Manager.getString(GLOBAL_BUNDLE,"DATE_FORMAT_FILENAME");
            Name = this.m_Channel.name.replace(/\W/g,"_") + " - " + _Formatter.format(new Date()) + ".txt";
            try
            {
               this.m_File = new FileReferenceWrapper();
               this.m_File.save(Data,Name);
               this.m_File.addEventListener(Event.COMPLETE,this.onSaveComplete);
               this.m_File.addEventListener(IOErrorEvent.IO_ERROR,this.onSaveError);
               return;
            }
            catch(_Error:IllegalOperationError)
            {
               onSaveError(null);
               return;
            }
            catch(_Error:*)
            {
               onSaveError(null);
               return;
            }
         }
      }
      
      private function onSaveComplete(param1:Event) : void
      {
         var _loc2_:String = null;
         if(param1 != null && this.m_File != null)
         {
            _loc2_ = ResourceManager.getInstance().getString(CHAT_BUNDLE,"ACTION_SAVE_SUCCESS",[this.m_Channel.name,this.m_File.name]);
            this.m_ChatStorage.addChannelMessage(this.m_Channel,-1,null,0,MessageMode.MESSAGE_CHANNEL_MANAGEMENT,_loc2_);
            this.m_File.removeEventListener(Event.COMPLETE,this.onSaveComplete);
            this.m_File.removeEventListener(IOErrorEvent.IO_ERROR,this.onSaveError);
            this.m_File = null;
         }
      }
      
      private function onSaveError(param1:Event) : void
      {
         var _loc2_:String = ResourceManager.getInstance().getString(CHAT_BUNDLE,"ACTION_SAVE_FAILURE",[this.m_Channel.name]);
         this.m_ChatStorage.addChannelMessage(this.m_Channel,-1,null,0,MessageMode.MESSAGE_CHANNEL_MANAGEMENT,_loc2_);
         if(this.m_File != null)
         {
            this.m_File.removeEventListener(Event.COMPLETE,this.onSaveComplete);
            this.m_File.removeEventListener(IOErrorEvent.IO_ERROR,this.onSaveError);
            this.m_File = null;
         }
      }
   }
}

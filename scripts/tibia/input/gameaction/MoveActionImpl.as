package tibia.input.gameaction
{
   import mx.events.CloseEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import shared.utility.Vector3D;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.ObjectInstance;
   import tibia.chat.MessageMode;
   import tibia.game.PopUpBase;
   import tibia.input.IActionImpl;
   import tibia.input.widgetClasses.SplitStackWidget;
   import tibia.network.Communication;
   import tibia.worldmap.WorldMapStorage;
   
   public class MoveActionImpl implements IActionImpl
   {
      
      private static const BUNDLE:String = "StaticAction";
      
      public static const MOVE_ALL:int = -2;
      
      public static const MOVE_ASK:int = -1;
       
      
      protected var m_Position:int = -1;
      
      protected var m_SourceAbsolute:Vector3D = null;
      
      protected var m_ObjectAmount:int = 0;
      
      protected var m_DestAbsolute:Vector3D = null;
      
      protected var m_ObjectType:AppearanceType = null;
      
      protected var m_MoveAmount:int = -2;
      
      public function MoveActionImpl(param1:Vector3D, param2:ObjectInstance, param3:int, param4:Vector3D, param5:int)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("MoveActionImpl.MoveActionImpl: Invalid source co-ordinate.");
         }
         this.m_SourceAbsolute = param1.clone();
         if(param2 == null || param2.type == null)
         {
            throw new ArgumentError("MoveActionImpl.MoveActionImpl: Invalid object.");
         }
         this.m_ObjectType = param2.type;
         if(this.m_ObjectType.isCumulative)
         {
            this.m_ObjectAmount = param2.data;
         }
         else
         {
            this.m_ObjectAmount = 1;
         }
         this.m_Position = param3;
         if(param4 == null)
         {
            throw new ArgumentError("MoveActionImpl.MoveActionImpl: Invalid destination co-ordinate.");
         }
         this.m_DestAbsolute = param4.clone();
         if(param5 < MOVE_ALL || param5 > 100)
         {
            throw new ArgumentError("MoveActionImpl.MoveActionImpl: Invalid amount.");
         }
         this.m_MoveAmount = param5;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var _loc2_:WorldMapStorage = null;
         var _loc3_:IResourceManager = null;
         var _loc4_:SplitStackWidget = null;
         if(!this.m_SourceAbsolute.equals(this.m_DestAbsolute))
         {
            if(this.m_ObjectType.isUnmoveable)
            {
               _loc2_ = Tibia.s_GetWorldMapStorage();
               _loc3_ = ResourceManager.getInstance();
               _loc2_.addOnscreenMessage(MessageMode.MESSAGE_FAILURE,_loc3_.getString(BUNDLE,"GAME_MOVE_UNMOVEABLE"));
            }
            else if(this.m_ObjectType.isCumulative && this.m_ObjectAmount > 1 && this.m_MoveAmount == MOVE_ASK)
            {
               _loc4_ = new SplitStackWidget();
               _loc4_.objectType = this.m_ObjectType;
               _loc4_.objectAmount = this.m_ObjectAmount;
               _loc4_.selectedAmount = this.m_ObjectAmount;
               _loc4_.addEventListener(CloseEvent.CLOSE,this.onWidgetClose);
               _loc4_.show();
            }
            else
            {
               this.performInternal(this.m_MoveAmount);
            }
         }
      }
      
      private function onWidgetClose(param1:CloseEvent) : void
      {
         var _loc2_:SplitStackWidget = null;
         if(param1 != null && param1.detail == PopUpBase.BUTTON_OKAY && (_loc2_ = param1.currentTarget as SplitStackWidget) != null)
         {
            this.performInternal(_loc2_.selectedAmount);
         }
      }
      
      private function performInternal(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 == MOVE_ALL)
         {
            _loc2_ = this.m_ObjectAmount;
         }
         else if(0 < param1 && param1 <= this.m_ObjectAmount)
         {
            _loc2_ = param1;
         }
         else
         {
            _loc2_ = 1;
         }
         var _loc3_:Communication = Tibia.s_GetCommunication();
         if(_loc3_ != null && _loc3_.isGameRunning)
         {
            _loc3_.sendCMOVEOBJECT(this.m_SourceAbsolute.x,this.m_SourceAbsolute.y,this.m_SourceAbsolute.z,this.m_ObjectType.ID,this.m_Position,this.m_DestAbsolute.x,this.m_DestAbsolute.y,this.m_DestAbsolute.z,_loc2_);
         }
      }
   }
}

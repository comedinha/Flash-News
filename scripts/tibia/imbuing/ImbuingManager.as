package tibia.imbuing
{
   import flash.events.EventDispatcher;
   
   public class ImbuingManager extends EventDispatcher
   {
      
      private static var s_Instance:tibia.imbuing.ImbuingManager = null;
       
      
      private var m_ExistingImbuements:Vector.<tibia.imbuing.ExistingImbuement>;
      
      private var m_AvailableAstralSources:Vector.<tibia.imbuing.AstralSource>;
      
      private var m_AppearanceTypeID:uint = 0;
      
      private var m_AvailableImbuements:Vector.<tibia.imbuing.ImbuementData>;
      
      public function ImbuingManager()
      {
         super();
      }
      
      public static function getInstance() : tibia.imbuing.ImbuingManager
      {
         if(s_Instance == null)
         {
            s_Instance = new tibia.imbuing.ImbuingManager();
         }
         return s_Instance;
      }
      
      public function getAvailableImbuementWithID(param1:uint) : tibia.imbuing.ImbuementData
      {
         var _loc2_:tibia.imbuing.ImbuementData = null;
         for each(_loc2_ in this.m_AvailableImbuements)
         {
            if(_loc2_.imbuementID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function closeImbuingWindow() : void
      {
         if(ImbuingWidget.s_GetCurrentInstance() != null)
         {
            ImbuingWidget.s_GetCurrentInstance().hide();
         }
      }
      
      public function getAvailableAstralSource(param1:uint) : tibia.imbuing.AstralSource
      {
         var _loc2_:tibia.imbuing.AstralSource = null;
         for each(_loc2_ in this.m_AvailableAstralSources)
         {
            if(_loc2_.apperanceTypeID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getImbuementsForCategory(param1:String) : Vector.<tibia.imbuing.ImbuementData>
      {
         var _loc3_:tibia.imbuing.ImbuementData = null;
         var _loc2_:Vector.<tibia.imbuing.ImbuementData> = new Vector.<tibia.imbuing.ImbuementData>();
         for each(_loc3_ in this.m_AvailableImbuements)
         {
            if(_loc3_.category == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function get imbuementCategories() : Vector.<String>
      {
         var _loc2_:tibia.imbuing.ImbuementData = null;
         var _loc1_:Vector.<String> = new Vector.<String>();
         for each(_loc2_ in this.m_AvailableImbuements)
         {
            if(_loc1_.indexOf(_loc2_.category) == -1)
            {
               _loc1_.push(_loc2_.category);
            }
         }
         return _loc1_;
      }
      
      public function get availableImbuements() : Vector.<tibia.imbuing.ImbuementData>
      {
         return this.m_AvailableImbuements;
      }
      
      public function openImbuingWindow() : void
      {
         if(ImbuingWidget.s_GetCurrentInstance() == null)
         {
            new ImbuingWidget().show();
         }
      }
      
      public function get apperanceTypeID() : uint
      {
         return this.m_AppearanceTypeID;
      }
      
      public function showImbuingResultDialog(param1:String) : void
      {
         if(ImbuingWidget.s_GetCurrentInstance() != null)
         {
            ImbuingWidget.s_GetCurrentInstance().showImbuingResultDialog(param1);
         }
      }
      
      public function get availableAstralSources() : Vector.<tibia.imbuing.AstralSource>
      {
         return this.m_AvailableAstralSources;
      }
      
      public function get existingImbuements() : Vector.<tibia.imbuing.ExistingImbuement>
      {
         return this.m_ExistingImbuements;
      }
      
      public function refreshImbuingData(param1:uint, param2:Vector.<tibia.imbuing.ExistingImbuement>, param3:Vector.<tibia.imbuing.ImbuementData>, param4:Vector.<tibia.imbuing.AstralSource>) : void
      {
         this.m_AppearanceTypeID = param1;
         this.m_ExistingImbuements = param2;
         this.m_AvailableImbuements = param3;
         this.m_AvailableAstralSources = param4;
         var _loc5_:ImbuingEvent = new ImbuingEvent(ImbuingEvent.IMBUEMENT_DATA_CHANGED);
         dispatchEvent(_loc5_);
      }
   }
}

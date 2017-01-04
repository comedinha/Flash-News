package tibia.input.gameaction
{
   import shared.utility.Vector3D;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   import tibia.input.IActionImpl;
   import tibia.network.Communication;
   
   public class LookActionImpl implements IActionImpl
   {
       
      
      protected var m_Absolute:Vector3D = null;
      
      protected var m_Position:int = -1;
      
      protected var m_Type:AppearanceType = null;
      
      public function LookActionImpl(param1:Vector3D, param2:*, param3:int)
      {
         var _loc4_:AppearanceStorage = null;
         super();
         if(param1 == null)
         {
            throw new ArgumentError("LookActionImpl.LookActionImpl: Invalid co-ordinate.");
         }
         this.m_Absolute = param1.clone();
         if(param2 is AppearanceInstance)
         {
            this.m_Type = AppearanceInstance(param2).type;
         }
         else if(param2 is AppearanceType)
         {
            this.m_Type = AppearanceType(param2);
         }
         else if(param2 is int)
         {
            _loc4_ = Tibia.s_GetAppearanceStorage();
            this.m_Type = _loc4_ != null?_loc4_.getObjectType(int(param2)):null;
         }
         if(this.m_Type == null)
         {
            throw new ArgumentError("LookActionImpl.LookActionImpl: Invalid object: " + param2 + ".");
         }
         this.m_Position = param3;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var _loc2_:Communication = Tibia.s_GetCommunication();
         if(_loc2_ != null && _loc2_.isGameRunning)
         {
            _loc2_.sendCLOOK(this.m_Absolute.x,this.m_Absolute.y,this.m_Absolute.z,this.m_Type.ID,this.m_Position);
         }
      }
   }
}

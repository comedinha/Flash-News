package tibia.input.gameaction
{
   import tibia.input.IActionImpl;
   import tibia.network.Communication;
   import shared.utility.Vector3D;
   
   public class BrowseFieldActionImpl implements IActionImpl
   {
       
      
      private var m_Absolute:Vector3D = null;
      
      public function BrowseFieldActionImpl(param1:Vector3D)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("BrowseFieldActionImpl.BrowseFieldActionImpl: Invalid coordinate.");
         }
         this.m_Absolute = param1;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var _loc2_:Communication = Tibia.s_GetCommunication();
         if(_loc2_ != null && _loc2_.isGameRunning)
         {
            _loc2_.sendCBROWSEFIELD(this.m_Absolute.x,this.m_Absolute.y,this.m_Absolute.z);
         }
      }
   }
}

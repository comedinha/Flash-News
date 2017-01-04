package tibia.input.gameaction
{
   import shared.utility.Vector3D;
   import tibia.input.IActionImpl;
   
   public class AutowalkActionImpl implements IActionImpl
   {
       
      
      protected var m_ForceExact:Boolean = false;
      
      protected var m_Destination:Vector3D;
      
      protected var m_ForceDiagonal:Boolean = false;
      
      public function AutowalkActionImpl(param1:int, param2:int, param3:int, param4:Boolean, param5:Boolean)
      {
         this.m_Destination = new Vector3D(-1,-1,-1);
         super();
         this.m_Destination.setComponents(param1,param2,param3);
         this.m_ForceDiagonal = param4;
         this.m_ForceExact = param5;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         Tibia.s_GetPlayer().startAutowalk(this.m_Destination.x,this.m_Destination.y,this.m_Destination.z,this.m_ForceDiagonal,this.m_ForceExact);
      }
   }
}

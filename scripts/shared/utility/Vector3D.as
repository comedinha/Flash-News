package shared.utility
{
   public class Vector3D
   {
       
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var z:int = 0;
      
      public function Vector3D(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
      }
      
      public function sub(param1:Vector3D) : Vector3D
      {
         return new Vector3D(this.x - param1.x,this.y - param1.y,this.z - param1.z);
      }
      
      public function isZero() : Boolean
      {
         return this.x == 0 && this.y == 0 && this.z == 0;
      }
      
      public function mul(param1:int) : void
      {
         this.x = this.x * param1;
         this.y = this.y * param1;
         this.z = this.z * param1;
      }
      
      public function setVector(param1:Vector3D) : void
      {
         this.x = param1.x;
         this.y = param1.y;
         this.z = param1.z;
      }
      
      public function equals(param1:Object) : Boolean
      {
         var _loc2_:Vector3D = param1 as Vector3D;
         return _loc2_ != null && _loc2_.x == this.x && _loc2_.y == this.y && _loc2_.z == this.z;
      }
      
      public function add(param1:Vector3D) : Vector3D
      {
         return new Vector3D(this.x + param1.x,this.y + param1.y,this.z + param1.z);
      }
      
      public function setZero() : void
      {
         this.x = 0;
         this.y = 0;
         this.z = 0;
      }
      
      public function toString() : String
      {
         return "(" + this.x + ", " + this.y + ", " + this.z + ")";
      }
      
      public function clone() : Vector3D
      {
         return new Vector3D(this.x,this.y,this.z);
      }
      
      public function setComponents(param1:int, param2:int, param3:int) : void
      {
         this.x = param1;
         this.y = param2;
         this.z = param3;
      }
   }
}

package shared.stage3D
{
   import flash.events.EventDispatcher;
   import flash.display3D.Context3D;
   import flash.geom.Rectangle;
   import flash.geom.Matrix3D;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import shared.stage3D.events.Tibia3DEvent;
   import flash.display.Stage3D;
   import flash.display3D.Context3DRenderMode;
   
   public class Tibia3D extends EventDispatcher
   {
      
      private static var s_Instance:shared.stage3D.Tibia3D = null;
       
      
      private var m_AntiAliasing:int = 0;
      
      private var m_RenderMode:String = "auto";
      
      private var m_Camera:shared.stage3D.Camera2D;
      
      private var m_Context3D:Context3D = null;
      
      private var m_Stage3D:Stage3D = null;
      
      private var m_ViewPort:Rectangle;
      
      public function Tibia3D(param1:Stage3D, param2:Rectangle = null, param3:String = null)
      {
         this.m_ViewPort = new Rectangle(0,0);
         this.m_Camera = new shared.stage3D.Camera2D(1,1);
         super();
         if(s_Instance == null)
         {
            if(param1 == null)
            {
               throw new ArgumentError("Stage3D must not be null");
            }
            if(param2 == null)
            {
               param2 = new Rectangle(0,0,0,0);
            }
            if(param3 == null)
            {
               param3 = Context3DRenderMode.AUTO;
            }
            this.m_Stage3D = param1;
            this.m_ViewPort = param2;
            this.m_RenderMode = param3;
            this.m_Stage3D.addEventListener(Event.CONTEXT3D_CREATE,this.onContextCreated,false,1,true);
            this.m_Stage3D.addEventListener(ErrorEvent.ERROR,this.onStage3DError,false,1,true);
            this.requestContext3D();
            s_Instance = this;
         }
      }
      
      public static function get context3D() : Context3D
      {
         return !!isReady?s_Instance.context3D:null;
      }
      
      public static function get instance() : shared.stage3D.Tibia3D
      {
         return s_Instance;
      }
      
      public static function get isReady() : Boolean
      {
         return s_Instance != null && s_Instance.context3D != null && s_Instance.context3D.driverInfo != "Disposed";
      }
      
      protected function showFatalError(param1:String) : void
      {
         throw new Error(param1);
      }
      
      public function set camera(param1:shared.stage3D.Camera2D) : void
      {
         this.m_Camera = param1;
      }
      
      public function get viewPort() : Rectangle
      {
         return this.m_ViewPort.clone();
      }
      
      public function get modelViewMatrix() : Matrix3D
      {
         return this.m_Camera.getViewProjectionMatrix();
      }
      
      protected function requestContext3D() : void
      {
         try
         {
            this.m_Stage3D.requestContext3D(this.m_RenderMode);
            return;
         }
         catch(e:Error)
         {
            showFatalError("Context3D error: " + e.message);
            return;
         }
      }
      
      public function set viewPort(param1:Rectangle) : void
      {
         if(this.m_ViewPort.equals(param1) == false)
         {
            this.m_ViewPort = param1.clone();
            this.updateViewPort();
         }
      }
      
      public function get antiAliasing() : int
      {
         return this.m_AntiAliasing;
      }
      
      protected function onStage3DError(param1:ErrorEvent) : void
      {
         this.showFatalError("This application is not correctly embedded (wrong wmode value?)");
      }
      
      public function get renderMode() : String
      {
         return this.m_RenderMode;
      }
      
      protected function initializeGraphicsAPI() : void
      {
         this.updateViewPort();
      }
      
      public function get context3D() : Context3D
      {
         return this.m_Context3D;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this.m_Stage3D.visible = param1;
      }
      
      public function get camera() : shared.stage3D.Camera2D
      {
         return this.m_Camera;
      }
      
      public function dispose() : void
      {
         this.m_Stage3D.removeEventListener(Event.CONTEXT3D_CREATE,this.onContextCreated,false);
         this.m_Stage3D.removeEventListener(ErrorEvent.ERROR,this.onStage3DError,false);
         if(this.m_Stage3D.context3D != null)
         {
            this.m_Stage3D.context3D.dispose();
         }
      }
      
      public function set antiAliasing(param1:int) : void
      {
         this.m_AntiAliasing = param1;
         this.updateViewPort();
      }
      
      protected function updateViewPort() : void
      {
         if(this.m_Context3D)
         {
            this.m_Context3D.configureBackBuffer(this.m_ViewPort.width,this.m_ViewPort.height,this.m_AntiAliasing,false);
         }
         this.m_Stage3D.x = this.m_ViewPort.x;
         this.m_Stage3D.y = this.m_ViewPort.y;
      }
      
      public function set renderMode(param1:String) : void
      {
         this.m_RenderMode = param1;
         this.requestContext3D();
      }
      
      protected function onContextCreated(param1:Event) : void
      {
         this.m_Context3D = this.m_Stage3D.context3D;
         this.initializeGraphicsAPI();
         dispatchEvent(new Tibia3DEvent(Tibia3DEvent.CONTEXT3D_CREATED));
      }
      
      public function get visible() : Boolean
      {
         return this.m_Stage3D.visible;
      }
   }
}

package tibia.controls
{
   import mx.preloaders.DownloadProgressBar;
   import mx.core.Singleton;
   import tibia.cursors.CustomCursorManagerImpl;
   
   public class CustomDownloadProgressBar extends DownloadProgressBar
   {
       
      
      public function CustomDownloadProgressBar()
      {
         super();
      }
      
      override public function initialize() : void
      {
         Singleton.registerClass("mx.managers::ICursorManager",CustomCursorManagerImpl);
         super.initialize();
      }
   }
}

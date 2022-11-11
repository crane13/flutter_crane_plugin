import Foundation
import FlutterMacOS

open class CranePluginUtils{
    public static func initCrane(registry: FlutterPluginRegistry,
                                 viewController:NSViewController )
    {
        
        FlutterGGPlugin.registerWith(registry: registry)
    }
    
}

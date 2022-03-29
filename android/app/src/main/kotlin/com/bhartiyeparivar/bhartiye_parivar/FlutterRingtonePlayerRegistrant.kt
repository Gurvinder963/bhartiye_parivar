package com.bhartiyeparivar;

import io.inway.ringtone.player.FlutterRingtonePlayerPlugin;
import io.flutter.plugin.common.PluginRegistry;


class FlutterRingtonePlayerRegistrant {    
    companion object {        
        fun registerWith(registry: PluginRegistry) {            
            if (alreadyRegisteredWith(registry)) {                
                           
                return            
            }            
        FlutterRingtonePlayerPlugin.registerWith(registry.registrarFor("io.inway.ringtone.player.FlutterRingtonePlayerPlugin")) 
             
    }        
    private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {            
        val key = FlutterRingtonePlayerRegistrant::class.java.canonicalName            
            if (registry.hasPlugin(key)) {                
                return true            
            }            
        registry.registrarFor(key)            
        return false        
    }    
}}


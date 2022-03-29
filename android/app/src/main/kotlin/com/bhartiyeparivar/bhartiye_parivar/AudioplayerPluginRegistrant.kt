package com.bhartiyeparivar;

import bz.rxla.audioplayer.AudioplayerPlugin;
import io.flutter.plugin.common.PluginRegistry;


class AudioplayerPluginRegistrant {    
    companion object {        
        fun registerWith(registry: PluginRegistry) {            
            if (alreadyRegisteredWith(registry)) {                
                           
                return            
            }            
        AudioplayerPlugin.registerWith(registry.registrarFor("bz.rxla.audioplayer.AudioplayerPlugin")) 
             
    }        
    private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {            
        val key = AudioplayerPluginRegistrant::class.java.canonicalName            
            if (registry.hasPlugin(key)) {                
                return true            
            }            
        registry.registrarFor(key)            
        return false        
    }    
}}


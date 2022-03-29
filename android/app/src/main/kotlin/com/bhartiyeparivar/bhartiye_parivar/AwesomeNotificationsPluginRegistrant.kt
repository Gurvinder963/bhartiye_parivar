package com.bhartiyeparivar;

import me.carda.awesome_notifications.AwesomeNotificationsPlugin;
import io.flutter.plugin.common.PluginRegistry;


class AwesomeNotificationsPluginRegistrant {    
    companion object {        
        fun registerWith(registry: PluginRegistry) {            
            if (alreadyRegisteredWith(registry)) {                
                           
                return            
            }            
        AwesomeNotificationsPlugin.registerWith(registry.registrarFor("me.carda.awesome_notifications.AwesomeNotificationsPlugin")) 
             
    }        
    private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {            
        val key = AwesomeNotificationsPluginRegistrant::class.java.canonicalName            
            if (registry.hasPlugin(key)) {                
                return true            
            }            
        registry.registrarFor(key)            
        return false        
    }    
}}


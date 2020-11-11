package com.cognizant.aid
import android.os.Bundle
import com.microsoft.intune.mam.client.app.MAMComponents
import com.microsoft.intune.mam.client.identity.MAMPolicyManager
import com.microsoft.intune.mam.policy.MAMEnrollmentManager
import com.microsoft.intune.mam.policy.appconfig.MAMAppConfig
import com.microsoft.intune.mam.policy.appconfig.MAMAppConfigManager
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.logging.Level
import java.util.logging.Logger

//import com.microsoft.identity.client.AuthenticationCallback;

class MainActivity: FlutterActivity() {
//  private val mUserAccount: AppAccount? = null
  private var mEnrollmentManager: MAMEnrollmentManager? = null
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    GeneratedPluginRegistrant.registerWith(this)
    mEnrollmentManager = MAMComponents.get(MAMEnrollmentManager::class.java)
//

  }
}

package com.cognizant.aid

//import com.sun.xml.internal.ws.spi.db.BindingContextFactory.LOGGER

//import com.google.android.material.navigation.NavigationView;
import android.os.Bundle
import com.microsoft.identity.client.AuthenticationCallback
import com.microsoft.identity.client.IAuthenticationResult
import com.microsoft.identity.client.exception.MsalException
import com.microsoft.identity.client.exception.MsalIntuneAppProtectionPolicyRequiredException
import com.microsoft.identity.client.exception.MsalUserCancelException
import com.microsoft.intune.mam.client.app.MAMComponents
import com.microsoft.intune.mam.policy.MAMEnrollmentManager
import io.flutter.Log
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant


//import com.microsoft.aad.adal.AuthenticationContext;
//import com.microsoft.aad.adal.Logger;
//import  com.microsoft.aad.adal.Au

//import com.microsoft.identity.client.AuthenticationCallback;

public class MainActivity: FlutterActivity() {
    var mUserAccount: AppAccount? = null
   var mEnrollmentManager: MAMEnrollmentManager? = null
  val MSAL_SCOPES = arrayOf("https://graph.microsoft.com/User.Read")


  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    GeneratedPluginRegistrant.registerWith(this)
//    mEnrollmentManager = MAMComponents.get(MAMEnrollmentManager::class.java)
//      val configManager = MAMComponents.get(MAMAppConfigManager::class.java)
//      val appConfig: MAMAppConfig = configManager?.getAppConfig(null) !! //: MAMAppConfig()
//    mUserAccount = AppSettings.getAccount(getApplicationContext());
//
//      mEnrollmentManager?.registerAccountForMAM("", "", "", "")
//      MAMEnrollmentManager.
//    if (mUserAccount == null) {
//        onCreate();
//    } else {
//    }
//      val appPolicy = MAMPolicyManager.getPolicy()
//      val policy = appPolicy.toString()

//      MSALUtil.acquireToken(this@MainActivity, MSAL_SCOPES, loginHint, AuthCallback())

//      val mgr: MAMEnrollmentManager? = MAMComponents.get((MAMEnrollmentManager::class.java))
//      mgr?.registerAuthenticationCallback(AuthenticationCallback(applicationContext));
//      onCreate() -- Need to enable this line for intune
  }

  fun onCreate(){
    val thread = Thread {
//      BindingContextFactory.LOGGER.info("Starting interactive auth")
      try {
        var loginHint: String? = null
        if (mUserAccount != null) {
          loginHint = mUserAccount!!.uPN
        }
        MSALUtil.acquireToken(this@MainActivity, MSAL_SCOPES, loginHint, AuthCallback())
      } catch (e: MsalException) {
//          android.util.Log.d(TAG, "onCreate: ")
          Log.d("Authentication error:", e.localizedMessage)
//        showMessage("Authentication exception occurred - check logcat for more details.")
      } catch (e: InterruptedException) {
//        BindingContextFactory.LOGGER.log(Level.SEVERE, getString(R.string.err_auth), e)
//        showMessage("Authentication exception occurred - check logcat for more details.")
      }
    }
    thread.start()
  }
}

class AuthCallback : AuthenticationCallback {
    var mEnrollmentManager: MAMEnrollmentManager? = null
    override fun onError(exc: MsalException) {
//        BindingContextFactory.LOGGER.log(Level.SEVERE, "authentication failed", exc)
        if (exc is MsalIntuneAppProtectionPolicyRequiredException) {
            val appException = exc

            // Note: An app that has enabled APP CA with Policy Assurance would need to pass these values to `remediateCompliance`.
            // For more information, see https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-android#app-ca-with-policy-assurance
            val upn = appException.accountUpn
            val aadid = appException.accountUserId
            val tenantId = appException.tenantId
            val authorityURL = appException.authorityUrl

            // The user cannot be considered "signed in" at this point, so don't save it to the settings.
//            mUserAccount = AppAccount(upn, aadid, tenantId, authorityURL)
//            val message = "Intune App Protection Policy required."
//            showMessage(message)
//            BindingContextFactory.LOGGER.info("MsalIntuneAppProtectionPolicyRequiredException received.")
//            BindingContextFactory.LOGGER.info(String.format("Data from broker: UPN: %s; AAD ID: %s; Tenant ID: %s; Authority: %s",
//                    upn, aadid, tenantId, authorityURL))
            showMessage("Intune App Protection Policy required.")
        } else if (exc is MsalUserCancelException) {
            showMessage("User cancelled sign-in request")
        } else {
            showMessage("Exception occurred - check logcat")
        }
    }

    override fun onSuccess(result: IAuthenticationResult) {
        val account = result.account
        val upn = account.username
        val aadId = account.id
        val tenantId = account.tenantId
        val authorityURL = account.authority
        val message = "Authentication succeeded for user $upn"
//        BindingContextFactory.LOGGER.info(message)

        // Save the user account in the settings, since the user is now "signed in".
//        mUserAccount = AppAccount(upn, aadId, tenantId, authorityURL)
//        saveAccount(getApplicationContext(), mUserAccount)

        // Register the account for MAM.
//        mEnrollmentManager?.registerAccountForMAM(upn, aadId, tenantId, authorityURL)
//        mEnrollmentManager?.getRegisteredAccountStatus(upn);

        val mgr: MAMEnrollmentManager? = MAMComponents.get((MAMEnrollmentManager::class.java))
        mgr?.registerAccountForMAM(upn, aadId, tenantId, authorityURL)
//        mgr?.updateToken(upn, aadId, tenantId, authorityURL)
//        mgr?.unregisterAccountForMAM(upn)
    }

    override fun onCancel() {
        showMessage("User cancelled auth attempt")
    }
    private fun showMessage(message: String) {
        //runOnUiThread(Runnable { Toast.makeText(this, message, Toast.LENGTH_SHORT).show() })
    }
}


package com.cognizant.aid

import android.content.Context
import com.cognizant.aid.MSALUtil.acquireTokenSilentSync
import com.microsoft.identity.client.exception.MsalException
import com.microsoft.intune.mam.policy.MAMServiceAuthenticationCallback
import java.util.logging.Level
import java.util.logging.Logger


/**
 * Implementation of the required callback for MAM integration.
 */
open class AuthenticationCallback(context: Context) : MAMServiceAuthenticationCallback {
    private val mContext: Context
    override fun acquireToken(upn: String, aadId: String, resourceId: String): String? {
        try {
            // Create the MSAL scopes by using the default scope of the passed in resource id.
            val scopes = arrayOf<String?>("$resourceId/.default")
            val result = acquireTokenSilentSync(mContext, aadId, scopes)
            if (result != null) return result.accessToken
        } catch (e: MsalException) {
            LOGGER.log(Level.SEVERE, "Failed to get token for MAM Service", e)
            return null
        } catch (e: InterruptedException) {
            LOGGER.log(Level.SEVERE, "Failed to get token for MAM Service", e)
            return null
        }
        LOGGER.warning("Failed to get token for MAM Service - no result from MSAL")
        return null
    }

    companion object {
        private val LOGGER = Logger.getLogger(AuthenticationCallback::class.java.name)
    }

    init {
        mContext = context.applicationContext
    }
}

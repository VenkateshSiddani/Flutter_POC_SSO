package com.cognizant.aid

import android.content.Context
import android.content.SharedPreferences

/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License.
 */



/**
 * Manage settings and account storage.
 */
object AppSettings {
    private const val SETTINGS_PATH = "com.cognizant.aid.appsettings"

    /**
     * Save the given account in settings.  Currently, only a single account is supported,
     * so saving an account will overwrite an existing account.
     *
     * @param appContext
     * application Context.
     * @param account
     * the account to save.
     */
    fun saveAccount(appContext: Context, account: AppAccount) {
        val prefs = getPrefs(appContext)
        account.saveToSettings(prefs)
    }

    /**
     * Reconstitute and return the saved account from settings.
     *
     * @param appContext
     * application Context.
     *
     * @return the account, if one is saved, otherwise null.
     */
    fun getAccount(appContext: Context): AppAccount {
        val prefs = getPrefs(appContext)
        return AppAccount?.readFromSettings(prefs)!!
    }

    /**
     * Delete the saved account from the settings.
     *
     * @param appContext
     * application Context.
     */
    fun clearAccount(appContext: Context) {
        val prefs = getPrefs(appContext)
        AppAccount.clearFromSettings(prefs)
    }

    private fun getPrefs(appContext: Context): SharedPreferences {
        return appContext.getSharedPreferences(SETTINGS_PATH, Context.MODE_PRIVATE)
    }
}

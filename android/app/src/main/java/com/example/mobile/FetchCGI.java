package com.example.mobile;

import android.content.Context;
import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;
import android.telephony.CellInfo;
import android.telephony.CellInfoGsm;
import android.telephony.CellInfoLte;
import android.telephony.TelephonyManager;
import android.telephony.gsm.GsmCellLocation;

import android.util.Log;

import androidx.core.app.ActivityCompat;

import java.util.List;

public class  FetchCGI {
    private static final String TAG = "CellInfoFetcher";

    public static String getCellGlobalIdentifier(Context context) {
        // Check permissions
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            Log.e(TAG, "Permissions are not granted.");
            return "Permissions not granted.";
        }

        TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);

        if (telephonyManager == null) {
            Log.e(TAG, "TelephonyManager is not available.");
            return "TelephonyManager not available.";
        }

        // Fetch the cell location
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            List<CellInfo> cellInfoList = telephonyManager.getAllCellInfo();
            if (cellInfoList != null) {
                for (CellInfo cellInfo : cellInfoList) {
                    if (cellInfo instanceof CellInfoLte) {
                        // LTE Cell Information
                        CellInfoLte cellInfoLte = (CellInfoLte) cellInfo;
                        int mcc = Integer.parseInt(telephonyManager.getNetworkOperator().substring(0, 3));
                        int mnc = Integer.parseInt(telephonyManager.getNetworkOperator().substring(3));
                        int ci = cellInfoLte.getCellIdentity().getCi();
                        int tac = cellInfoLte.getCellIdentity().getTac();
                        return "MCC: " + mcc + ", MNC: " + mnc + ", CI: " + ci + ", LAC/TAC: " + tac;
                    } else if (cellInfo instanceof CellInfoGsm) {
                        // GSM Cell Information
                        CellInfoGsm cellInfoGsm = (CellInfoGsm) cellInfo;
                        int mcc = Integer.parseInt(telephonyManager.getNetworkOperator().substring(0, 3));
                        int mnc = Integer.parseInt(telephonyManager.getNetworkOperator().substring(3));
                        int cid = cellInfoGsm.getCellIdentity().getCid();
                        int lac = cellInfoGsm.getCellIdentity().getLac();
                        return "MCC: " + mcc + ", MNC: " + mnc + ", CI: " + cid + ", LAC: " + lac;
                    }
                }
            }
        } else {
            // Fallback for older versions (API < 29)
            GsmCellLocation cellLocation = (GsmCellLocation) telephonyManager.getCellLocation();
            if (cellLocation != null) {
                int mcc = Integer.parseInt(telephonyManager.getNetworkOperator().substring(0, 3));
                int mnc = Integer.parseInt(telephonyManager.getNetworkOperator().substring(3));
                int cid = cellLocation.getCid();
                int lac = cellLocation.getLac();
                return "MCC: " + mcc + ", MNC: " + mnc + ", CI: " + cid + ", LAC: " + lac;
            }
        }

        return "Cell information not available.";
    }
}
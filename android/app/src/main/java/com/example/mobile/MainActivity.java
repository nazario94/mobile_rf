package com.example.mobile;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.telephony.CellInfo;
import android.telephony.CellInfoGsm;
import android.telephony.CellInfoLte;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.TextView;
import androidx.core.app.ActivityCompat;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {

    private TextView textView;

    private static final String CHANNEL = "com.example.mobile/network";

    //create a class that persists to db

    private Handler handler = new Handler();
    private static final int UPDATE_INTERVAL = 5000;
    private static final int PERMISSION_REQUEST_CODE = 1;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("fetchNetworkData")) {

                        String networkData = fetchNetworkData();
                        System.out.println("Received data: $networkData" + networkData);

                        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, PERMISSION_REQUEST_CODE);
                            result.error("PERMISSION_DENIED", "Location permission is required", null);
                        } else {
                            result.success(fetchNetworkData());
                        }
                    }
                });
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                startDataCollection();
            } else {
                textView.setText("Permission denied. Cannot fetch network data.");
            }
        }
    }

    private void startDataCollection() {
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                fetchNetworkData();
                handler.postDelayed(this, UPDATE_INTERVAL);
            }
        }, 0);
    }

    private String fetchNetworkData() {
        try {
            TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
            if (telephonyManager == null) {
                return "Error: TelephonyManager unavailable";
            }

            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {

                return "Permission not granted";
            }

            List<CellInfo> cellInfoList = telephonyManager.getAllCellInfo();
            JSONArray cellInfoJsonArray = new JSONArray();

            if (cellInfoList != null && !cellInfoList.isEmpty()) {
                for (CellInfo cellInfo : cellInfoList) {
                    JSONObject cellInfoJson = new JSONObject();
                    cellInfoJson.put("Type", getNetworkType(cellInfo));
                    cellInfoJson.put("CID", getCid(cellInfo));
                    cellInfoJson.put("LAC", getLac(cellInfo));
                    cellInfoJson.put("MCC", getMcc(telephonyManager));
                    cellInfoJson.put("MNC", getMnc(telephonyManager));
                    cellInfoJson.put("RSSI", getRssi(cellInfo));
                    cellInfoJsonArray.put(cellInfoJson);
                }
                System.out.println("Received data: $cellInfoJsonArray" + cellInfoJsonArray);
                return cellInfoJsonArray.toString();
            } else {
                return "No cell info available";
            }
        } catch (Exception e) {
            Log.e("MainActivity", "Error fetching network data", e);
            return "Error fetching network data: " + e.getMessage();
        }
    }

    private String getNetworkType(CellInfo cellInfo) {
        if (cellInfo instanceof CellInfoGsm) {
            return "GSM";
        } else if (cellInfo instanceof CellInfoLte) {
            return "LTE";
        }
        return "Unknown";
    }

    private int getCid(CellInfo cellInfo) {
        if (cellInfo instanceof CellInfoGsm) {
            return ((CellInfoGsm) cellInfo).getCellIdentity().getCid();
        } else if (cellInfo instanceof CellInfoLte) {
            return ((CellInfoLte) cellInfo).getCellIdentity().getCi();
        }
        return -1;
    }

    private int getLac(CellInfo cellInfo) {
        if (cellInfo instanceof CellInfoGsm) {
            return ((CellInfoGsm) cellInfo).getCellIdentity().getLac();
        } else if (cellInfo instanceof CellInfoLte) {
            return ((CellInfoLte) cellInfo).getCellIdentity().getTac();
        }
        return -1;
    }

    private int getMcc(TelephonyManager telephonyManager) {
        String networkOperator = telephonyManager.getNetworkOperator();
        if (networkOperator != null && networkOperator.length() >= 3) {
            return Integer.parseInt(networkOperator.substring(0, 3));
        }
        return -1;
    }

    private int getMnc(TelephonyManager telephonyManager) {
        String networkOperator = telephonyManager.getNetworkOperator();
        if (networkOperator != null && networkOperator.length() >= 5) {
            return Integer.parseInt(networkOperator.substring(3));
        }
        return -1;
    }

    private int getRssi(CellInfo cellInfo) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            return cellInfo.getCellSignalStrength().getDbm();
        }
        return 0;
    }
}

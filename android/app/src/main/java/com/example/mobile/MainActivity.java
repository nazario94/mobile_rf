package com.example.mobile;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.telephony.CellInfo;
import android.telephony.CellInfoGsm;
import android.telephony.CellInfoLte;
import android.telephony.TelephonyManager;
import android.telephony.gsm.GsmCellLocation;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.transform.Result;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "cell_info";
    private static final int PERMISSION_REQUEST_CODE = 1001;
    private MethodChannel.Result pendingResult;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if ("getCellInfo".equals(call.method)) {
                        if (ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                            ActivityCompat.requestPermissions(
                                    this,
                                    new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION},
                                    PERMISSION_REQUEST_CODE
                            );
                            pendingResult = result;
                            return;
                        }
                        getCellInfo(result);
                    } else {
                        result.notImplemented();
                    }
                });
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                if (pendingResult != null) {
                    getCellInfo(pendingResult);
                    pendingResult = null;
                }
            } else {
                if (pendingResult != null) {
                    pendingResult.error("PERMISSION_DENIED", "Location permission is required", null);
                    pendingResult = null;
                }
            }
        }
    }

    public void getCellInfo(MethodChannel.Result result) {
        try {
            TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
            if (telephonyManager != null) {
                if (ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                    return;
                }
                List<CellInfo> cellInfoList = telephonyManager.getAllCellInfo();
                JSONArray cellInfoJsonArray = new JSONArray();

                if (cellInfoList != null && !cellInfoList.isEmpty()) {
                    for (CellInfo cellInfo : cellInfoList) {
                        JSONObject cellInfoJson = new JSONObject();
                        cellInfoJson.put("type", getNetworkType(cellInfo));
                        cellInfoJson.put("cgi", getCgi(cellInfo));
                        cellInfoJson.put("psc", getPsc(cellInfo));
                        cellInfoJson.put("cid", getCid(cellInfo));
                        cellInfoJson.put("lac", getLac(cellInfo));
                        cellInfoJson.put("networkIso", getNetworkIso(telephonyManager));
                        cellInfoJson.put("mcc", getMcc(telephonyManager));
                        cellInfoJson.put("mnc", getMnc(telephonyManager));
                        cellInfoJson.put("bandGSMName", getBandGSMName(cellInfo));
                        cellInfoJson.put("downlinkUarfcn", getDownlinkUarfcn(cellInfo));
                        cellInfoJson.put("cellNumber", getCellNumber(telephonyManager));
                        cellInfoJson.put("bitErrorRate", getBitErrorRate(cellInfo));
                        cellInfoJson.put("rssi", getRssi(cellInfo));
                        cellInfoJson.put("ecNo", getEcNo(cellInfo));
                        cellInfoJsonArray.put(cellInfoJson);
                    }
                } else {
                    // Add dummy data if no cell info is available
                    JSONObject dummyCellInfo = new JSONObject();
                    dummyCellInfo.put("type", "DummyType");
                    dummyCellInfo.put("cgi", "DummyCGI");
                    dummyCellInfo.put("psc", 0);
                    dummyCellInfo.put("cid", 0);
                    dummyCellInfo.put("lac", 0);
                    dummyCellInfo.put("networkIso", "DummyISO");
                    dummyCellInfo.put("mcc", 0);
                    dummyCellInfo.put("mnc", 0);
                    dummyCellInfo.put("bandGSMName", "DummyBand");
                    dummyCellInfo.put("downlinkUarfcn", "DummyUARFCN");
                    dummyCellInfo.put("cellNumber", "DummyCellNumber");
                    dummyCellInfo.put("bitErrorRate", -1);
                    dummyCellInfo.put("rssi", -1);
                    dummyCellInfo.put("ecNo", -1);
                    cellInfoJsonArray.put(dummyCellInfo);
                }

                result.success(cellInfoJsonArray.toString());
            } else {
                result.error("UNAVAILABLE", "TelephonyManager is null", null);
            }
        } catch (Exception e) {
            result.error("ERROR", "Failed to retrieve cell info", e);
        }
    }

    private String getNetworkType(CellInfo cellInfo) {
        //Todo:implement logic to check network type using switch
        if (cellInfo instanceof CellInfoGsm) {
            return "GSM";
        } else if (cellInfo instanceof CellInfoLte) {
            return "LTE";
        }
        return "Unknown";
    }

    private String getCgi(CellInfo cellInfo) {
        return  FetchCGI.getCellGlobalIdentifier(this);
    }

    private int getPsc(CellInfo cellInfo) {
        if (cellInfo instanceof CellInfoGsm) {
            return ((CellInfoGsm) cellInfo).getCellIdentity().getPsc();
        }
        return -1;
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

//    private int getRnc(CellInfo cellInfo) {
//        if (cellInfo instanceof CellInfoLte) {
//            return ((CellInfoLte) cellInfo).getCellIdentity().getEutranRncId();
//        }
//        return -1;
//    }

    private String getNetworkIso(TelephonyManager telephonyManager) {
        return telephonyManager.getNetworkCountryIso();
    }

    private int getMcc(TelephonyManager telephonyManager) {
        return Integer.parseInt(telephonyManager.getNetworkOperator().substring(0, 3)); // Implement logic if available
    }

    private int getMnc(TelephonyManager telephonyManager) {
        return Integer.parseInt(telephonyManager.getNetworkOperator().substring(3));
    }

    private String getBandGSMName(CellInfo cellInfo) {
        return "GSM Band"; // Implement logic if available
    }

    private String getDownlinkUarfcn(CellInfo cellInfo) {
        return "UARFCN"; // Implement logic if available
    }

    private String getCellNumber(TelephonyManager telephonyManager) {
        Context context = getApplicationContext();
        if (ActivityCompat.checkSelfPermission(context, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            return "Permissions not granted.";
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
        if (ActivityCompat.checkSelfPermission(context, android.Manifest.permission.READ_PHONE_NUMBERS) != PackageManager.PERMISSION_GRANTED) {
            return "READ_PHONE_NUMBERS permission not granted.";
        }
        }
        GsmCellLocation cellLocation = (GsmCellLocation) telephonyManager.getCellLocation();
        if (cellLocation != null) {
            int cid = cellLocation.getCid();
            int lac = cellLocation.getLac();
            return "CID: " + cid + ", LAC: " + lac;
        } else {
            return "Cell location is not available.";
        }
    }

    private int getBitErrorRate(CellInfo cellInfo) {
        return 0; // Implement logic if available
    }

    private int getRssi(CellInfo cellInfo) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            return cellInfo.getCellSignalStrength().getDbm();
        }
        return -1;
    }

    private int getEcNo(CellInfo cellInfo) {
        return 0; // Implement logic if available
    }
}
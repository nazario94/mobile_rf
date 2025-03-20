package com.example.mobile;

import android.content.Context;
import android.os.Environment;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
public class FileHelper {
    public static void saveToFile(Context context, String data) {
        try {
            // Define directory and file
            File dir = new File(Environment.getExternalStorageDirectory(), "NetworkLogs");
            if (!dir.exists()) {
                dir.mkdirs();
            }

            File file = new File(dir, "network_data.txt");
            FileWriter writer = new FileWriter(file, true);
            writer.append(data).append("\n");
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

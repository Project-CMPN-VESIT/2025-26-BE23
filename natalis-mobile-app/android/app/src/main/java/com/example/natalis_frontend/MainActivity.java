package com.example.natalis_frontend;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;

import androidx.annotation.NonNull;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Arrays;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import org.pytorch.IValue;
import org.pytorch.Module;
import org.pytorch.Tensor;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "natalis.ai/segmentation";
    private Module module;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        try {
            String path = assetFilePath("model_mobile.pt");
            android.util.Log.e("MODEL_DEBUG", "Model path: " + path);

            // ✅ USE FULL PYTORCH LOADER
            module = Module.load(path);

            if (module != null) {
                android.util.Log.e("MODEL_DEBUG", "MODULE LOADED OK");
            } else {
                android.util.Log.e("MODEL_DEBUG", "MODULE IS NULL");
            }

        } catch (Exception e) {
            android.util.Log.e("MODEL_DEBUG", "LOAD FAILED", e);
        }

        new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                CHANNEL
        ).setMethodCallHandler(
                (call, result) -> {

                    if (call.method.equals("runModel")) {

                        if (module == null) {
                            result.error("MODEL_NOT_LOADED", "Model is null", null);
                            return;
                        }

                        byte[] imageBytes = call.arguments();
                        float[] output = runInference(imageBytes);
                        result.success(output);

                    } else {
                        result.notImplemented();
                    }
                }
        );
    }

    private float[] runInference(byte[] imageBytes) {

        Bitmap bitmap = BitmapFactory.decodeByteArray(
                imageBytes, 0, imageBytes.length
        );

        Bitmap resized = Bitmap.createScaledBitmap(bitmap, 512, 512, true);

        float[] inputArray = new float[1 * 1 * 512 * 512];

        int index = 0;
        for (int y = 0; y < 512; y++) {
            for (int x = 0; x < 512; x++) {

                int pixel = resized.getPixel(x, y);
                float gray = Color.red(pixel) / 255.0f;

                inputArray[index++] = (gray - 0.5f) / 0.5f;
            }
        }

        Tensor inputTensor = Tensor.fromBlob(
                inputArray,
                new long[]{1, 1, 512, 512}
        );

        Tensor outputTensor = module.forward(
                IValue.from(inputTensor)
        ).toTensor();

        long[] shape = outputTensor.shape();
        android.util.Log.e("MODEL_DEBUG", "Output shape: " + Arrays.toString(shape));

        return outputTensor.getDataAsFloatArray();
    }

    private String assetFilePath(String assetName) throws Exception {
        File file = new File(getFilesDir(), assetName);

        if (file.exists() && file.length() > 0) {
            return file.getAbsolutePath();
        }

        InputStream is = getAssets().open(assetName);
        FileOutputStream os = new FileOutputStream(file);

        byte[] buffer = new byte[4 * 1024];
        int read;

        while ((read = is.read(buffer)) != -1) {
            os.write(buffer, 0, read);
        }

        os.flush();
        os.close();
        is.close();

        return file.getAbsolutePath();
    }
}
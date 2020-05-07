package com.example.quiz_test;

import androidx.annotation.NonNull;

import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "quiztest/fileconvert";
  private static String filePath;
  private static String externalPath;
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                    ((call, result) -> {
                      if (call.method.equals("convertWordToTxt")){
                        Map<String, Object> args = call.arguments();
                        filePath = (String)args.get("filePath");
                        externalPath = (String) args.get("externalPath");

                        try {
                          File file = new File(filePath);

                          if (filePath.endsWith(".doc")) {
                            FileInputStream fis = new FileInputStream(file);
                            HWPFDocument doc = new HWPFDocument(fis);
                            WordExtractor we = new WordExtractor(doc);
                            File newTxtFile = new File(externalPath, file.getName().replace(".doc", ".txt"));
                            FileOutputStream fos = new FileOutputStream(newTxtFile);
                            for (String s : we.getParagraphText()) {
                              fos.write(s.getBytes());
                            }
                            fos.close();
                          }
                          else if (filePath.endsWith(".docx")) {
                            FileInputStream fis = new FileInputStream(file);
                            XWPFDocument docx = new XWPFDocument(fis);
                            List<XWPFParagraph> listPar = docx.getParagraphs();
                            File newTxtFile = new File(externalPath, file.getName().replace(".docx", ".txt"));
                            FileOutputStream fos = new FileOutputStream(newTxtFile);
                            for (XWPFParagraph p: listPar) {
                              fos.write(p.getText().getBytes());
                            }
                            fos.close();
                          }
                        } catch (Exception e) {
                          result.error("Exception", e.getMessage(), null);
                        }
                        result.success(0);
                      }
                    })
            );
  }
}

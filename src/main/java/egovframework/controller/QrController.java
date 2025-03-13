package egovframework.controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;

@Controller
public class QrController {
	
	@RequestMapping(value = "/qr.do", method = RequestMethod.GET)
    @ResponseBody
    public void generateQRCode(@RequestParam("url") String url, HttpServletResponse response) {
        try {
            int width = 200;
            int height = 200;
            Map<EncodeHintType, Object> hints = new HashMap<>();
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");

            BitMatrix matrix = new MultiFormatWriter()
                    .encode(url, BarcodeFormat.QR_CODE, width, height, hints);

            response.setContentType("image/png");
            OutputStream outputStream = response.getOutputStream();
            MatrixToImageWriter.writeToStream(matrix, "PNG", outputStream);
            outputStream.flush();
            outputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
//    public ResponseEntity<byte[]> createQr(@RequestParam(value = "url") String url) throws WriterException, IOException {
//		System.out.println("큐알코드 생성");
////		String decodedUrl = URLDecoder.decode(url, "UTF-8"); 
//        int width = 200;
//        int height = 200;
//        BitMatrix matrix = new MultiFormatWriter().encode(url, BarcodeFormat.QR_CODE, width, height);
// 
//        try (ByteArrayOutputStream out = new ByteArrayOutputStream();) {
//            MatrixToImageWriter.writeToStream(matrix, "PNG", out);
//            return ResponseEntity.ok()
//                    .contentType(MediaType.IMAGE_PNG)
//                    .body(out.toByteArray());
//        }catch(Exception e) {
//        	e.printStackTrace();
//        }
//        return null;
//    }
}

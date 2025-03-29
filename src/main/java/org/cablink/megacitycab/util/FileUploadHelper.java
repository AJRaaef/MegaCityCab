package org.cablink.megacitycab.util;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;

public class FileUploadHelper {
    public static String saveFile(Part filePart, String uploadPath) throws IOException {
        String fileName = filePart.getSubmittedFileName();
        if (fileName != null && !fileName.isEmpty()) {
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath); // Save the file to the server
            return "uploads/" + fileName; // Return the relative path
        }
        return null;
    }
}

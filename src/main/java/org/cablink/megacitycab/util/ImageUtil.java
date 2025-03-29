package org.cablink.megacitycab.util;



public class ImageUtil {
    public static String getImageURL(String imageName) {
        if (imageName == null || imageName.isEmpty()) {
            return "default.jpg"; // Use a default image if no image is found
        }
        return imageName; // Adjust based on your actual path
    }
}

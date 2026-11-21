package vn.iotstar.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.Properties;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

public class CloudinaryUtil {
    private static final Cloudinary cloudinary = create();

    private static Cloudinary create() {
        Properties p = new Properties();
        try (InputStream in = CloudinaryUtil.class.getClassLoader().getResourceAsStream("cloudinary.properties")) {
            if (in != null) {
                p.load(in);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return new Cloudinary(ObjectUtils.asMap(
                "cloud_name", p.getProperty("cloud_name"),
                "api_key", p.getProperty("api_key"),
                "api_secret", p.getProperty("api_secret"),
                "secure", true));
    }

    /** Upload ảnh, trả về URL https của ảnh trên Cloudinary. */
    public static String upload(byte[] data, String folder) throws IOException {
        Map<?, ?> result = cloudinary.uploader().upload(data,
                ObjectUtils.asMap("folder", folder, "resource_type", "image"));
        return (String) result.get("secure_url");
    }
}
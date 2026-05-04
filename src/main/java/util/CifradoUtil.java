package util;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.SecureRandom;
import java.util.Arrays;

public class CifradoUtil {

    private static final String ALGORITMO = "AES/CBC/PKCS5Padding";
    // Clave AES de 16 bytes (128 bits)
    private static final byte[] CLAVE = "ISDCMSecretKey16".getBytes();

    public static byte[] cifrar(byte[] datos) throws Exception {
        SecretKey clave = new SecretKeySpec(CLAVE, "AES");

        // IV aleatorio de 16 bytes para cada cifrado
        byte[] iv = new byte[16];
        new SecureRandom().nextBytes(iv);

        Cipher cipher = Cipher.getInstance(ALGORITMO);
        cipher.init(Cipher.ENCRYPT_MODE, clave, new IvParameterSpec(iv));
        byte[] datosCifrados = cipher.doFinal(datos);

        // Concatenar IV + datos cifrados
        byte[] resultado = new byte[iv.length + datosCifrados.length];
        System.arraycopy(iv, 0, resultado, 0, iv.length);
        System.arraycopy(datosCifrados, 0, resultado, iv.length, datosCifrados.length);
        return resultado;
    }

    public static byte[] descifrar(byte[] datos) throws Exception {
        // Los primeros 16 bytes son el IV
        byte[] iv = Arrays.copyOfRange(datos, 0, 16);
        byte[] datosCifrados = Arrays.copyOfRange(datos, 16, datos.length);

        SecretKey clave = new SecretKeySpec(CLAVE, "AES");
        Cipher cipher = Cipher.getInstance(ALGORITMO);
        cipher.init(Cipher.DECRYPT_MODE, clave, new IvParameterSpec(iv));
        return cipher.doFinal(datosCifrados);
    }
}

package util;

import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.CipherOutputStream;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.SecureRandom;

public class CifradoUtil {

    private static final String ALGORITMO = "AES/CBC/PKCS5Padding";
    private static final byte[] CLAVE = "ISDCMSecretKey16".getBytes();
    private static final int BUFFER = 8192;

    public static void cifrarStream(InputStream entrada, OutputStream salida) throws Exception {
        byte[] iv = new byte[16];
        new SecureRandom().nextBytes(iv);

        // El IV se escribe en claro al inicio del fichero cifrado
        salida.write(iv);

        Cipher cipher = Cipher.getInstance(ALGORITMO);
        cipher.init(Cipher.ENCRYPT_MODE,
                new SecretKeySpec(CLAVE, "AES"),
                new IvParameterSpec(iv));

        try (CipherOutputStream cos = new CipherOutputStream(salida, cipher)) {
            byte[] buf = new byte[BUFFER];
            int leidos;
            while ((leidos = entrada.read(buf)) != -1) {
                cos.write(buf, 0, leidos);
            }
        }
    }

    public static void descifrarStream(InputStream entrada, OutputStream salida) throws Exception {
        // Leer los 16 bytes del IV del inicio del fichero
        byte[] iv = new byte[16];
        int total = 0;
        while (total < 16) {
            int n = entrada.read(iv, total, 16 - total);
            if (n == -1) throw new Exception("Fichero inválido: no se encontró el IV.");
            total += n;
        }

        Cipher cipher = Cipher.getInstance(ALGORITMO);
        cipher.init(Cipher.DECRYPT_MODE,
                new SecretKeySpec(CLAVE, "AES"),
                new IvParameterSpec(iv));

        try (CipherInputStream cis = new CipherInputStream(entrada, cipher)) {
            byte[] buf = new byte[BUFFER];
            int leidos;
            while ((leidos = cis.read(buf)) != -1) {
                salida.write(buf, 0, leidos);
            }
        }
    }
}

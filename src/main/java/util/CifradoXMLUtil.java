package util;

import org.apache.xml.security.encryption.XMLCipher;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.InputStream;
import java.io.OutputStream;

public class CifradoXMLUtil {

    private static final byte[] CLAVE = "ISDCMSecretKey16".getBytes();
    private static final String XENC_NS = "http://www.w3.org/2001/04/xmlenc#";

    static {
        org.apache.xml.security.Init.init();
    }

    public static void cifrar(InputStream xmlInput, OutputStream salida,
                              String tagElemento, boolean soloContenido) throws Exception {
        Document doc = parsear(xmlInput);

        SecretKey clave = new SecretKeySpec(CLAVE, "AES");
        XMLCipher xmlCipher = XMLCipher.getInstance(XMLCipher.AES_128);
        xmlCipher.init(XMLCipher.ENCRYPT_MODE, clave);

        Element elemento = seleccionarElemento(doc, tagElemento);
        xmlCipher.doFinal(doc, elemento, soloContenido);

        serializar(doc, salida);
    }

    public static void descifrar(InputStream xmlInput, OutputStream salida) throws Exception {
        Document doc = parsear(xmlInput);

        SecretKey clave = new SecretKeySpec(CLAVE, "AES");
        XMLCipher xmlCipher = XMLCipher.getInstance(XMLCipher.AES_128);
        xmlCipher.init(XMLCipher.DECRYPT_MODE, clave);

        NodeList nl = doc.getElementsByTagNameNS(XENC_NS, "EncryptedData");
        if (nl.getLength() == 0)
            throw new Exception("No se encontró ningún elemento cifrado en el XML.");

        xmlCipher.doFinal(doc, (Element) nl.item(0));

        serializar(doc, salida);
    }

    private static Element seleccionarElemento(Document doc, String tag) throws Exception {
        if (tag == null || tag.trim().isEmpty()) {
            return doc.getDocumentElement();
        }
        NodeList nl = doc.getElementsByTagNameNS("*", tag.trim());
        if (nl.getLength() == 0) nl = doc.getElementsByTagName(tag.trim());
        if (nl.getLength() == 0)
            throw new Exception("Elemento <" + tag + "> no encontrado en el XML.");
        return (Element) nl.item(0);
    }

    private static Document parsear(InputStream is) throws Exception {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        return dbf.newDocumentBuilder().parse(is);
    }

    private static void serializar(Document doc, OutputStream os) throws Exception {
        Transformer t = TransformerFactory.newInstance().newTransformer();
        t.setOutputProperty(OutputKeys.INDENT, "yes");
        t.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        t.transform(new DOMSource(doc), new StreamResult(os));
    }
}

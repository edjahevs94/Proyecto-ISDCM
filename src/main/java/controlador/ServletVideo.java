package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;

@WebServlet("/video/*")
public class ServletVideo extends HttpServlet {

    private static final String VIDEOS_DIR =
            System.getProperty("user.home") + "/isdcm_videos/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String filename = new File(pathInfo.substring(1)).getName();
        File file = new File(VIDEOS_DIR + filename);

        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) contentType = "application/octet-stream";

        long fileLength = file.length();
        String rangeHeader = request.getHeader("Range");

        response.setHeader("Accept-Ranges", "bytes");

        if (rangeHeader == null) {
            response.setContentType(contentType);
            response.setContentLengthLong(fileLength);
            try (InputStream is = new FileInputStream(file)) {
                is.transferTo(response.getOutputStream());
            }
        } else {
            String[] ranges = rangeHeader.replace("bytes=", "").split("-");
            long start = Long.parseLong(ranges[0]);
            long end = (ranges.length > 1 && !ranges[1].isEmpty())
                    ? Long.parseLong(ranges[1])
                    : fileLength - 1;
            long contentLength = end - start + 1;

            response.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT);
            response.setContentType(contentType);
            response.setContentLengthLong(contentLength);
            response.setHeader("Content-Range",
                    "bytes " + start + "-" + end + "/" + fileLength);

            try (RandomAccessFile raf = new RandomAccessFile(file, "r")) {
                raf.seek(start);
                byte[] buffer = new byte[8192];
                long remaining = contentLength;
                int read;
                while (remaining > 0 &&
                       (read = raf.read(buffer, 0, (int) Math.min(buffer.length, remaining))) != -1) {
                    response.getOutputStream().write(buffer, 0, read);
                    remaining -= read;
                }
            }
        }
    }
}

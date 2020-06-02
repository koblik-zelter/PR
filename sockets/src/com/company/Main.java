package com.company;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import java.io.*;
import java.net.*;
import java.util.ArrayDeque;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Main {

    public static void main(String[] args) throws IOException {
        ArrayDeque<String> images = new ArrayDeque<String>();
        String content = getContent();
        Pattern pattern = Pattern.compile("[a-zA-Z0-9\\/]*(\\.jpg|\\.png)");
                //"[a-zA-Z0-9]+.(png|jp[e]*g|gif)");
        Matcher matcher = pattern.matcher(content.toString());
        while (matcher.find()) {
              images.add(content.substring(matcher.start(), matcher.end()));
        }
        ImageManager manager = new ImageManager(images);
        manager.run();
    }

    public static String getContent()  throws IOException {
        InetAddress host = InetAddress.getByName("unite.md");
        Socket socket = new Socket(host, 80);
//        SSLSocketFactory factory = (SSLSocketFactory) SSLSocketFactory.getDefault();
//        SSLSocket socket = (SSLSocket) factory.createSocket("utm.md", 443);
//        socket.startHandshake();
        BufferedWriter wr =
                new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), "UTF8"));
        wr.write("GET / HTTP/1.1\r\n");
        wr.write("Host: unite.md\r\n");
        wr.write("Accept-Language: en, ru, ro\r\n");
        wr.write("Connection: keep-alive\r\n");
        wr.write("Keep-Alive: 300\r\n");
        wr.write("Cache-Control: no-cache\r\n");
        wr.write("Accept-Charset: utf-8, iso-8859-1;q=0.5\r\n");
        wr.write("\r\n");

        // Send parameters
        wr.flush();

        // Get response
        BufferedReader rd = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        boolean loop = true;
        StringBuilder sb = new StringBuilder(8096);
        while (loop) {
                int i = 0;
                while (i != -1) {
                    i = rd.read();
                    sb.append((char) i);
                }
                loop = false;
        }

        wr.close();
        rd.close();
        socket.close();
        return sb.toString();
    }
}

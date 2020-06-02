package com.company;

import javax.imageio.ImageIO;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import java.io.*;
import java.net.InetAddress;
import java.util.ArrayDeque;
import java.util.concurrent.Semaphore;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ImageManager {
    Semaphore threadsSem;
    Semaphore imageSem;
    ArrayDeque<String> imagesList;

    public ImageManager(ArrayDeque<String> imagesList) {
        this.threadsSem = new Semaphore(4);
        this.imageSem = new Semaphore(1);
        this.imagesList = imagesList;
    }

    private class MyThread1 extends Thread {
        String name;
        public MyThread1(String name) {
            this.name = name;
        }

        @Override
        public void run() {
            try {
                threadsSem.acquire();
                try {
                    while (!imagesList.isEmpty()) {
                        imageSem.acquire();
                        String imageLink = imagesList.pop();
                        imageSem.release();
                        downloadImage(imageLink);
                    }
                } catch (InterruptedException | IOException e) {
                    e.printStackTrace();
                }
                finally {
                    threadsSem.release();
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        public void downloadImage(String link) throws InterruptedException, IOException {
            InetAddress host = InetAddress.getByName("unite.md");
            CustomSocket socket = new CustomSocket(80,host,SocketManager.shared.getId());
//            SSLSocketFactory factory = (SSLSocketFactory) SSLSocketFactory.getDefault();
//            SSLSocket socket = (SSLSocket) factory.createSocket("utm.md", 443);
//            socket.startHandshake();
            BufferedWriter wr =
                    new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), "UTF8"));
            wr.write("GET " + link + " HTTP/1.1\r\n");
            wr.write("Host: unite.md\r\n");
            wr.write("Accept-Language: en, ru, ro\r\n");
            wr.write("Connection: keep-alive\r\n");
            wr.write("Keep-Alive: 300\r\n");
            wr.write("Cache-Control: no-cache\r\n");
            wr.write("Accept-Charset: utf-8, iso-8859-1;q=0.5\r\n");
            wr.write("\r\n");
            wr.flush();

            Pattern pattern = Pattern.compile("[a-zA-Z0-9]+(\\.jpg|\\.png)");
            //"[a-zA-Z0-9]+.(png|jp[e]*g|gif)");
            Matcher matcher = pattern.matcher(link);
            while (matcher.find()) {
                link = link.substring(matcher.start(), matcher.end());
            }

            if (link.isEmpty()) {
                wr.close();
                socket.close();
                return;
            }
            BufferedReader rd = new BufferedReader(new InputStreamReader(socket.getInputStream()));

            DataInputStream din = new DataInputStream(socket.getInputStream());

            OutputStream dout = new FileOutputStream(link);

            int count, offset;
            byte[] buffer = new byte[8096];
            boolean eohFound = false;


            while ((count = din.read(buffer)) != -1)
            {
                offset = 0;
                if (!eohFound)
                {
                    String string = new String(buffer, 0, count);
                    int indexOfEOH = string.indexOf("\r\n\r\n");
                    if (indexOfEOH != -1)
                    {
                        count = count - indexOfEOH - 4;
                        offset = indexOfEOH + 4;
                        eohFound = true;
                    }
                    else
                    {
                        count = 0;
                    }
                }
                dout.write(buffer, offset, count);
                dout.flush();
            }

            din.close();
            dout.close();
            rd.close();
            wr.close();
            socket.close();
            System.out.println("Image was downloaded on thread: " + MyThread.currentThread().getName());
        }
    }

    public void run() {
        MyThread1 thread = new MyThread1("test1");
        MyThread1 thread1 = new MyThread1("test2");
        MyThread1 thread2 = new MyThread1("test3");
        MyThread1 thread3 = new MyThread1("test4");
        MyThread1 thread4 = new MyThread1("test5");
        MyThread1 thread5 = new MyThread1("test6");

        thread.start();
        thread1.start();
        thread2.start();
        thread3.start();
        thread4.start();
        thread5.start();
    }
}


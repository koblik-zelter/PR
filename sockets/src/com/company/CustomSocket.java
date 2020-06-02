package com.company;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.Socket;

public class CustomSocket extends Socket {
    int id;
    BufferedReader reader;
    PrintWriter writer;

    public CustomSocket(int port, InetAddress host, int id) throws IOException {
        super(host, port);
        this.id = id;
    }
}

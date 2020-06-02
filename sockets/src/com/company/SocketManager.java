package com.company;

import java.util.ArrayList;

public class SocketManager {
    static SocketManager shared = new SocketManager();

    ArrayList<CustomSocket> sockets = new ArrayList<CustomSocket>();

    public int getId() {
        return sockets.size();
    }

    public CustomSocket getSocketWithId(int id) {
        return sockets.get(id);
    }

    public void addSocket(CustomSocket socket) {
        this.sockets.add(socket);
    }
}

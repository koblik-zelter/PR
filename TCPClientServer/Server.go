package main

import (
	"bytes"
	"container/list"
	"encoding/json"
	"fmt"
	"net"
	"strings"
)

var clients *list.List
var broadcast = make(chan Message)

//Message is used in transporting individual messages
type Message struct {
	Username   string
	Message    string
	StatusCode int
}

func main() {
	fmt.Println("Server Started")
	clients = list.New()
	server, err := net.Listen("tcp", ":8081")
	defer server.Close()
	if err != nil {
		fmt.Println(err.Error())
		return
	}
	fmt.Println(server)

	for {
		client, err := server.Accept()
		if err != nil {
			fmt.Println(err.Error())
			return
		}
		clients.PushBack(client)

		go handleUser(client)
		go sendMessages(broadcast)
	}
}

func handleUser(socket net.Conn) {
	for {
		buf := make([]byte, 2048)
		_, err := socket.Read(buf)
		fmt.Println("I am here")
		if err != nil {
			fmt.Println("Error reading:", err.Error())
			socket.Close()
			return
		}

		buf = bytes.Trim(buf, "\x00")

		content := string(buf)
		if content == "" {
			continue
		}

		entries := strings.Split(content, ";")

		json := make(map[string]string)
		for _, e := range entries {
			parts := strings.Split(e, ":")
			json[parts[0]] = parts[1]
		}

		fmt.Println(json)
		// Our Protocol -> if message then format "msg:blablabla\n from:username\n statusCode: 200" (200 if simple message)
		//				   if user then format "iam:username" -> "msg: New User with Username\n newUser: 201" (201 if new User)
		if _, ok := json["iam"]; ok {
			newUser := Message{json["iam"], "New User with Username ", 201}
			broadcast <- newUser
			continue
		}

		if _, ok := json["Message"]; ok {
			message := Message{json["Username"], json["Message"], 200}
			broadcast <- message
		}
	}
}

func sendMessages(messages chan Message) {
	//Loop continually sending messages
	for {
		msg := <-messages
		data, err := json.Marshal(msg)

		if err != nil {
			fmt.Println(err.Error())
			continue
		}

		for i := clients.Front(); i != nil; i = i.Next() {
			//Send message to group
			_, err := (i.Value.(net.Conn)).Write([]byte(data))
			if err != nil {
				clients.Remove(i)
			}
		}
	}
}

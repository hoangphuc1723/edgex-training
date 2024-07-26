package main

import (
	"fmt"
	"strings"
)

func main() {

	subscribedTopic := "incoming/data/#"
	incomingTopic := "incoming/data/#"
	subscribedTopic = strings.Replace(subscribedTopic, "#", "", -1)
	incomingTopic = strings.Replace(incomingTopic, subscribedTopic, "", -1)

	// metaData := strings.Split(incomingTopic, "/")
	fmt.Println(subscribedTopic)

}

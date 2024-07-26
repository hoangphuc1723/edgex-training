import paho.mqtt.client as mqtt

# Define the connection parameters
broker = '192.168.103.231'
port = 1883
client_id = 'device-mqtt-1'

# Create an MQTT client instance
client = mqtt.Client(client_id)

# Define the callback for connection events
def on_connect(client, userdata, flags, rc):
    print(f"Connected with result code {rc}")

# Attach the callback function
client.on_connect = on_connect

# Connect to the MQTT broker
client.connect(broker, port, 60)

# Start the network loop to process network traffic
client.loop_start()

# To keep the script running to maintain the connection
try:
    while True:
        pass
except KeyboardInterrupt:
    print("Disconnected.")
    client.loop_stop()
    client.disconnect()

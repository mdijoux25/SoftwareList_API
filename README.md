# SoftwareList_API 

SoftwareList_API is an API to collect hardware and software information on computer.


## Installation (Web API)
1. Download nodejs [https://nodejs.org/en/download/](https://nodejs.org/en/download/) and install
2. Run the following:

```
git clone https://github.com/mdijoux25/SoftwareList_API
cd SoftwareList_API
npm install 
npm start
```
![Web API installation](./Media/install.gif)

### Requirements (Web API)
- Internet facing system (e.g. netlify, Azure AppService, self-hosted)
- Nodejs
- DNS record for web API (suggested)

### Testing the Web API
You can test the API from an external system with the following commands:

```
# Mac or Linux via Curl
curl http(s)://<YOUR WEB ADDRESS>:8000/
```
or

```
# Windows Powershell
Invoke-WebRequest -Uri http(s)://<YOUR WEB ADDRESS>:8000/ -Method GET
```

If you recieve a `Successfull connection`, proceed to the next step. Otherwise you will need to troubleshoot your network.

## Deploying the Powershell Script
Once the web API is running, you need to  execute the following command on the remote hosts:

```
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; (new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/mdijoux25/SoftwareList_API/master/Script/List-Software.ps1") | iex; getsoftware https://<server URI>:8000/list
```

If you are using a self-signed certificate for SSL/TLS communication, you will need to bypass powershell's certificate validation check with the following:
```
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true};(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/mdijoux25/SoftwareList_API/master/Script/List-Software.ps1") | iex; getsoftware https://<server URI>:8000/list
```

This script will set the system up for secure communications, download the `List-software.ps1` script and run the module using your web API URL. Note that you will have to change the `<server URI>` to the IP address or hostname you have configured for the web API. Also, you must have the `/list` path at the end of the URL.

## Retrieving the Registration Data
- Once the systems have executed the Powershell script, you can retrieve the CSV file from the `data` directory for each machine.
- You also will have a JSON folder with each `Hostname.json` so you can tranform it for you convenient.
- A logfile will be generate too `Software-Listing.log`

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[ISC]
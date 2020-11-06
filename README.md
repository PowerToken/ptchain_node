## PowerToken Node

Official Golang implementation of the PowerToken protocol.

## Building the source

For prerequisites and detailed build instructions please read the [Installation Instructions](https://github.com/PowerToken/ptchain_node/wiki/Building-Ethereum) on the wiki.

Building `gpt` requires both a Go (version 1.13 or later) and a C compiler. You can install
them using your favourite package manager. Once the dependencies are installed, run

```shell
make gpt
```

## Executables

The PowerToken project comes with several wrappers/executables found in the `cmd`
directory.

|    Command    | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| :-----------: | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|  **`gpt`**   | Our main PowerToken CLI client. It is the entry point into the PowerToken network, capable of running as a full node (default), archive node (retaining all historical state) or a light node (retrieving data live). It can be used by other processes as a gateway into the PowerToken network via JSON RPC endpoints exposed on top of HTTP, WebSocket and/or IPC transports. `gpt --help` for command line options.          |

## Running `gpt`

### Programmatically interfacing `gpt` nodes

As a developer, sooner rather than later you'll want to start interacting with `gpt` and the
PowerToken network via your own programs and not manually through the console. To aid
this, `gpt` has built-in support for a JSON-RPC based APIs ([standard APIs](https://github.com/ethereum/wiki/wiki/JSON-RPC)).
These can be exposed via HTTP, WebSockets and IPC (UNIX sockets on UNIX based
platforms, and named pipes on Windows).

HTTP based JSON-RPC API options:

  * `--http` Enable the HTTP-RPC server
  * `--http.addr` HTTP-RPC server listening interface (default: `localhost`)
  * `--http.port` HTTP-RPC server listening port (default: `10444`)
  * `--http.api` API's offered over the HTTP-RPC interface (default: `eth,net,web3`)
  * `--http.corsdomain` Comma separated list of domains from which to accept cross origin requests (browser enforced)
  * `--ws` Enable the WS-RPC server
  * `--ws.addr` WS-RPC server listening interface (default: `localhost`)
  * `--ws.port` WS-RPC server listening port (default: `10445`)
  * `--ws.api` API's offered over the WS-RPC interface (default: `eth,net,web3`)
  * `--ws.origins` Origins from which to accept websockets requests

You'll need to use your own programming environments' capabilities (libraries, tools, etc) to
connect via HTTP, WS or IPC to a `gpt` node configured with the above flags and you'll
need to speak [JSON-RPC](https://www.jsonrpc.org/specification) on all transports. You
can reuse the same connection for multiple requests!

**Note: Please understand the security implications of opening up an HTTP/WS based
transport before doing so! Hackers on the internet are actively trying to subvert
PowerToken nodes with exposed APIs! Further, all browser tabs can access locally
running web servers, so malicious web pages could try to subvert locally available
APIs!**

#### Defining the private genesis state

First, you'll need to create the genesis state of your networks, which all nodes need to be
aware of and agree upon. This consists of a small JSON file (e.g. call it `genesis.json`):

```json
{
  "config": {
    "chainId": 198553,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "clique": {
      "period": 12,
      "epoch": 30000
    }
  },
  "nonce": "0x0",
  "timestamp": "0x5f699d81",
  "extraData": "0x00000000000000000000000000000000000000000000000000000000000000004304943f2232c924ed54058c522805982c899f7987dee17fd2f2a87ade89d437e4bd26f23d7d922adcc34f9011f7b7e53086798809a342adf09f6ca70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  "gasLimit": "0x47b760",
  "difficulty": "0x1",
  "mixHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "alloc": {
    "52e6a0aeca1ca107deb6e21add292aa112e140d1": {
      "balance": "0x12d17ff8a0b61e0ec000000"
    }
  },
  "number": "0x0",
  "gasUsed": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000"
}
```

With the genesis state defined in the above JSON file, you'll need to initialize **every**
`gpt` node with it prior to starting it up to ensure all blockchain parameters are correctly
set:

```shell
$ gpt init path/to/genesis.json
```

### Full node on the main PowerToken network

By far the most common scenario is people wanting to simply interact with the PowerToken
network: create accounts; transfer funds; deploy and interact with contracts. For this
particular use-case the user doesn't care about years-old historical data, so we can
fast-sync quickly to the current state of the network. To do so:

```shell
gpt --syncmode "fast" --txpool.pricelimit 0
```

This command will:
 * Start `gpt` in fast sync mode (default, can be changed with the `--syncmode` flag),
   causing it to download more data in exchange for avoiding processing the entire history
   of the PowerToken network, which is very CPU intensive.

#### Docker quick start

One of the quickest ways to get PowerToken up and running on your machine is by using [Docker](https://gitlab.com/powertoken/ptchain_normal_node):

## License

The PowerToken library (i.e. all code outside of the `cmd` directory) is licensed under the
[GNU Lesser General Public License v3.0](https://www.gnu.org/licenses/lgpl-3.0.en.html),
also included in our repository in the `COPYING.LESSER` file.

The PowerToken binaries (i.e. all code inside of the `cmd` directory) is licensed under the
[GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html), also
included in our repository in the `COPYING` file.

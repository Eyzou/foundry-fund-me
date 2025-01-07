## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

lancer les tests:
forge test -vvvv --fork-url RPC URL SEPOLIA

tester le coverage des tests:
source .env
forge coverage --fork-url RPC URL SEPOLIA
f

Knowledge:
    // STORAGE is a list//Array of all the variable - that persists and stored. each slot is 32 bytes long.
    // DYNAMIC VALUE LIKE A MAPPING// ARRAY - remain inside the mapping (hashing function).
    // the storage is only the length of the array or nil if mapping
    // immutable and const are NOT in STORAGE! its a pointer to the value.
    // Variable inside function are not permanent - and are deleted.
    // we need memory keyword for string /array - memory or storage? need to be precised.
    // command forget inspect FundMe storageLayout to see the STORAGE
    // command cast storage
    // everything is visible on the bc even private keyword
    // evm.codes to see gas costs for each operation 33x more expensive to read/write from STORAGE# foundry-fund-me
